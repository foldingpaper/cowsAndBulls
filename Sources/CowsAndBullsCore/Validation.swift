import Foundation

/// Possible validation errors when checking a player's guess.
public enum ValidationError: LocalizedError, Equatable {
    case emptyInput
    case invalidLength(expected: Int, actual: Int)
    case invalidCharacters(invalid: [Character])
    case duplicateDigits(duplicates: [Character])
    
    public var errorDescription: String? {
        switch self {
        case .emptyInput:
            return "Guess cannot be empty. Please enter a 4-digit number."
        case .invalidLength(let expected, let actual):
            return "Expected \(expected) digits, but you entered \(actual)."
        case .invalidCharacters(let invalid):
            let chars = invalid.map { String($0) }.joined(separator: ", ")
            return "Invalid character(s): [\(chars)]. Only numbers 0-9 are allowed."
        case .duplicateDigits(let duplicates):
            let uniqueDupes = Array(Set(duplicates)).sorted().map { String($0) }.joined(separator: ", ")
            return "All digits must be unique! Repeated digit(s): [\(uniqueDupes)]."
        }
    }
}

/// Validator for player guesses according to game configuration.
public struct GuessValidator {
    public static func validate(guess: String, config: GameConfig = .default) -> Result<String, ValidationError> {
        let trimmed = guess.trimmingCharacters(in: .whitespacesAndNewlines)
        
        guard !trimmed.isEmpty else {
            return .failure(.emptyInput)
        }
        
        guard trimmed.count == config.codeLength else {
            return .failure(.invalidLength(expected: config.codeLength, actual: trimmed.count))
        }
        
        let invalidChars = trimmed.filter { !config.allowedDigits.contains($0) }
        guard invalidChars.isEmpty else {
            return .failure(.invalidCharacters(invalid: Array(invalidChars)))
        }
        
        if config.requireUniqueDigits {
            var seen = Set<Character>()
            var duplicates = [Character]()
            for char in trimmed {
                if seen.contains(char) {
                    duplicates.append(char)
                } else {
                    seen.insert(char)
                }
            }
            guard duplicates.isEmpty else {
                return .failure(.duplicateDigits(duplicates: duplicates))
            }
        }
        
        return .success(trimmed)
    }
}
