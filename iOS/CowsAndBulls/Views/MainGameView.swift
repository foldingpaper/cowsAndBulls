import SwiftUI

/// Main game view integrating the attempt history board, digit input slots, and keypad.
public struct MainGameView: View {
    @StateObject private var viewModel = GameViewModel()
    @ObservedObject private var soundManager = SoundManager.shared
    
    public init() {}
    
    public var body: some View {
        ZStack {
            // Background
            Color.appBackground
                .ignoresSafeArea()
            
            VStack(spacing: 0) {
                // Top Header / Navigation Bar
                headerBar
                
                // Attempts Progress Pill
                attemptsStatusBar
                    .padding(.horizontal)
                    .padding(.top, 4)
                
                // Attempt History Board (Clear View of All Attempts)
                AttemptBoardView(
                    attempts: viewModel.attempts,
                    isCartoonMode: viewModel.isCartoonMode
                )
                
                Divider()
                    .padding(.vertical, 4)
                
                // 4-Digit Current Guess Input Display
                CurrentGuessInputView(
                    currentInput: viewModel.currentInput,
                    errorMessage: viewModel.errorMessage,
                    codeLength: viewModel.engine.config.codeLength
                )
                
                // On-Screen Keypad & "Lock In" Button
                KeypadView(viewModel: viewModel)
                    .padding(.bottom, 8)
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
        .animation(.spring(), value: viewModel.showVictoryModal)
        .animation(.spring(), value: viewModel.showGameOverModal)
        .sheet(isPresented: $viewModel.showRulesSheet) {
            RulesSheetView()
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
    }
    
    // MARK: - Subviews
    
    private var headerBar: some View {
        HStack {
            // Title
            HStack(spacing: 6) {
                Text("🐮")
                    .font(.title2)
                Text("Cows & Bulls")
                    .font(.headline.bold())
                Text("🐂")
                    .font(.title2)
            }
            
            Spacer()
            
            // Header Action Buttons
            HStack(spacing: 12) {
                // Sound Toggle Button
                Button(action: {
                    soundManager.toggleMute()
                }) {
                    Image(systemName: soundManager.isMuted ? "speaker.slash.fill" : "speaker.wave.2.fill")
                        .font(.subheadline)
                        .foregroundColor(soundManager.isMuted ? .secondary : .blue)
                        .frame(width: 32, height: 32)
                        .background(Color.surfaceBackground)
                        .clipShape(Circle())
                }
                
                // Concede Button (Only active when game is in progress)
                Button(action: {
                    viewModel.showConcedeAlert = true
                }) {
                    Image(systemName: "flag.fill")
                        .font(.caption)
                        .foregroundColor(.orange)
                        .frame(width: 32, height: 32)
                        .background(Color.surfaceBackground)
                        .clipShape(Circle())
                }
                .disabled(viewModel.engine.state.isGameOver)
                
                // Help Button
                Button(action: {
                    viewModel.showRulesSheet = true
                }) {
                    Image(systemName: "questionmark.circle.fill")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                        .frame(width: 32, height: 32)
                        .background(Color.surfaceBackground)
                        .clipShape(Circle())
                }
                
                // New Game Button
                Button(action: {
                    viewModel.startNewGame()
                }) {
                    Image(systemName: "arrow.counterclockwise")
                        .font(.caption.bold())
                        .foregroundColor(.primary)
                        .frame(width: 32, height: 32)
                        .background(Color.surfaceBackground)
                        .clipShape(Circle())
                }
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
                .foregroundColor(.secondary)
            
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
    
    private var remainingColor: Color {
        if viewModel.attemptsRemaining > 10 {
            return .green
        } else if viewModel.attemptsRemaining > 5 {
            return .orange
        } else {
            return .red
        }
    }
}
