import SwiftUI

/// Phase 1 "Pasture Welcome" Hero Stage presented before Attempt #1.
/// Features prominent quote typography, wandering pasture animals, and theme selection.
public struct HeroStageView: View {
    @ObservedObject public var viewModel: GameViewModel
    
    @State private var wanderOffset: CGFloat = -10
    @State private var gentleBob: CGFloat = -4
    
    public init(viewModel: GameViewModel) {
        self.viewModel = viewModel
    }
    
    public var body: some View {
        ScrollView {
            VStack(spacing: 16) {
                // Wandering Pasture Animals Header
                pastureMeadowView
                    .padding(.top, 10)
                
                // Prominent Hero Quote Card
                heroQuoteCard
                    .padding(.horizontal)
                
                // Pasture Theme Switcher Section
                VStack(alignment: .leading, spacing: 8) {
                    HStack(spacing: 6) {
                        Text("📍")
                            .font(.caption)
                        Text("SELECT GRAZING PASTURE")
                            .font(.system(size: 11, weight: .bold))
                            .tracking(1.2)
                            .foregroundColor(viewModel.currentTheme.secondaryTextColor)
                    }
                    .padding(.horizontal, 4)
                    
                    PastureThemeSelectorView(
                        selectedTheme: $viewModel.currentTheme,
                        onSelect: { theme in
                            viewModel.setTheme(theme)
                        }
                    )
                }
                .padding(.horizontal)
                
                // Friendly Call-To-Action Hint
                HStack(spacing: 6) {
                    Image(systemName: "hand.tap.fill")
                        .font(.caption2)
                    Text("Type 4 unique digits below and lock in your first guess!")
                        .font(.caption)
                }
                .foregroundColor(viewModel.currentTheme.secondaryTextColor)
                .padding(.top, 4)
                .padding(.bottom, 20)
            }
        }
        .onAppear {
            withAnimation(
                Animation.easeInOut(duration: 3.0)
                    .repeatForever(autoreverses: true)
            ) {
                wanderOffset = 10
            }
            withAnimation(
                Animation.easeInOut(duration: 2.0)
                    .repeatForever(autoreverses: true)
            ) {
                gentleBob = 4
            }
        }
    }
    
    // MARK: - Subviews
    
    private var pastureMeadowView: some View {
        HStack(spacing: 24) {
            // Wandering Cow
            VStack(spacing: 2) {
                Text("🐮")
                    .font(.system(size: 44))
                    .offset(x: wanderOffset, y: gentleBob)
                Text("Cow")
                    .font(.caption2.bold())
                    .foregroundColor(viewModel.currentTheme.cowColor)
            }
            
            // Meadow Centerpiece
            VStack(spacing: 4) {
                Text("🌾 🌻 🌾")
                    .font(.title3)
                Text(viewModel.currentTheme.displayName)
                    .font(.subheadline.bold())
                    .foregroundColor(viewModel.currentTheme.textColor)
                Text(viewModel.currentTheme.tagline)
                    .font(.caption2)
                    .foregroundColor(viewModel.currentTheme.secondaryTextColor)
                    .multilineTextAlignment(.center)
            }
            .frame(maxWidth: 160)
            
            // Wandering Bull
            VStack(spacing: 2) {
                Text("🐂")
                    .font(.system(size: 44))
                    .offset(x: -wanderOffset, y: -gentleBob)
                Text("Bull")
                    .font(.caption2.bold())
                    .foregroundColor(viewModel.currentTheme.bullColor)
            }
        }
        .padding(.vertical, 8)
    }
    
    private var heroQuoteCard: some View {
        Button(action: {
            withAnimation(.easeInOut(duration: 0.3)) {
                viewModel.cycleQuote(withHaptic: true)
            }
        }) {
            VStack(alignment: .leading, spacing: 10) {
                HStack {
                    HStack(spacing: 6) {
                        Text("🌾")
                            .font(.subheadline)
                        Text("FARM RUMOR & WISDOM")
                            .font(.system(size: 11, weight: .bold))
                            .tracking(1.4)
                            .foregroundColor(viewModel.currentTheme.accentColor)
                    }
                    
                    Spacer()
                    
                    Image(systemName: "arrow.triangle.2.circlepath")
                        .font(.system(size: 12, weight: .semibold))
                        .foregroundColor(viewModel.currentTheme.secondaryTextColor)
                }
                
                Text("\"\(viewModel.currentQuote)\"")
                    .font(.system(size: 15, weight: .semibold, design: .rounded))
                    .foregroundColor(viewModel.currentTheme.textColor)
                    .lineSpacing(4)
                    .multilineTextAlignment(.leading)
                    .fixedSize(horizontal: false, vertical: true)
                    .id(viewModel.currentQuote)
                    .transition(.opacity.combined(with: .scale(scale: 0.98)))
                
                HStack {
                    Spacer()
                    Text("Tap to shuffle rumor ↻")
                        .font(.caption2)
                        .foregroundColor(viewModel.currentTheme.secondaryTextColor.opacity(0.8))
                }
            }
            .padding(16)
            .background(viewModel.currentTheme.cardBackground)
            .overlay(
                RoundedRectangle(cornerRadius: 16)
                    .stroke(viewModel.currentTheme.borderSeparator.opacity(0.6), lineWidth: 0.75)
            )
            .cornerRadius(16)
            .shadow(color: Color.black.opacity(0.04), radius: 6, y: 3)
        }
        .buttonStyle(.plain)
        .accessibilityLabel("Farm rumor: \(viewModel.currentQuote). Tap to shuffle.")
    }
}
