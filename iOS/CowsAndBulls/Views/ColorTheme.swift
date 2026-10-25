import SwiftUI

#if canImport(UIKit)
import UIKit
#endif

extension Color {
    #if canImport(UIKit)
    public static let appBackground = Color(UIColor.systemGroupedBackground)
    public static let cardBackground = Color(UIColor.secondarySystemBackground)
    public static let surfaceBackground = Color(UIColor.systemBackground)
    public static let subtleFill = Color(UIColor.tertiarySystemFill)
    public static let borderSeparator = Color(UIColor.separator)
    public static let disabledKey = Color(UIColor.systemGray4)
    #else
    public static let appBackground = Color.gray.opacity(0.12)
    public static let cardBackground = Color.gray.opacity(0.15)
    public static let surfaceBackground = Color.white
    public static let subtleFill = Color.gray.opacity(0.2)
    public static let borderSeparator = Color.gray.opacity(0.3)
    public static let disabledKey = Color.gray.opacity(0.3)
    #endif
}
