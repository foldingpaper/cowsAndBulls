import SwiftUI

/// A playful rotating banner displaying quirky farm quotes.
/// Supports tapping to cycle quotes and an auto-rotation timer.
public struct QuoteBannerView: View {
    @ObservedObject public var viewModel: GameViewModel
    
    // Auto-rotation timer (every 16 seconds)
    private let timer = Timer.publish(every: 16, on: .main, in: .common).autoconnect()
    
    public init(viewModel: GameViewModel) {
        self.viewModel = viewModel
    }
    
    public var body: some View {
        Button(action: {
            withAnimation(.easeInOut(duration: 0.3)) {
                viewModel.cycleQuote(withHaptic: true)
            }
        }) {
            HStack(alignment: .center, spacing: 8) {
                Text("🌾")
                    .font(.subheadline)
                
                Text(viewModel.currentQuote)
                    .font(.caption)
                    .foregroundColor(viewModel.currentTheme.textColor.opacity(0.88))
                    .italic()
                    .lineLimit(2)
                    .multilineTextAlignment(.leading)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .id(viewModel.currentQuote)
                    .transition(.opacity.combined(with: .scale(scale: 0.98)))
                
                Image(systemName: "arrow.triangle.2.circlepath")
                    .font(.system(size: 11, weight: .semibold))
                    .foregroundColor(viewModel.currentTheme.secondaryTextColor)
                    .opacity(0.7)
            }
            .padding(.horizontal, 12)
            .padding(.vertical, 8)
            .background(viewModel.currentTheme.cardBackground)
            .overlay(
                RoundedRectangle(cornerRadius: 10)
                    .stroke(viewModel.currentTheme.borderSeparator.opacity(0.5), lineWidth: 0.5)
            )
            .cornerRadius(10)
        }
        .buttonStyle(.plain)
        .accessibilityLabel("Farm tip: \(viewModel.currentQuote). Tap to cycle quote.")
        .onReceive(timer) { _ in
            withAnimation(.easeInOut(duration: 0.3)) {
                viewModel.cycleQuote(withHaptic: false)
            }
        }
    }
}
