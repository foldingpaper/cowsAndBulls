import Foundation

/// Represents the score for an attempt: count of Bulls and Cows.
public struct Score: Equatable, Codable {
    /// Digits in the correct position.
    public let bulls: Int
    
    /// Digits present in the code but in the wrong position.
    public let cows: Int
    
    public init(bulls: Int, cows: Int) {
        self.bulls = bulls
        self.cows = cows
    }
    
    /// Whether this score represents a winning guess (4 bulls for standard 4-digit code).
    public func isVictory(codeLength: Int = 4) -> Bool {
        return bulls == codeLength
    }
    
    /// Classic string representation (e.g. "B B" and "C")
    public var classicBullsString: String {
        return bulls > 0 ? String(repeating: "B", count: bulls) : "-"
    }
    
    public var classicCowsString: String {
        return cows > 0 ? String(repeating: "C", count: cows) : "-"
    }
    
    /// Cartoon icon representation (🐂 and 🐮)
    public var cartoonBullsString: String {
        return bulls > 0 ? String(repeating: "🐂", count: bulls) : "-"
    }
    
    public var cartoonCowsString: String {
        return cows > 0 ? String(repeating: "🐮", count: cows) : "-"
    }
    
    /// Quirky funny commentary based on bulls and cows count.
    public var quirkyCommentary: String {
        if bulls == 4 {
            return "🎯 BULLSEYE! Holy cow, you cracked the vault!"
        }
        if bulls == 0 && cows == 0 {
            return "🦗 *Crickets*... Not a single hoofbeat in the pasture!"
        }
        
        var parts: [String] = []
        switch bulls {
        case 3:
            parts.append("🔥 3 Bulls locked in their pens! You're on fire!")
        case 2:
            parts.append("⚡ 2 Bulls standing firm right on target!")
        case 1:
            parts.append("🎯 1 Bull secured in the right spot!")
        default:
            break
        }
        
        switch cows {
        case 4:
            parts.append("🐮 4 Cows having a wild party in the wrong stalls!")
        case 3:
            parts.append("🌾 3 Cows grazing nearby, just in the wrong spots!")
        case 2:
            parts.append("🥛 2 Cows wandering the pasture!")
        case 1:
            parts.append("🔔 1 Cow ringing its bell in the distance!")
        default:
            break
        }
        
        return parts.joined(separator: " ")
    }
}
