import Foundation
import CowsAndBullsCore

public class CLIApp {
    private let soundEffect = SoundEffect.shared
    private let renderer = BoardRenderer()
    
    private var explicitConfirm: Bool = false
    private var presetSecret: String? = nil
    
    public init() {}
    
    public func run(arguments: [String]) {
        parseArguments(arguments)
        
        var keepPlaying = true
        while keepPlaying {
            playSingleGame()
            keepPlaying = askPlayAgain()
        }
        
        print("\(ANSI.cyan)Thanks for playing Cows and Bulls! See you on the farm! 👋🐮\(ANSI.reset)\n")
    }
    
    private func parseArguments(_ args: [String]) {
        var i = 1
        while i < args.count {
            let arg = args[i]
            switch arg {
            case "--cartoon", "-c":
                renderer.mode = .cartoon
            case "--mute", "-m":
                soundEffect.isEnabled = false
            case "--confirm":
                explicitConfirm = true
            case "--secret":
                if i + 1 < args.count {
                    i += 1
                    presetSecret = args[i]
                }
            case "--help", "-h":
                printUsage()
                exit(0)
            default:
                break
            }
            i += 1
        }
    }
    
    private func printUsage() {
        print("""
        Usage: cows-and-bulls [options]
        
        Options:
          -c, --cartoon         Use cartoon emoji icons (🐂 / 🐮) instead of classic B / C
          -m, --mute            Disable all audio and voice feedback
          --confirm             Explicitly ask for confirmation to lock in each guess
          --secret <codeLength> Specify a secret code for testing/debugging
          -h, --help            Show this help message
        
        In-Game Commands:
          quit / concede        Surrender the round and reveal the secret
          mode / m              Toggle between Classic [B/C] and Cartoon [🐂/🐮]
          sound / s             Toggle audio feedback on/off
          help / h              Show game rules
        """)
    }
    
    private func playSingleGame() {
        let engine: GameEngine
        if let preset = presetSecret {
            engine = GameEngine(secret: preset)
        } else {
            engine = GameEngine()
        }
        
        // Print clear screen sequence or banner
        print("\u{001B}[2J\u{001B}[H", terminator: "")
        print(renderer.renderHeader(engine: engine))
        print(renderer.renderBoard(engine: engine))
        
        while !engine.state.isGameOver {
            let currentAttemptNum = engine.attempts.count + 1
            print("\(ANSI.bold)\(ANSI.magenta)[Attempt \(currentAttemptNum)/\(engine.config.maxAttempts)]\(ANSI.reset) Enter 4 unique digits (or 'c' to concede): ", terminator: "")
            fflush(stdout)
            
            guard let line = readLine() else {
                // EOF (Ctrl+D) -> Treat as quit
                print("\n")
                let secret = engine.concede()
                soundEffect.onConcede()
                print(renderer.renderConcede(secret: secret))
                return
            }
            
            let trimmed = line.trimmingCharacters(in: .whitespacesAndNewlines)
            
            // Handle empty input
            if trimmed.isEmpty {
                print("\(ANSI.yellow)⚠️ Please enter 4 digits or a command (type 'help' for instructions).\(ANSI.reset)\n")
                continue
            }
            
            // Handle commands
            let lower = trimmed.lowercased()
            if lower == "quit" || lower == "concede" || lower == "surrender" || lower == "c" || lower == "q" {
                let secret = engine.concede()
                soundEffect.onConcede()
                print(renderer.renderConcede(secret: secret))
                return
            }
            
            if lower == "mode" || lower == "m" {
                renderer.mode = (renderer.mode == .classic) ? .cartoon : .classic
                print("\u{001B}[2J\u{001B}[H", terminator: "")
                print(renderer.renderHeader(engine: engine))
                print(renderer.renderBoard(engine: engine))
                print("\(ANSI.green)Switched display mode to: \(renderer.mode == .classic ? "Classic [B / C]" : "Cartoon [🐂 / 🐮]")\(ANSI.reset)\n")
                continue
            }
            
            if lower == "sound" || lower == "s" || lower == "mute" {
                soundEffect.isEnabled.toggle()
                let status = soundEffect.isEnabled ? "ENABLED 🔊" : "MUTED 🔇"
                print("\(ANSI.cyan)Audio feedback is now \(status).\(ANSI.reset)\n")
                continue
            }
            
            if lower == "help" || lower == "h" || lower == "?" {
                printInstructions()
                continue
            }
            
            // Validate guess before locking in
            switch GuessValidator.validate(guess: trimmed, config: engine.config) {
            case .failure(let error):
                print("\(ANSI.red)⚠️ Invalid Guess: \(error.localizedDescription)\(ANSI.reset)\n")
                continue
                
            case .success(let validGuess):
                if explicitConfirm {
                    print("🔒 Lock in guess [ \(validGuess) ] as Attempt #\(currentAttemptNum)? [Y/n]: ", terminator: "")
                    fflush(stdout)
                    let confirmLine = readLine()?.trimmingCharacters(in: .whitespacesAndNewlines).lowercased() ?? "y"
                    if confirmLine == "n" || confirmLine == "no" {
                        print("\(ANSI.yellow)Guess cancelled. Enter a new guess.\(ANSI.reset)\n")
                        continue
                    }
                }
                
                print("🔒 Locked in attempt: \(ANSI.bold)\(validGuess)\(ANSI.reset)")
                
                // Submit guess
                let result = engine.submitGuess(validGuess)
                
                // Re-render full board with all attempts in clear view
                print("\u{001B}[2J\u{001B}[H", terminator: "")
                print(renderer.renderHeader(engine: engine))
                print(renderer.renderBoard(engine: engine))
                
                if case .success(let attempt, let state) = result {
                    // Play audio feedback
                    soundEffect.onGuess(bulls: attempt.score.bulls, cows: attempt.score.cows)
                    
                    switch state {
                    case .won(let attemptsCount, let secret):
                        soundEffect.onWin()
                        print(renderer.renderVictory(engine: engine, attemptsUsed: attemptsCount, secret: secret))
                    case .lost(let secret):
                        soundEffect.onLoss()
                        print(renderer.renderLoss(engine: engine, secret: secret))
                    default:
                        break
                    }
                }
            }
        }
    }
    
    private func printInstructions() {
        print("""
        \(ANSI.bold)\(ANSI.cyan)─── HOW TO PLAY ────────────────────────────────────────────────\(ANSI.reset)
        • The computer chooses a secret 4-digit code using unique digits (0-9).
        • For every digit in your guess that matches the digit and EXACT position -> BULL (B / 🐂).
        • For every digit that is in the code but in the WRONG position -> COW (C / 🐮).
        • You have up to 20 attempts to get 4 Bulls and win the game!
        • Type 'quit' or 'concede' at any time to give up and reveal the secret.
        \(ANSI.bold)\(ANSI.cyan)────────────────────────────────────────────────────────────────\(ANSI.reset)
        """)
    }
    
    private func askPlayAgain() -> Bool {
        print("Would you like to play another round? [y/N]: ", terminator: "")
        fflush(stdout)
        guard let line = readLine()?.trimmingCharacters(in: .whitespacesAndNewlines).lowercased() else {
            return false
        }
        return line == "y" || line == "yes"
    }
}
