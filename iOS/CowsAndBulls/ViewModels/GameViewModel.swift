import SwiftUI
import Combine

/// Main ViewModel governing the Cows and Bulls iOS game state and user actions.
public class GameViewModel: ObservableObject {
    @Published public private(set) var engine: GameEngine
    @Published public var currentInput: [Character] = []
    @Published public var errorMessage: String? = nil
    
    // Modals and Alerts
    @Published public var showConcedeAlert: Bool = false
    @Published public var showVictoryModal: Bool = false
    @Published public var showGameOverModal: Bool = false
    @Published public var showRulesSheet: Bool = false
    
    // Customization
    @Published public var isCartoonMode: Bool = true // Cartoon icons default on iOS per plan.txt
    
    // Services
    private let soundManager = SoundManager.shared
    private let hapticManager = HapticManager.shared
    
    public init(engine: GameEngine = GameEngine()) {
        self.engine = engine
    }
    
    // MARK: - Computed Properties
    
    public var attempts: [Attempt] {
        engine.attempts
    }
    
    public var attemptsUsed: Int {
        engine.attempts.count
    }
    
    public var maxAttempts: Int {
        engine.config.maxAttempts
    }
    
    public var attemptsRemaining: Int {
        max(0, maxAttempts - attemptsUsed)
    }
    
    public var isInputComplete: Bool {
        currentInput.count == engine.config.codeLength
    }
    
    public var canLockIn: Bool {
        isInputComplete && !engine.state.isGameOver
    }
    
    public var revealedSecret: String? {
        switch engine.state {
        case .won(_, let secret), .lost(let secret), .conceded(let secret):
            return secret
        default:
            return nil
        }
    }
    
    public var latestQuirkyCommentary: String? {
        attempts.last?.score.quirkyCommentary
    }
    
    // MARK: - Actions
    
    public func startNewGame() {
        engine = GameEngine()
        currentInput.removeAll()
        errorMessage = nil
        showVictoryModal = false
        showGameOverModal = false
        hapticManager.digitTapped()
    }
    
    public func appendDigit(_ char: Character) {
        guard !engine.state.isGameOver else { return }
        errorMessage = nil
        
        // Disallow duplicates
        if currentInput.contains(char) {
            errorMessage = "Digits must be unique!"
            hapticManager.error()
            return
        }
        
        guard currentInput.count < engine.config.codeLength else {
            return
        }
        
        currentInput.append(char)
        hapticManager.digitTapped()
        soundManager.playDigitTap()
    }
    
    public func deleteDigit() {
        guard !currentInput.isEmpty else { return }
        errorMessage = nil
        currentInput.removeLast()
        hapticManager.digitTapped()
        soundManager.playDelete()
    }
    
    public func clearInput() {
        currentInput.removeAll()
        errorMessage = nil
    }
    
    public func isDigitUsed(_ char: Character) -> Bool {
        currentInput.contains(char)
    }
    
    /// Locks in the current 4 digits as an official attempt.
    public func lockInGuess() {
        guard canLockIn else { return }
        
        let guessString = String(currentInput)
        let result = engine.submitGuess(guessString)
        
        switch result {
        case .invalidInput(let error):
            errorMessage = error.localizedDescription
            hapticManager.error()
            
        case .success(let attempt, let newState):
            currentInput.removeAll()
            errorMessage = nil
            hapticManager.guessLockedIn()
            soundManager.playGuessSubmitted(bulls: attempt.score.bulls, cows: attempt.score.cows)
            
            switch newState {
            case .won:
                hapticManager.victory()
                soundManager.playVictory()
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.35) {
                    self.showVictoryModal = true
                }
            case .lost:
                hapticManager.defeat()
                soundManager.playLoss()
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.35) {
                    self.showGameOverModal = true
                }
            default:
                break
            }
            
        case .gameOver:
            break
        }
    }
    
    /// Concedes the game early.
    public func confirmConcede() {
        engine.concede()
        hapticManager.defeat()
        soundManager.playConcede()
        showGameOverModal = true
    }
}
