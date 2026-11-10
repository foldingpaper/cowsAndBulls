import SwiftUI

/// Unified docked input bar combining the 4-digit guess slots, inline "Lock In" button,
/// and iPad-style keypad collapse/expand controls.
public struct UnifiedGuessInputBar: View {
    @ObservedObject public var viewModel: GameViewModel
    
    public init(viewModel: GameViewModel) {
        self.viewModel = viewModel
    }
    
    public var body: some View {
        VStack(spacing: 4) {
            // Optional Error Banner
            if let error = viewModel.errorMessage {
                Text(error)
                    .font(.caption.bold())
                    .foregroundColor(.red)
                    .transition(.opacity.combined(with: .scale(scale: 0.95)))
            }
            
            // Unified Input & Lock Bar
            HStack(spacing: 8) {
                // 4-Digit Guess Slots
                HStack(spacing: 6) {
                    ForEach(0..<viewModel.engine.config.codeLength, id: \.self) { index in
                        let hasDigit = viewModel.currentInput.indices.contains(index)
                        let isNextActive = index == viewModel.currentInput.count
                        let charString = hasDigit ? String(viewModel.currentInput[index]) : ""
                        
                        Text(charString)
                            .font(.system(size: 20, weight: .bold, design: .monospaced))
                            .foregroundColor(viewModel.currentTheme.textColor)
                            .frame(width: 38, height: 44)
                            .background(viewModel.currentTheme.cardBackground)
                            .overlay(
                                RoundedRectangle(cornerRadius: 10)
                                    .stroke(
                                        isNextActive ? viewModel.currentTheme.accentColor : viewModel.currentTheme.borderSeparator.opacity(0.4),
                                        lineWidth: isNextActive ? 2 : 1
                                    )
                            )
                            .cornerRadius(10)
                    }
                }
                .contentShape(Rectangle())
                .onTapGesture {
                    withAnimation(.spring(response: 0.35, dampingFraction: 0.8)) {
                        viewModel.expandKeypad()
                    }
                }
                .accessibilityLabel("Current guess slots. Tap to expand keypad.")
                
                // Inline "Lock In" Button
                Button(action: {
                    withAnimation(.spring()) {
                        viewModel.lockInGuess()
                    }
                }) {
                    HStack(spacing: 5) {
                        Image(systemName: "lock.fill")
                            .font(.system(size: 13, weight: .semibold))
                        Text("Lock In")
                            .font(.system(size: 14, weight: .bold))
                    }
                    .frame(maxWidth: .infinity)
                    .frame(height: 44)
                    .background(
                        viewModel.canLockIn
                            ? viewModel.currentTheme.accentColor
                            : viewModel.currentTheme.cardBackground.opacity(0.6)
                    )
                    .foregroundColor(
                        viewModel.canLockIn
                            ? .white
                            : viewModel.currentTheme.secondaryTextColor.opacity(0.6)
                    )
                    .cornerRadius(10)
                    .shadow(
                        color: viewModel.canLockIn ? viewModel.currentTheme.accentColor.opacity(0.35) : Color.clear,
                        radius: 4,
                        y: 2
                    )
                }
                .disabled(!viewModel.canLockIn)
                .accessibilityLabel("Lock In Guess")
                
                // iPad-style Keypad Collapse / Expand Toggle
                Button(action: {
                    withAnimation(.spring(response: 0.35, dampingFraction: 0.8)) {
                        viewModel.toggleKeypadCollapse()
                    }
                }) {
                    Image(systemName: viewModel.isKeypadCollapsed ? "keyboard" : "keyboard.chevron.compact.down")
                        .font(.system(size: 16, weight: .semibold))
                        .foregroundColor(viewModel.currentTheme.textColor)
                        .frame(width: 44, height: 44)
                        .background(viewModel.currentTheme.surfaceBackground)
                        .overlay(
                            RoundedRectangle(cornerRadius: 10)
                                .stroke(viewModel.currentTheme.borderSeparator.opacity(0.5), lineWidth: 1)
                        )
                        .cornerRadius(10)
                }
                .accessibilityLabel(viewModel.isKeypadCollapsed ? "Open Keypad" : "Collapse Keypad")
            }
            .padding(.horizontal)
            .padding(.vertical, 4)
        }
    }
}
