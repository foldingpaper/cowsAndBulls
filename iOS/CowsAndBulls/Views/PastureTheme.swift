import SwiftUI

/// Represents a distinct world grazing pasture theme for the Cows and Bulls iOS game.
public enum PastureTheme: String, CaseIterable, Identifiable {
    case original       = "original"
    case classicBarnyard = "classicBarnyard"
    case swissAlps      = "swissAlps"
    case newZealand     = "newZealand"
    case outback        = "outback"
    case midnight       = "midnight"
    
    public var id: String { rawValue }
    
    /// Short display name for buttons and pills
    public var displayName: String {
        switch self {
        case .original:        return "Original"
        case .classicBarnyard: return "Barnyard"
        case .swissAlps:      return "Swiss Alps"
        case .newZealand:     return "New Zealand"
        case .outback:        return "Outback"
        case .midnight:       return "Midnight"
        }
    }
    
    /// Representative icon / emoji
    public var icon: String {
        switch self {
        case .original:        return "🐮"
        case .classicBarnyard: return "🚜"
        case .swissAlps:      return "🏔️"
        case .newZealand:     return "🇳🇿"
        case .outback:        return "🤠"
        case .midnight:       return "🌙"
        }
    }
    
    /// Flavor tagline for subtitles and tooltips
    public var tagline: String {
        switch self {
        case .original:
            return "Clean native iOS system styling"
        case .classicBarnyard:
            return "Warm sunny amber & red barn countryside"
        case .swissAlps:
            return "Crisp mountain skies & brass cowbells"
        case .newZealand:
            return "Lush emerald rolling hills & misty teals"
        case .outback:
            return "Sun-drenched canyon terracotta & warm sunsets"
        case .midnight:
            return "Moonlit indigo skies & glowing firefly accents"
        }
    }
    
    /// Primary background of the main screen
    public var appBackground: Color {
        switch self {
        case .original:
            return Color.appBackground
        case .classicBarnyard:
            return Color(red: 0.96, green: 0.94, blue: 0.89)
        case .swissAlps:
            return Color(red: 0.92, green: 0.95, blue: 0.98)
        case .newZealand:
            return Color(red: 0.90, green: 0.95, blue: 0.91)
        case .outback:
            return Color(red: 0.96, green: 0.91, blue: 0.86)
        case .midnight:
            return Color(red: 0.07, green: 0.08, blue: 0.13)
        }
    }
    
    /// Card / Container background
    public var cardBackground: Color {
        switch self {
        case .original:
            return Color.cardBackground
        case .classicBarnyard:
            return Color(red: 0.91, green: 0.88, blue: 0.82)
        case .swissAlps:
            return Color(red: 0.83, green: 0.89, blue: 0.95)
        case .newZealand:
            return Color(red: 0.81, green: 0.89, blue: 0.83)
        case .outback:
            return Color(red: 0.89, green: 0.81, blue: 0.73)
        case .midnight:
            return Color(red: 0.13, green: 0.15, blue: 0.22)
        }
    }
    
    /// Surface background for cards, modals, and buttons
    public var surfaceBackground: Color {
        switch self {
        case .original:
            return Color.surfaceBackground
        case .classicBarnyard:
            return Color(red: 0.98, green: 0.97, blue: 0.94)
        case .swissAlps:
            return Color.white
        case .newZealand:
            return Color(red: 0.97, green: 0.99, blue: 0.97)
        case .outback:
            return Color(red: 0.98, green: 0.95, blue: 0.92)
        case .midnight:
            return Color(red: 0.16, green: 0.18, blue: 0.26)
        }
    }
    
