import Foundation

/// Configuration options for the Cows and Bulls game.
public struct GameConfig: Equatable {
    /// Number of digits in the secret code. Default is 4.
    public let codeLength: Int
    
    /// Maximum attempts allowed before losing. Default is 20.
    public let maxAttempts: Int
    
    /// Whether all digits in the secret and guess must be unique. Default is true.
    public let requireUniqueDigits: Bool
    
    /// Set of allowed characters. Default is 0-9.
    public let allowedDigits: Set<Character>
    
    public init(
        codeLength: Int = 4,
        maxAttempts: Int = 20,
        requireUniqueDigits: Bool = true,
        allowedDigits: Set<Character> = Set("0123456789")
    ) {
        self.codeLength = codeLength
        self.maxAttempts = maxAttempts
        self.requireUniqueDigits = requireUniqueDigits
        self.allowedDigits = allowedDigits
    }
    
    public static let `default` = GameConfig()
}
