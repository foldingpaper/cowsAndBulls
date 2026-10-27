import Foundation
import CowsAndBullsCore

public enum DisplayMode {
    case classic   // Default 'B' and 'C'
    case cartoon   // Cartoon '🐂' and '🐮'
}

public struct ANSI {
    public static let reset   = "\u{001B}[0m"
    public static let bold    = "\u{001B}[1m"
    public static let dim     = "\u{001B}[2m"
    
    public static let red     = "\u{001B}[31m"
    public static let green   = "\u{001B}[32m"
    public static let yellow  = "\u{001B}[33m"
    public static let blue    = "\u{001B}[34m"
    public static let magenta = "\u{001B}[35m"
    public static let cyan    = "\u{001B}[36m"
    public static let white   = "\u{001B}[37m"
    
    public static let bgBlue  = "\u{001B}[44m"
}

public class BoardRenderer {
    public static var introQuotes: [String] {
        QuoteProvider.shared.quotes
    }

    public var mode: DisplayMode = .classic
    public var currentIntroQuote: String
    private let quoteProvider: QuoteProvider
    
    public init(mode: DisplayMode = .classic, quoteProvider: QuoteProvider = .shared) {
        self.mode = mode
        self.quoteProvider = quoteProvider
        self.currentIntroQuote = quoteProvider.randomQuote()
    }

    public func cycleIntroQuote() {
        currentIntroQuote = quoteProvider.randomQuote(excluding: currentIntroQuote)
    }
    
    /// Renders the main game header and instructions
    public func renderHeader(engine: GameEngine) -> String {
        var output = ""
        output += "\(ANSI.bold)\(ANSI.cyan)╔═══════════════════════════════════════════════════════════════════╗\(ANSI.reset)\n"
        output += "\(ANSI.bold)\(ANSI.cyan)║                   🐂 COWS AND BULLS 🐮                            ║\(ANSI.reset)\n"
        output += "\(ANSI.bold)\(ANSI.cyan)╚═══════════════════════════════════════════════════════════════════╝\(ANSI.reset)\n"
        output += "\(ANSI.bold)\(ANSI.yellow)🌾 \(currentIntroQuote)\(ANSI.reset)\n\n"
        output += "\(ANSI.dim)Rules: Guess 4 unique digits (0-9). Max \(engine.config.maxAttempts) attempts.\(ANSI.reset)\n"
        output += "\(ANSI.dim)Commands: 'quit' / 'concede' to surrender | 'mode' to toggle B/C vs 🐂/🐮 | 'sound' to toggle audio\(ANSI.reset)\n"
        
        let modeDesc = (mode == .classic)
            ? "Classic [B / C]  (Tip: Type 'mode' for cartoon 🐂 / 🐮 icons!)"
            : "Cartoon [🐂 / 🐮]  (Type 'mode' for classic B / C)"
        output += "\(ANSI.dim)Mode: \(ANSI.yellow)\(modeDesc)\(ANSI.reset)\n"
        return output
    }
    
    /// Renders the attempt history board with all past attempts in clear view.
    public func renderBoard(engine: GameEngine) -> String {
        var output = ""
        let attempts = engine.attempts
        
        if attempts.isEmpty {
            output += "\n\(ANSI.dim)No attempts yet. Make your first 4-digit guess below!\(ANSI.reset)\n\n"
            return output
        }
        
        output += "\n"
        output += "\(ANSI.cyan)┌──────┬──────────────┬──────────────────┬──────────────────┐\(ANSI.reset)\n"
        
        let bullHeader = mode == .classic ? "Bulls (B)" : "Bulls (🐂)"
        let cowHeader  = mode == .classic ? "Cows (C)"  : "Cows (🐮)"
        
        output += "\(ANSI.bold)\(ANSI.cyan)│ "
        output += pad("Att#", visibleLength: 4, toWidth: 4) + " │ "
        output += pad("Guess", visibleLength: 5, toWidth: 12) + " │ "
        output += pad(bullHeader, visibleLength: visualLength(bullHeader), toWidth: 16) + " │ "
        output += pad(cowHeader, visibleLength: visualLength(cowHeader), toWidth: 16) + " │\(ANSI.reset)\n"
        output += "\(ANSI.cyan)├──────┼──────────────┼──────────────────┼──────────────────┤\(ANSI.reset)\n"
        
        for attempt in attempts {
            let spacedGuess = attempt.guess.map { String($0) }.joined(separator: " ")
            let bullsStr: String
            let cowsStr: String
            
            switch mode {
            case .classic:
                bullsStr = attempt.score.bulls > 0 ? String(repeating: "B ", count: attempt.score.bulls).trimmingCharacters(in: .whitespaces) : "-"
                cowsStr  = attempt.score.cows > 0 ? String(repeating: "C ", count: attempt.score.cows).trimmingCharacters(in: .whitespaces) : "-"
            case .cartoon:
                bullsStr = attempt.score.bulls > 0 ? String(repeating: "🐂", count: attempt.score.bulls) : "-"
                cowsStr  = attempt.score.cows > 0 ? String(repeating: "🐮", count: attempt.score.cows) : "-"
            }
            
            let coloredBulls = attempt.score.bulls > 0 ? "\(ANSI.green)\(ANSI.bold)\(bullsStr)\(ANSI.reset)" : "\(ANSI.dim)\(bullsStr)\(ANSI.reset)"
            let coloredCows  = attempt.score.cows > 0 ? "\(ANSI.yellow)\(ANSI.bold)\(cowsStr)\(ANSI.reset)" : "\(ANSI.dim)\(cowsStr)\(ANSI.reset)"
            
            let attStr = String(format: "%02d", attempt.number)
            output += "│ " + pad(attStr, visibleLength: attStr.count, toWidth: 4) + " │ "
            output += pad(spacedGuess, visibleLength: spacedGuess.count, toWidth: 12) + " │ "
            output += pad(coloredBulls, visibleLength: visualLength(bullsStr), toWidth: 16) + " │ "
            output += pad(coloredCows, visibleLength: visualLength(cowsStr), toWidth: 16) + " │\n"
        }
        
        output += "\(ANSI.cyan)└──────┴──────────────┴──────────────────┴──────────────────┘\(ANSI.reset)\n"
        
        let remaining = engine.config.maxAttempts - attempts.count
        output += "\(ANSI.dim)Attempts Used: \(ANSI.bold)\(attempts.count)/\(engine.config.maxAttempts)\(ANSI.reset)  |  "
        output += "\(ANSI.dim)Remaining: \(remaining > 5 ? ANSI.green : ANSI.red)\(ANSI.bold)\(remaining)\(ANSI.reset)\n\n"
        
        // Show quirky commentary for latest attempt
        if let last = attempts.last {
            output += "\(ANSI.magenta)» \(last.score.quirkyCommentary)\(ANSI.reset)\n\n"
        }
        
        return output
    }
    
