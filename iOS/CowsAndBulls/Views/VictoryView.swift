import SwiftUI

/// Celebratory modal presented when the player wins by getting 4 Bulls.
public struct VictoryView: View {
    public let attemptsUsed: Int
    public let maxAttempts: Int
    public let secret: String
    public let onPlayAgain: () -> Void
    
    public init(
        attemptsUsed: Int,
        maxAttempts: Int,
        secret: String,
        onPlayAgain: @escaping () -> Void
    ) {
        self.attemptsUsed = attemptsUsed
        self.maxAttempts = maxAttempts
        self.secret = secret
        self.onPlayAgain = onPlayAgain
    }
    
    public var body: some View {
        ZStack {
            Color.black.opacity(0.4)
                .ignoresSafeArea()
            
            VStack(spacing: 20) {
                // Festive Header
                VStack(spacing: 8) {
                    Text("🎉 🏆 🎉")
                        .font(.system(size: 48))
                    
                    Text("CONGRATULATIONS!")
                        .font(.title2.bold())
                        .foregroundColor(.green)
                    
                    Text("You cracked the secret code!")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }
                
                // Secret Reveal Box
                VStack(spacing: 6) {
                    Text("THE SECRET CODE")
                        .font(.caption2.bold())
                        .foregroundColor(.secondary)
                        .tracking(1.5)
                    
                    HStack(spacing: 8) {
                        ForEach(Array(secret.enumerated()), id: \.offset) { _, char in
                            Text(String(char))
                                .font(.system(size: 26, weight: .bold, design: .monospaced))
                                .frame(width: 44, height: 48)
                                .background(Color.green.opacity(0.15))
                                .foregroundColor(.green)
                                .cornerRadius(8)
                        }
                    }
                }
                .padding()
                .background(Color.cardBackground)
                .cornerRadius(14)
                
                // Stats Card
                HStack(spacing: 24) {
                    statBox(title: "Attempts", value: "\(attemptsUsed) / \(maxAttempts)")
                    statBox(title: "Score", value: performanceRating)
                }
                
                // Play Again Button
                Button(action: onPlayAgain) {
                    Text("Play Another Round")
                        .font(.headline.bold())
                        .frame(maxWidth: .infinity)
                        .frame(height: 50)
                        .background(Color.green)
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
    
    private var performanceRating: String {
        switch attemptsUsed {
        case 1...4: return "Psychic! 🧠"
        case 5...8: return "Master! 🕵️"
        case 9...14: return "Sharp! 🎯"
        default: return "Victor! 🏆"
        }
    }
    
    private func statBox(title: String, value: String) -> some View {
        VStack(spacing: 4) {
            Text(title)
                .font(.caption)
                .foregroundColor(.secondary)
            Text(value)
                .font(.headline.bold())
        }
    }
}
