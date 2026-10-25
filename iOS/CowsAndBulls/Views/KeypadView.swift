import SwiftUI

/// Custom on-screen keypad with dynamic digit states and prominent "Lock In" button.
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
            // Keypad Grid
            ForEach(keypadGrid, id: \.self) { row in
                HStack(spacing: 12) {
                    ForEach(row, id: \.self) { key in
                        keypadButton(for: key)
                    }
                }
            }
            
            // Prominent "Lock In Guess" Button
            Button(action: {
                viewModel.lockInGuess()
            }) {
                HStack(spacing: 8) {
                    Image(systemName: "lock.fill")
                    Text("Lock In Guess")
                        .fontWeight(.bold)
                }
                .font(.headline)
                .frame(maxWidth: .infinity)
                .frame(height: 50)
                .background(
                    viewModel.canLockIn
                        ? LinearGradient(colors: [.blue, .indigo], startPoint: .leading, endPoint: .trailing)
                        : LinearGradient(colors: [Color.disabledKey], startPoint: .leading, endPoint: .trailing)
                )
                .foregroundColor(.white)
                .cornerRadius(14)
                .shadow(color: viewModel.canLockIn ? Color.blue.opacity(0.3) : Color.clear, radius: 6, y: 3)
            }
            .disabled(!viewModel.canLockIn)
            .padding(.top, 4)
        }
        .padding(.horizontal)
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
                    .frame(height: 48)
                    .background(Color.cardBackground)
                    .foregroundColor(.secondary)
                    .cornerRadius(10)
            }
        } else if key == "delete" {
            Button(action: {
                viewModel.deleteDigit()
            }) {
                Image(systemName: "delete.left.fill")
                    .font(.title3)
                    .frame(maxWidth: .infinity)
                    .frame(height: 48)
                    .background(Color.cardBackground)
                    .foregroundColor(.secondary)
                    .cornerRadius(10)
            }
        } else {
            let char = key.first!
            let isUsed = viewModel.isDigitUsed(char)
            
            Button(action: {
                viewModel.appendDigit(char)
            }) {
                Text(key)
                    .font(.title2.bold())
                    .frame(maxWidth: .infinity)
                    .frame(height: 48)
                    .background(isUsed ? Color.subtleFill : Color.cardBackground)
                    .foregroundColor(isUsed ? .secondary : .primary)
                    .cornerRadius(10)
                    .overlay(
                        RoundedRectangle(cornerRadius: 10)
                            .stroke(isUsed ? Color.clear : Color.borderSeparator, lineWidth: 0.5)
                    )
            }
            .disabled(isUsed)
        }
    }
}
