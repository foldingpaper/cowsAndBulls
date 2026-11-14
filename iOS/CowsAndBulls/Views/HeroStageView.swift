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
                
                // Prominent Hero Banter Card
                heroBanterCard
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
                    Text(viewModel.isKeypadCollapsed
                         ? "Tap the code slots below to open the keypad and start guessing!"
                         : "Type 4 unique digits below and lock in your first guess!")
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
                Text("🌾 \(viewModel.currentTheme.icon) 🌾")
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
    
    private var heroBanterCard: some View {
        Button(action: {
            withAnimation(.easeInOut(duration: 0.25)) {
                viewModel.cycleQuote(withHaptic: true)
            }
        }) {
            VStack(alignment: .leading, spacing: 12) {
                // Header with Pasture Theme Identity
                HStack {
                    HStack(spacing: 6) {
                        Text(viewModel.currentTheme.icon)
                            .font(.subheadline)
                        VStack(alignment: .leading, spacing: 1) {
                            Text("PASTURE RUMORS & WISDOM")
                                .font(.system(size: 10, weight: .bold))
                                .tracking(1.2)
                                .foregroundColor(viewModel.currentTheme.accentColor)
                            Text("\(viewModel.currentTheme.displayName) Pasture")
                                .font(.system(size: 11, weight: .semibold))
                                .foregroundColor(viewModel.currentTheme.secondaryTextColor)
                        }
                    }
                    
                    Spacer()
                    
                    HStack(spacing: 4) {
                        Image(systemName: "arrow.triangle.2.circlepath")
                            .font(.system(size: 11, weight: .semibold))
                        Text("Overhear")
                            .font(.caption2.bold())
                    }
                    .foregroundColor(viewModel.currentTheme.accentColor)
                    .padding(.horizontal, 8)
                    .padding(.vertical, 4)
                    .background(viewModel.currentTheme.accentColor.opacity(0.12))
                    .cornerRadius(12)
                }
                
                // Comic Dialogue Banter
                VStack(spacing: 10) {
                    // Cow message
                    HStack(alignment: .top, spacing: 8) {
                        Text("🐮")
                            .font(.system(size: 24))
                            .padding(6)
                            .background(viewModel.currentTheme.cowColor.opacity(0.18))
                            .clipShape(Circle())
                        
                        VStack(alignment: .leading, spacing: 2) {
                            Text("Cow")
                                .font(.system(size: 10, weight: .bold))
                                .foregroundColor(viewModel.currentTheme.cowColor)
                            Text(viewModel.currentCowOpener)
                                .font(.system(size: 13, weight: .medium, design: .rounded))
                                .foregroundColor(viewModel.currentTheme.textColor)
                                .padding(.horizontal, 12)
                                .padding(.vertical, 7)
                                .background(viewModel.currentTheme.surfaceBackground)
                                .cornerRadius(12)
                                .id(viewModel.currentCowOpener)
                                .transition(.opacity.combined(with: .scale(scale: 0.98)))
                        }
                        Spacer(minLength: 16)
                    }
                    
                    // Bull response with active quote (unquoted)
                    HStack(alignment: .top, spacing: 8) {
                        Spacer(minLength: 16)
                        VStack(alignment: .trailing, spacing: 2) {
                            Text("Bull")
                                .font(.system(size: 10, weight: .bold))
                                .foregroundColor(viewModel.currentTheme.bullColor)
                            Text(viewModel.currentQuote)
                                .font(.system(size: 14, weight: .semibold, design: .rounded))
                                .foregroundColor(viewModel.currentTheme.textColor)
                                .lineSpacing(3)
                                .multilineTextAlignment(.leading)
                                .padding(.horizontal, 12)
                                .padding(.vertical, 8)
                                .background(viewModel.currentTheme.accentColor.opacity(0.12))
                                .overlay(
                                    RoundedRectangle(cornerRadius: 12)
                                        .stroke(viewModel.currentTheme.accentColor.opacity(0.25), lineWidth: 1)
                                )
                                .cornerRadius(12)
                                .id(viewModel.currentQuote)
                                .transition(.opacity.combined(with: .scale(scale: 0.98)))
                        }
                        
                        Text("🐂")
                            .font(.system(size: 24))
                            .padding(6)
                            .background(viewModel.currentTheme.bullColor.opacity(0.18))
                            .clipShape(Circle())
                    }
                }
                
                // Friendly subtle footer
                HStack {
                    Spacer()
                    Text("Tap card to overhear another rumor ↻")
                        .font(.caption2)
                        .foregroundColor(viewModel.currentTheme.secondaryTextColor.opacity(0.7))
                }
            }
            .padding(14)
            .background(viewModel.currentTheme.cardBackground)
            .overlay(
                RoundedRectangle(cornerRadius: 16)
                    .stroke(viewModel.currentTheme.borderSeparator.opacity(0.6), lineWidth: 0.75)
            )
            .cornerRadius(16)
            .shadow(color: Color.black.opacity(0.04), radius: 6, y: 3)
        }
        .buttonStyle(.plain)
        .accessibilityLabel("Pasture rumor dialogue between Cow and Bull: \(viewModel.currentQuote). Tap to shuffle.")
    }
}
