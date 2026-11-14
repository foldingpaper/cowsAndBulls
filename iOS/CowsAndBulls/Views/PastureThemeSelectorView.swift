import SwiftUI

/// Compact horizontal pasture theme switcher displayed on the main game board.
public struct PastureThemeSelectorView: View {
    @Binding public var selectedTheme: PastureTheme
    public let onSelect: (PastureTheme) -> Void
    
    public init(
        selectedTheme: Binding<PastureTheme>,
        onSelect: @escaping (PastureTheme) -> Void = { _ in }
    ) {
        self._selectedTheme = selectedTheme
        self.onSelect = onSelect
    }
    
    public var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 8) {
                ForEach(PastureTheme.allCases) { theme in
                    let isSelected = (theme == selectedTheme)
                    
                    Button(action: {
                        withAnimation(.spring(response: 0.35, dampingFraction: 0.75)) {
                            selectedTheme = theme
                            onSelect(theme)
                        }
                    }) {
                        HStack(spacing: 5) {
                            Text(theme.icon)
                                .font(.system(size: 13))
                            
                            Text(theme.displayName)
                                .font(.system(size: 12, weight: isSelected ? .bold : .medium))
                                .foregroundColor(isSelected ? .white : theme.textColor)
                        }
                        .padding(.horizontal, 10)
                        .padding(.vertical, 6)
                        .background(
                            ZStack {
                                if isSelected {
                                    theme.accentColor
                                        .cornerRadius(14)
                                        .shadow(color: theme.accentColor.opacity(0.35), radius: 3, x: 0, y: 1.5)
                                } else {
                                    theme.cardBackground
                                        .cornerRadius(14)
                                }
                            }
                        )
                        .overlay(
                            RoundedRectangle(cornerRadius: 14)
                                .stroke(isSelected ? Color.clear : theme.borderSeparator, lineWidth: 1)
                        )
                    }
                    .buttonStyle(.plain)
                    .accessibilityLabel("Select \(theme.displayName) pasture theme")
                    .accessibilityAddTraits(isSelected ? [.isSelected] : [])
                }
            }
            .padding(.horizontal, 2)
            .padding(.vertical, 2)
        }
    }
}
