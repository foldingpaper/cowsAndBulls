import Foundation
import CowsAndBullsCore

var passedCount = 0
var failedCount = 0

func assertEqual<T: Equatable>(_ actual: T, _ expected: T, _ message: String = "", file: String = #file, line: Int = #line) {
    if actual == expected {
        passedCount += 1
    } else {
        failedCount += 1
        print("❌ FAIL at \(URL(fileURLWithPath: file).lastPathComponent):\(line) - \(message)")
        print("   Expected: \(expected)")
        print("   Actual:   \(actual)")
    }
}

func assertTrue(_ condition: Bool, _ message: String = "", file: String = #file, line: Int = #line) {
    if condition {
        passedCount += 1
    } else {
        failedCount += 1
        print("❌ FAIL at \(URL(fileURLWithPath: file).lastPathComponent):\(line) - Expected true: \(message)")
    }
}

func testScoring() {
    print("Testing Scoring...")
    // 4 Bulls
    let s1 = GameEngine.score(secret: "1234", guess: "1234")
    assertEqual(s1.bulls, 4, "Should have 4 bulls")
    assertEqual(s1.cows, 0, "Should have 0 cows")
    assertTrue(s1.isVictory(), "Should be victory")
    
    // 4 Cows
    let s2 = GameEngine.score(secret: "1234", guess: "4321")
    assertEqual(s2.bulls, 0, "Should have 0 bulls")
    assertEqual(s2.cows, 4, "Should have 4 cows")
    assertTrue(!s2.isVictory(), "Should not be victory")
    
    // Mixed
    let s3 = GameEngine.score(secret: "0482", guess: "0284")
    assertEqual(s3.bulls, 2, "Should have 2 bulls")
    assertEqual(s3.cows, 2, "Should have 2 cows")
    
    // Zero matches
    let s4 = GameEngine.score(secret: "1234", guess: "5678")
    assertEqual(s4.bulls, 0, "Should have 0 bulls")
    assertEqual(s4.cows, 0, "Should have 0 cows")
}

func testValidation() {
    print("Testing Validation...")
    assertEqual(GuessValidator.validate(guess: "0123"), .success("0123"))
    assertEqual(GuessValidator.validate(guess: "  9876 \n"), .success("9876"))
    
    // Invalid length
    assertEqual(GuessValidator.validate(guess: "123"), .failure(.invalidLength(expected: 4, actual: 3)))
    assertEqual(GuessValidator.validate(guess: "12345"), .failure(.invalidLength(expected: 4, actual: 5)))
    
    // Invalid characters
    assertEqual(GuessValidator.validate(guess: "12a4"), .failure(.invalidCharacters(invalid: ["a"])))
    
    // Duplicates
    assertEqual(GuessValidator.validate(guess: "1123"), .failure(.duplicateDigits(duplicates: ["1"])))
}

func testGameEngine() {
    print("Testing GameEngine Flow...")
    let engine = GameEngine(secret: "4820")
    
    let res1 = engine.submitGuess("1234")
    if case .success(let attempt, let state) = res1 {
        assertEqual(attempt.number, 1)
        assertEqual(state, .inProgress(attemptsRemaining: 19))
    } else {
        assertTrue(false, "Expected success for attempt 1")
    }
    
    let res2 = engine.submitGuess("4820")
    if case .success(let attempt, let state) = res2 {
        assertEqual(attempt.number, 2)
        assertEqual(state, .won(attemptsCount: 2, secret: "4820"))
    } else {
        assertTrue(false, "Expected victory for attempt 2")
    }
    
    // Test concede
    let concedeEngine = GameEngine(secret: "9876")
    _ = concedeEngine.submitGuess("1234")
    let secret = concedeEngine.concede()
    assertEqual(secret, "9876")
    assertEqual(concedeEngine.state, .conceded(secret: "9876"))
    
    // Test 20 attempts limit
    let limitEngine = GameEngine(secret: "0000")
    for _ in 1...19 {
        _ = limitEngine.submitGuess("1234")
    }
    let last = limitEngine.submitGuess("1234")
    if case .success(let attempt, let state) = last {
        assertEqual(attempt.number, 20)
        assertEqual(state, .lost(secret: "0000"))
    } else {
        assertTrue(false, "Expected loss on 20th attempt")
    }
}

func testRandomGenerator() {
    print("Testing Random Secret Generator...")
    let generator = RandomSecretGenerator()
    let secret = generator.generateSecret()
    assertEqual(secret.count, 4)
    assertEqual(Set(secret).count, 4)
}

testScoring()
testValidation()
testGameEngine()
testRandomGenerator()

print("\n-----------------------------------------")
if failedCount == 0 {
    print("🎉 All \(passedCount) tests passed successfully!")
    exit(0)
} else {
    print("💥 \(failedCount) test(s) failed out of \(passedCount + failedCount)!")
    exit(1)
}
