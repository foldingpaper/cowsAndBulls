import SwiftUI

/// Renders an individual attempt row on the board with cartoon-like icons and indicators.
public struct AttemptRowView: View {
    public let attempt: Attempt
    public let isCartoonMode: Bool
    
    public init(attempt: Attempt, isCartoonMode: Bool = true) {
        self.attempt = attempt
        self.isCartoonMode = isCartoonMode
    }
    
    public var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            HStack(spacing: 12) {
                // Attempt Sequence Badge
                Text(String(format: "#%02d", attempt.number))
                    .font(.system(size: 12, weight: .bold, design: .monospaced))
                    .foregroundColor(.secondary)
                    .frame(width: 32)
                
                // 4-Digit Guess Cards
                HStack(spacing: 4) {
                    ForEach(Array(attempt.guess.enumerated()), id: \.offset) { _, char in
                        Text(String(char))
                            .font(.system(size: 15, weight: .bold, design: .monospaced))
                            .frame(width: 26, height: 32)
                            .background(Color.cardBackground)
                            .cornerRadius(6)
                    }
                }
                
                Spacer()
                
                // Indicators: Bulls (🐂) & Cows (🐮)
                HStack(spacing: 10) {
                    // Bulls Badge
                    indicatorBadge(
                        count: attempt.score.bulls,
                        cartoonIcon: "🐂",
                        classicLabel: "B",
                        tintColor: .green
                    )
                    
                    // Cows Badge
                    indicatorBadge(
                        count: attempt.score.cows,
                        cartoonIcon: "🐮",
                        classicLabel: "C",
                        tintColor: .orange
                    )
                }
            }
            
            // Quirky commentary
            Text(attempt.score.quirkyCommentary)
                .font(.caption2)
                .foregroundColor(.secondary)
                .italic()
                .padding(.leading, 44)
        }
        .padding(.vertical, 8)
        .padding(.horizontal, 12)
        .background(Color.surfaceBackground)
        .cornerRadius(12)
        .shadow(color: Color.black.opacity(0.04), radius: 3, x: 0, y: 1)
    }
    
    @ViewBuilder
    private func indicatorBadge(count: Int, cartoonIcon: String, classicLabel: String, tintColor: Color) -> some View {
        HStack(spacing: 3) {
            if isCartoonMode {
                if count > 0 {
                    Text(String(repeating: cartoonIcon, count: count))
                        .font(.subheadline)
                } else {
                    Text("-")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
            } else {
                Text(classicLabel)
                    .font(.caption.bold())
                    .foregroundColor(count > 0 ? tintColor : .secondary)
                Text("\(count)")
                    .font(.caption.monospacedDigit())
                    .foregroundColor(count > 0 ? .primary : .secondary)
            }
        }
        .padding(.horizontal, 8)
        .padding(.vertical, 4)
        .background(count > 0 ? tintColor.opacity(0.12) : Color.subtleFill)
        .cornerRadius(8)
    }
}
