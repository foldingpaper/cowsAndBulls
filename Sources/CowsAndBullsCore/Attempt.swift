import Foundation

/// Represents a single recorded attempt in the game.
public struct Attempt: Equatable, Codable {
    /// 1-based attempt sequence number.
    public let number: Int
    
    /// The 4-digit guess submitted by the player.
    public let guess: String
    
    /// The resulting Bulls and Cows score.
    public let score: Score
    
    public init(number: Int, guess: String, score: Score) {
        self.number = number
        self.guess = guess
        self.score = score
    }
}
