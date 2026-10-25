import Foundation

/// Current lifecycle status of a game.
public enum GameState: Equatable {
    case ready
    case inProgress(attemptsRemaining: Int)
    case won(attemptsCount: Int, secret: String)
    case lost(secret: String)
    case conceded(secret: String)
    
    public var isGameOver: Bool {
        switch self {
        case .won, .lost, .conceded:
            return true
        case .ready, .inProgress:
            return false
        }
    }
}

/// Result of evaluating a player's guess.
public enum GuessResult: Equatable {
    case success(attempt: Attempt, state: GameState)
    case invalidInput(error: ValidationError)
    case gameOver(state: GameState)
}

/// The core engine driving game state and rules evaluation.
public class GameEngine {
    public let config: GameConfig
    public let secret: String
    
    public private(set) var attempts: [Attempt] = []
    public private(set) var state: GameState
    
    public init(secret: String, config: GameConfig = .default) {
        self.secret = secret
        self.config = config
        self.state = .inProgress(attemptsRemaining: config.maxAttempts)
    }
    
    public convenience init(
        generator: SecretGeneratorProtocol = RandomSecretGenerator(),
        config: GameConfig = .default
    ) {
        let generatedSecret = generator.generateSecret(config: config)
        self.init(secret: generatedSecret, config: config)
    }
    
    /// Calculate Bulls and Cows for a guess against a secret code.
    public static func score(secret: String, guess: String) -> Score {
        let sChars = Array(secret)
        let gChars = Array(guess)
        let count = min(sChars.count, gChars.count)
        
        var bulls = 0
        var secretRemaining: [Character: Int] = [:]
        var guessRemaining: [Character: Int] = [:]
        
        for i in 0..<count {
            if sChars[i] == gChars[i] {
                bulls += 1
            } else {
                secretRemaining[sChars[i], default: 0] += 1
                guessRemaining[gChars[i], default: 0] += 1
            }
        }
        
        var cows = 0
        for (char, gCount) in guessRemaining {
            if let sCount = secretRemaining[char] {
                cows += min(gCount, sCount)
            }
        }
        
        return Score(bulls: bulls, cows: cows)
    }
    
    /// Submit a guess. If the guess is valid, it records an attempt and updates the game state.
    public func submitGuess(_ rawGuess: String) -> GuessResult {
        guard !state.isGameOver else {
            return .gameOver(state: state)
        }
        
        switch GuessValidator.validate(guess: rawGuess, config: config) {
        case .failure(let error):
            return .invalidInput(error: error)
            
        case .success(let validGuess):
            let attemptNumber = attempts.count + 1
            let calculatedScore = GameEngine.score(secret: secret, guess: validGuess)
            let attempt = Attempt(number: attemptNumber, guess: validGuess, score: calculatedScore)
            attempts.append(attempt)
            
            if calculatedScore.isVictory(codeLength: config.codeLength) {
                state = .won(attemptsCount: attemptNumber, secret: secret)
            } else if attempts.count >= config.maxAttempts {
                state = .lost(secret: secret)
            } else {
                let remaining = config.maxAttempts - attempts.count
                state = .inProgress(attemptsRemaining: remaining)
            }
            
            return .success(attempt: attempt, state: state)
        }
    }
    
    /// Surrender/concede early. Returns the secret code.
    @discardableResult
    public func concede() -> String {
        guard !state.isGameOver else {
            switch state {
            case .won(_, let secret), .lost(let secret), .conceded(let secret):
                return secret
            default:
                return secret
            }
        }
        state = .conceded(secret: secret)
        return secret
    }
}
