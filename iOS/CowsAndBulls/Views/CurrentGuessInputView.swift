import SwiftUI

/// Displays the 4 digit slots currently being keyed in by the player.
public struct CurrentGuessInputView: View {
    public let currentInput: [Character]
    public let errorMessage: String?
    public let codeLength: Int
    
    public init(currentInput: [Character], errorMessage: String? = nil, codeLength: Int = 4) {
        self.currentInput = currentInput
        self.errorMessage = errorMessage
        self.codeLength = codeLength
    }
    
    public var body: some View {
        VStack(spacing: 6) {
            // 4-Digit Boxes
            HStack(spacing: 12) {
                ForEach(0..<codeLength, id: \.self) { index in
                    let hasDigit = index < currentInput.count
                    let isNextActive = index == currentInput.count
                    let charString = hasDigit ? String(currentInput[index]) : ""
                    
                    Text(charString)
                        .font(.system(size: 28, weight: .bold, design: .monospaced))
                        .frame(width: 54, height: 58)
                        .background(Color.cardBackground)
                        .overlay(
                            RoundedRectangle(cornerRadius: 12)
                                .stroke(
                                    isNextActive ? Color.blue : Color.clear,
                                    lineWidth: 2
                                )
                        )
                        .cornerRadius(12)
                        .shadow(color: Color.black.opacity(hasDigit ? 0.06 : 0), radius: 2, y: 1)
                }
            }
            
            // Error Message / Helper Label
            if let error = errorMessage {
                Text(error)
                    .font(.caption)
                    .foregroundColor(.red)
                    .bold()
                    .transition(.opacity)
            } else if currentInput.count == codeLength {
                Text("Press 'Lock In Guess' to submit your attempt")
                    .font(.caption)
                    .foregroundColor(.secondary)
            } else {
                Text("Enter \(codeLength - currentInput.count) more unique digit\(codeLength - currentInput.count == 1 ? "" : "s")")
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
        }
        .padding(.vertical, 4)
    }
}
