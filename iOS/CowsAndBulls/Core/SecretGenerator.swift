import Foundation

/// Protocol for generating secret codes.
public protocol SecretGeneratorProtocol {
    func generateSecret(config: GameConfig) -> String
}

/// Default generator creating pseudo-random unique digits.
public struct RandomSecretGenerator: SecretGeneratorProtocol {
    public init() {}
    
    public func generateSecret(config: GameConfig = .default) -> String {
        var availableDigits = Array(config.allowedDigits)
        var secret = ""
        
        for _ in 0..<config.codeLength {
            guard !availableDigits.isEmpty else { break }
            let randomIndex = Int.random(in: 0..<availableDigits.count)
            let chosen = availableDigits.remove(at: randomIndex)
            secret.append(chosen)
        }
        
        return secret
    }
}

/// Deterministic generator used for automated testing.
public struct FixedSecretGenerator: SecretGeneratorProtocol {
    public let fixedSecret: String
    
    public init(fixedSecret: String) {
        self.fixedSecret = fixedSecret
    }
    
    public func generateSecret(config: GameConfig = .default) -> String {
        return fixedSecret
    }
}
