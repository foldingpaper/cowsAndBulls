import SwiftUI

/// Main game view integrating the two-phase layout (Hero Stage vs. Codebreaker's Desk),
/// unified docked input bar, and collapsible keypad.
public struct MainGameView: View {
    @StateObject private var viewModel = GameViewModel()
    @ObservedObject private var soundManager = SoundManager.shared
    
    public init() {}
    
    public var body: some View {
        ZStack {
            // Pasture Background
            viewModel.currentTheme.appBackground
                .ignoresSafeArea()
            
            VStack(spacing: 0) {
                // Top Header / Navigation Bar
                headerBar
                
                // Content Area: Phase 1 (Hero Stage) vs. Phase 2 (Attempt Board)
                if viewModel.attempts.isEmpty {
                    HeroStageView(viewModel: viewModel)
                        .transition(.asymmetric(
                            insertion: .opacity,
                            removal: .scale(scale: 0.96).combined(with: .opacity)
                        ))
                } else {
                    VStack(spacing: 0) {
                        // Compact Attempts Progress Pill
                        attemptsStatusBar
                            .padding(.horizontal)
                            .padding(.top, 2)
                            .padding(.bottom, 4)
                        
                        // Chronological Attempt History Board
                        AttemptBoardView(
                            attempts: viewModel.attempts,
                            isCartoonMode: viewModel.isCartoonMode,
                            isKeypadCollapsed: viewModel.isKeypadCollapsed,
                            onScrollDrag: {
                                if !viewModel.isKeypadCollapsed {
                                    withAnimation(.spring(response: 0.35, dampingFraction: 0.82)) {
                                        viewModel.isKeypadCollapsed = true
                                    }
                                }
                            }
                        )
                    }
                    .transition(.opacity)
                }
                
                Divider()
                    .padding(.vertical, 2)
                
                // Docked Unified Guess & Lock Bar (Always visible)
                UnifiedGuessInputBar(viewModel: viewModel)
                
                // Collapsible On-Screen Keypad
                if !viewModel.isKeypadCollapsed {
                    KeypadView(viewModel: viewModel)
                        .transition(.move(edge: .bottom).combined(with: .opacity))
                }
            }
            
            // Victory Modal Overlay
            if viewModel.showVictoryModal, let secret = viewModel.revealedSecret {
                VictoryView(
                    attemptsUsed: viewModel.attemptsUsed,
                    maxAttempts: viewModel.maxAttempts,
                    secret: secret,
                    onPlayAgain: {
                        viewModel.startNewGame()
                    }
                )
                .transition(.scale.combined(with: .opacity))
            }
            
            // Game Over / Concede Modal Overlay
            if viewModel.showGameOverModal, let secret = viewModel.revealedSecret {
                let isConceded = (viewModel.engine.state == .conceded(secret: secret))
                GameOverView(
                    isConceded: isConceded,
                    secret: secret,
                    onTryAgain: {
                        viewModel.startNewGame()
                    }
                )
                .transition(.scale.combined(with: .opacity))
            }
        }
        .animation(.spring(response: 0.35, dampingFraction: 0.82), value: viewModel.isKeypadCollapsed)
        .animation(.spring(response: 0.4, dampingFraction: 0.85), value: viewModel.attempts.isEmpty)
        .animation(.spring(), value: viewModel.showVictoryModal)
        .animation(.spring(), value: viewModel.showGameOverModal)
        .sheet(isPresented: $viewModel.showRulesSheet) {
            RulesSheetView()
        }
        .sheet(isPresented: $viewModel.showQuoteSheet) {
            if #available(iOS 16.0, *) {
                quoteSheetView
                    .presentationDetents([.medium, .fraction(0.55)])
                    .presentationDragIndicator(.visible)
            } else {
                quoteSheetView
            }
        }
        .alert(isPresented: $viewModel.showConcedeAlert) {
            Alert(
                title: Text("Concede Round?"),
                message: Text("Surrendering will immediately end this game and reveal the secret code."),
                primaryButton: .destructive(Text("Concede & Reveal")) {
                    viewModel.confirmConcede()
                },
                secondaryButton: .cancel()
            )
        }
        .preferredColorScheme(viewModel.currentTheme.preferredColorScheme)
    }
    
    // MARK: - Subviews
    
    private var headerBar: some View {
        HStack {
            // Title (Tappable for Farm Wisdom & Rumors)
            Button(action: {
                viewModel.showQuoteSheet = true
            }) {
                HStack(spacing: 5) {
                    Text("🐮")
                        .font(.title2)
                    Text("Cows & Bulls")
                        .font(.headline.bold())
                        .foregroundColor(viewModel.currentTheme.textColor)
                        .lineLimit(1)
                        .minimumScaleFactor(0.85)
                    Text("🐂")
                        .font(.title2)
                }
            }
            .buttonStyle(.plain)
            .accessibilityLabel("Cows and Bulls, tap for Farm Rumors and Wisdom")
            
            Spacer()
            
            // Header Action Buttons
            HStack(spacing: 8) {
                // Sound Toggle Button
                Button(action: {
                    soundManager.toggleMute()
                }) {
                    Image(systemName: soundManager.isMuted ? "speaker.slash.fill" : "speaker.wave.2.fill")
                        .font(.subheadline)
                        .foregroundColor(soundManager.isMuted ? viewModel.currentTheme.secondaryTextColor : viewModel.currentTheme.accentColor)
                        .frame(width: 32, height: 32)
                        .background(viewModel.currentTheme.surfaceBackground)
                        .clipShape(Circle())
                }
                .accessibilityLabel(soundManager.isMuted ? "Unmute Sound" : "Mute Sound")
                
                // Concede Button (Only active when game is in progress)
                Button(action: {
                    viewModel.showConcedeAlert = true
                }) {
                    Image(systemName: "flag.fill")
                        .font(.caption)
                        .foregroundColor(viewModel.currentTheme.cowColor)
                        .frame(width: 32, height: 32)
                        .background(viewModel.currentTheme.surfaceBackground)
                        .clipShape(Circle())
                }
                .disabled(viewModel.engine.state.isGameOver)
                .accessibilityLabel("Concede Round")
                
                // Help Button
                Button(action: {
                    viewModel.showRulesSheet = true
                }) {
                    Image(systemName: "questionmark.circle.fill")
                        .font(.subheadline)
                        .foregroundColor(viewModel.currentTheme.secondaryTextColor)
                        .frame(width: 32, height: 32)
                        .background(viewModel.currentTheme.surfaceBackground)
                        .clipShape(Circle())
                }
                .accessibilityLabel("Game Rules")
                
                // New Game Button
                Button(action: {
                    viewModel.startNewGame()
                }) {
                    Image(systemName: "arrow.counterclockwise")
                        .font(.caption.bold())
                        .foregroundColor(viewModel.currentTheme.textColor)
                        .frame(width: 32, height: 32)
                        .background(viewModel.currentTheme.surfaceBackground)
                        .clipShape(Circle())
                }
                .accessibilityLabel("New Game")
            }
        }
        .padding(.horizontal)
        .padding(.top, 8)
        .padding(.bottom, 4)
    }
    
    private var attemptsStatusBar: some View {
        HStack {
            // Attempt Counter
            Text("Attempt \(min(viewModel.attemptsUsed + 1, viewModel.maxAttempts)) of \(viewModel.maxAttempts)")
                .font(.caption.bold())
                .foregroundColor(viewModel.currentTheme.secondaryTextColor)
            
            Spacer()
            
            // Remaining Badge
            HStack(spacing: 4) {
                Text("\(viewModel.attemptsRemaining)")
                    .font(.caption.monospacedDigit().bold())
                Text("remaining")
                    .font(.caption2)
            }
            .padding(.horizontal, 8)
            .padding(.vertical, 3)
            .background(remainingColor.opacity(0.15))
            .foregroundColor(remainingColor)
            .cornerRadius(8)
        }
    }
    
    private var quoteSheetView: some View {
        VStack(spacing: 18) {
            // Top Bar with Pasture Identity
            HStack {
                HStack(spacing: 8) {
                    Text(viewModel.currentTheme.icon)
                        .font(.title2)
                    VStack(alignment: .leading, spacing: 2) {
                        Text("Pasture Rumors & Wisdom")
                            .font(.headline)
                            .foregroundColor(viewModel.currentTheme.textColor)
                        Text("\(viewModel.currentTheme.displayName) Pasture")
                            .font(.caption2)
                            .foregroundColor(viewModel.currentTheme.secondaryTextColor)
                    }
                }
                Spacer()
                Button("Done") {
                    viewModel.showQuoteSheet = false
                }
                .font(.subheadline.bold())
                .foregroundColor(viewModel.currentTheme.accentColor)
            }
            .padding(.top, 4)
            
            // Conversation between Cow and Bull
            VStack(spacing: 14) {
                // Cow message
                HStack(alignment: .top, spacing: 10) {
                    Text("🐮")
                        .font(.system(size: 28))
                        .padding(8)
                        .background(viewModel.currentTheme.cowColor.opacity(0.18))
                        .clipShape(Circle())
                    
                    VStack(alignment: .leading, spacing: 4) {
                        Text("Cow")
                            .font(.caption.bold())
                            .foregroundColor(viewModel.currentTheme.cowColor)
                        Text("Psst... heard any fresh farm gossip?")
                            .font(.system(size: 14, weight: .medium, design: .rounded))
                            .foregroundColor(viewModel.currentTheme.textColor)
                            .padding(.horizontal, 14)
                            .padding(.vertical, 9)
                            .background(viewModel.currentTheme.surfaceBackground)
                            .cornerRadius(14)
                    }
                    Spacer(minLength: 24)
                }
                
                // Bull response with the current quote
                HStack(alignment: .top, spacing: 10) {
                    Spacer(minLength: 24)
                    VStack(alignment: .trailing, spacing: 4) {
                        Text("Bull")
                            .font(.caption.bold())
                            .foregroundColor(viewModel.currentTheme.bullColor)
                        Text(viewModel.currentQuote)
                            .font(.system(size: 15, weight: .semibold, design: .rounded))
                            .foregroundColor(viewModel.currentTheme.textColor)
                            .lineSpacing(3)
                            .multilineTextAlignment(.leading)
                            .padding(.horizontal, 14)
                            .padding(.vertical, 10)
                            .background(viewModel.currentTheme.accentColor.opacity(0.12))
                            .overlay(
                                RoundedRectangle(cornerRadius: 14)
                                    .stroke(viewModel.currentTheme.accentColor.opacity(0.25), lineWidth: 1)
                            )
                            .cornerRadius(14)
                    }
                    
                    Text("🐂")
                        .font(.system(size: 28))
                        .padding(8)
                        .background(viewModel.currentTheme.bullColor.opacity(0.18))
                        .clipShape(Circle())
                }
            }
            .padding(.vertical, 6)
            
            // Overhear Another Rumor
            Button(action: {
                withAnimation(.easeInOut(duration: 0.25)) {
                    viewModel.cycleQuote(withHaptic: true)
                }
            }) {
                HStack(spacing: 6) {
                    Image(systemName: "arrow.triangle.2.circlepath")
                    Text("Overhear Another Rumor")
                }
                .font(.subheadline.bold())
                .foregroundColor(viewModel.currentTheme.accentColor)
                .padding(.vertical, 10)
                .padding(.horizontal, 18)
                .background(viewModel.currentTheme.accentColor.opacity(0.12))
                .cornerRadius(20)
            }
            
            Spacer()
        }
        .padding()
        .background(viewModel.currentTheme.appBackground.ignoresSafeArea())
    }
    
    private var remainingColor: Color {
        if viewModel.attemptsRemaining > 10 {
            return viewModel.currentTheme.bullColor
        } else if viewModel.attemptsRemaining > 5 {
            return viewModel.currentTheme.cowColor
        } else {
            return .red
        }
    }
}