    /// Primary brand accent
    public var accentColor: Color {
        switch self {
        case .original:
            return Color.blue
        case .classicBarnyard:
            return Color(red: 0.78, green: 0.22, blue: 0.18) // Barn red
        case .swissAlps:
            return Color(red: 0.12, green: 0.44, blue: 0.72) // Alpine blue
        case .newZealand:
            return Color(red: 0.14, green: 0.52, blue: 0.32) // Fern green
        case .outback:
            return Color(red: 0.76, green: 0.36, blue: 0.20) // Terracotta
        case .midnight:
            return Color(red: 0.45, green: 0.65, blue: 1.00) // Starlight blue
        }
    }
    
    /// Color for Bull indicators
    public var bullColor: Color {
        switch self {
        case .original:
            return .green
        case .classicBarnyard:
            return Color(red: 0.20, green: 0.56, blue: 0.24)
        case .swissAlps:
            return Color(red: 0.16, green: 0.60, blue: 0.48)
        case .newZealand:
            return Color(red: 0.10, green: 0.58, blue: 0.34)
        case .outback:
            return Color(red: 0.68, green: 0.28, blue: 0.16)
        case .midnight:
            return Color(red: 0.30, green: 0.88, blue: 0.62) // Glowing firefly
        }
    }
    
    /// Color for Cow indicators
    public var cowColor: Color {
        switch self {
        case .original:
            return .orange
        case .classicBarnyard:
            return Color(red: 0.86, green: 0.52, blue: 0.12)
        case .swissAlps:
            return Color(red: 0.84, green: 0.65, blue: 0.18) // Brass cowbell
        case .newZealand:
            return Color(red: 0.78, green: 0.55, blue: 0.22)
        case .outback:
            return Color(red: 0.85, green: 0.58, blue: 0.18)
        case .midnight:
            return Color(red: 1.00, green: 0.78, blue: 0.28)
        }
    }
    
    /// Primary text color
    public var textColor: Color {
        switch self {
        case .original:
            return Color.primary
        case .classicBarnyard:
            return Color(red: 0.22, green: 0.18, blue: 0.14)
        case .swissAlps:
            return Color(red: 0.10, green: 0.18, blue: 0.28)
        case .newZealand:
            return Color(red: 0.12, green: 0.24, blue: 0.16)
        case .outback:
            return Color(red: 0.26, green: 0.16, blue: 0.10)
        case .midnight:
            return Color(red: 0.94, green: 0.95, blue: 0.98)
        }
    }
    
    /// Secondary text color
    public var secondaryTextColor: Color {
        switch self {
        case .original:
            return Color.secondary
        case .classicBarnyard:
            return Color(red: 0.48, green: 0.42, blue: 0.36)
        case .swissAlps:
            return Color(red: 0.38, green: 0.46, blue: 0.56)
        case .newZealand:
            return Color(red: 0.36, green: 0.46, blue: 0.38)
        case .outback:
            return Color(red: 0.50, green: 0.38, blue: 0.30)
        case .midnight:
            return Color(red: 0.68, green: 0.72, blue: 0.82)
        }
    }
    
    /// Separator / Border line color
    public var borderSeparator: Color {
        switch self {
        case .original:
            return Color.borderSeparator
        case .classicBarnyard:
            return Color(red: 0.82, green: 0.78, blue: 0.72)
        case .swissAlps:
            return Color(red: 0.76, green: 0.83, blue: 0.90)
        case .newZealand:
            return Color(red: 0.73, green: 0.82, blue: 0.75)
        case .outback:
            return Color(red: 0.80, green: 0.72, blue: 0.64)
        case .midnight:
            return Color(red: 0.22, green: 0.25, blue: 0.36)
        }
    }
    
    /// Distinct border for input fields, code slots, and section dividers
    public var inputBorder: Color {
        switch self {
        case .original:
            return Color.inputBorder
        default:
            return borderSeparator
        }
    }
    
    /// Preferred ColorScheme (e.g. .dark for midnight, nil for following system)
    public var preferredColorScheme: ColorScheme? {
        switch self {
        case .midnight:
            return .dark
        default:
            return nil
        }
    }
}