    /// Visual width calculation considering emoji widths
    private func visualLength(_ string: String) -> Int {
        var length = 0
        for scalar in string.unicodeScalars {
            // Basic emoji range detection for width 2
            if scalar.value >= 0x1F300 && scalar.value <= 0x1FAFF {
                length += 2
            } else {
                length += 1
            }
        }
        return length
    }
    
    private func pad(_ text: String, visibleLength: Int, toWidth width: Int) -> String {
        let paddingNeeded = max(0, width - visibleLength)
        return text + String(repeating: " ", count: paddingNeeded)
    }
    
    /// Celebratory victory display
    public func renderVictory(engine: GameEngine, attemptsUsed: Int, secret: String) -> String {
        var output = ""
        output += "\n"
        output += "\(ANSI.green)\(ANSI.bold)"
        output += "╔═══════════════════════════════════════════════════════════════════╗\n"
        output += "║                                                                   ║\n"
        output += "║       🎉 🏆 CONGRATULATIONS! YOU CRACKED THE CODE! 🏆 🎉         ║\n"
        output += "║                                                                   ║\n"
        output += "╚═══════════════════════════════════════════════════════════════════╝\n"
        output += "\(ANSI.reset)\n"
        output += "\(ANSI.bold)⭐ Secret Code : \(ANSI.green)[ \(secret.map { String($0) }.joined(separator: " ")) ]\(ANSI.reset)\n"
        output += "\(ANSI.bold)⭐ Attempts    : \(ANSI.yellow)\(attemptsUsed) / \(engine.config.maxAttempts)\(ANSI.reset)\n"
        
        let performanceMsg: String
        switch attemptsUsed {
        case 1...4:
            performanceMsg = "🧠 Mind-blowing psychic powers! Are you reading the computer's memory?!"
        case 5...8:
            performanceMsg = "⚡ Incredible detective work! Sherlock Holmes would be jealous!"
        case 9...14:
            performanceMsg = "🎯 Solid logical deductions! Masterful puzzle solving!"
        default:
            performanceMsg = "😅 Down to the wire, but you prevailed like a true champion!"
        }
        
        output += "\(ANSI.cyan)\(performanceMsg)\(ANSI.reset)\n\n"
        return output
    }
    
    /// Empathetic game over (loss) display
    public func renderLoss(engine: GameEngine, secret: String) -> String {
        var output = ""
        output += "\n"
        output += "\(ANSI.red)\(ANSI.bold)"
        output += "╔═══════════════════════════════════════════════════════════════════╗\n"
        output += "║                                                                   ║\n"
        output += "║           ❤️  GAME OVER - BETTER LUCK NEXT TIME! ❤️                ║\n"
        output += "║                                                                   ║\n"
        output += "╚═══════════════════════════════════════════════════════════════════╝\n"
        output += "\(ANSI.reset)\n"
        output += "\(ANSI.bold)The secret code was: \(ANSI.yellow)[ \(secret.map { String($0) }.joined(separator: " ")) ]\(ANSI.reset)\n\n"
        output += "\(ANSI.dim)You reached the maximum limit of \(engine.config.maxAttempts) attempts.\(ANSI.reset)\n"
        output += "\(ANSI.cyan)Don't be discouraged! Even seasoned cryptanalysts need a warm-up.\(ANSI.reset)\n"
        output += "\(ANSI.cyan)The cows and bulls are ready for another round whenever you are!\(ANSI.reset)\n\n"
        return output
    }
    
    /// Empathetic early concede display
    public func renderConcede(secret: String) -> String {
        var output = ""
        output += "\n"
        output += "\(ANSI.yellow)\(ANSI.bold)"
        output += "╔═══════════════════════════════════════════════════════════════════╗\n"
        output += "║                    🏳️  ROUND CONCEDED 🏳️                           ║\n"
        output += "╚═══════════════════════════════════════════════════════════════════╝\n"
        output += "\(ANSI.reset)\n"
        output += "\(ANSI.bold)The secret code was: \(ANSI.yellow)[ \(secret.map { String($0) }.joined(separator: " ")) ]\(ANSI.reset)\n\n"
        output += "\(ANSI.dim)A tactical retreat is a mark of wisdom! Rest up and conquer it next time.\(ANSI.reset)\n\n"
        return output
    }
}
