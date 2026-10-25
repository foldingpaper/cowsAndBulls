import SwiftUI

/// Empathetic modal presented when the player runs out of attempts or surrenders.
public struct GameOverView: View {
    public let isConceded: Bool
    public let secret: String
    public let onTryAgain: () -> Void
    
    public init(isConceded: Bool = false, secret: String, onTryAgain: @escaping () -> Void) {
        self.isConceded = isConceded
        self.secret = secret
        self.onTryAgain = onTryAgain
    }
    
    public var body: some View {
        ZStack {
            Color.black.opacity(0.4)
                .ignoresSafeArea()
            
            VStack(spacing: 20) {
                // Header
                VStack(spacing: 8) {
                    Text(isConceded ? "🏳️" : "❤️ 🐮")
                        .font(.system(size: 48))
                    
                    Text(isConceded ? "Round Conceded" : "Better Luck Next Time!")
                        .font(.title2.bold())
                        .foregroundColor(isConceded ? .orange : .red)
                    
                    Text(isConceded
                         ? "A strategic retreat! Take a breather and try again."
                         : "That was a tricky combination, but you gave it your all!")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                        .multilineTextAlignment(.center)
                }
                
                // Secret Reveal Box
                VStack(spacing: 6) {
                    Text("THE SECRET CODE WAS")
                        .font(.caption2.bold())
                        .foregroundColor(.secondary)
                        .tracking(1.5)
                    
                    HStack(spacing: 8) {
                        ForEach(Array(secret.enumerated()), id: \.offset) { _, char in
                            Text(String(char))
                                .font(.system(size: 26, weight: .bold, design: .monospaced))
                                .frame(width: 44, height: 48)
                                .background(Color.orange.opacity(0.15))
                                .foregroundColor(.orange)
                                .cornerRadius(8)
                        }
                    }
                }
                .padding()
                .background(Color.cardBackground)
                .cornerRadius(14)
                
                Text("Don't give up—every master codebreaker has tough days on the farm. 🌾")
                    .font(.caption)
                    .foregroundColor(.secondary)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal)
                
                // Try Again Button
                Button(action: onTryAgain) {
                    Text("Try Another Round")
                        .font(.headline.bold())
                        .frame(maxWidth: .infinity)
                        .frame(height: 50)
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(14)
                }
                .padding(.top, 4)
            }
            .padding(24)
            .background(Color.surfaceBackground)
            .cornerRadius(24)
            .shadow(radius: 20)
            .padding(.horizontal, 28)
        }
    }
}
