import SwiftUI

/// Streamlined on-screen keypad with dynamic digit states matching the active pasture theme.
public struct KeypadView: View {
    @ObservedObject public var viewModel: GameViewModel
    
    private let keypadGrid: [[String]] = [
        ["1", "2", "3"],
        ["4", "5", "6"],
        ["7", "8", "9"],
        ["clear", "0", "delete"]
    ]
    
    public init(viewModel: GameViewModel) {
        self.viewModel = viewModel
    }
    
    public var body: some View {
        VStack(spacing: 8) {
            ForEach(keypadGrid, id: \.self) { row in
                HStack(spacing: 10) {
                    ForEach(row, id: \.self) { key in
                        keypadButton(for: key)
                    }
                }
            }
        }
        .padding(.horizontal)
        .padding(.top, 4)
        .padding(.bottom, 6)
    }
    
    @ViewBuilder
    private func keypadButton(for key: String) -> some View {
        if key == "clear" {
            Button(action: {
                viewModel.clearInput()
            }) {
                Text("Clear")
                    .font(.subheadline.bold())
                    .frame(maxWidth: .infinity)
                    .frame(height: 44)
                    .background(viewModel.currentTheme.cardBackground)
                    .foregroundColor(viewModel.currentTheme.secondaryTextColor)
                    .cornerRadius(10)
                    .overlay(
                        RoundedRectangle(cornerRadius: 10)
                            .stroke(viewModel.currentTheme.borderSeparator, lineWidth: 1)
                    )
            }
        } else if key == "delete" {
            Button(action: {
                viewModel.deleteDigit()
            }) {
                Image(systemName: "delete.left.fill")
                    .font(.title3)
                    .frame(maxWidth: .infinity)
                    .frame(height: 44)
                    .background(viewModel.currentTheme.cardBackground)
                    .foregroundColor(viewModel.currentTheme.secondaryTextColor)
                    .cornerRadius(10)
                    .overlay(
                        RoundedRectangle(cornerRadius: 10)
                            .stroke(viewModel.currentTheme.borderSeparator, lineWidth: 1)
                    )
            }
        } else if let char = key.first {
            let isUsed = viewModel.isDigitUsed(char)
            
            Button(action: {
                viewModel.appendDigit(char)
            }) {
                Text(key)
                    .font(.title3.bold())
                    .frame(maxWidth: .infinity)
                    .frame(height: 44)
                    .background(
                        isUsed
                            ? viewModel.currentTheme.cardBackground.opacity(0.4)
                            : viewModel.currentTheme.cardBackground
                    )
                    .foregroundColor(
                        isUsed
                            ? viewModel.currentTheme.secondaryTextColor.opacity(0.4)
                            : viewModel.currentTheme.textColor
                    )
                    .cornerRadius(10)
                    .overlay(
                        RoundedRectangle(cornerRadius: 10)
                            .stroke(
                                isUsed ? Color.clear : viewModel.currentTheme.borderSeparator,
                                lineWidth: 1
                            )
                    )
            }
            .disabled(isUsed)
        }
    }
}
