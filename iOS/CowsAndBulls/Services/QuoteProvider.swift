import Foundation

/// Provides quirky farm quotes for the Cows and Bulls iOS app, loaded from the bundle JSON with fallback defaults.
public class QuoteProvider {
    public static let shared = QuoteProvider()
    
    public static let defaultQuotes: [String] = [
        "The steaks have never been higher: Bulls mean you're spot-on, Cows mean you're in the right pasture but the wrong stall.",
        "Welcome to the pasture! Bulls are locked in their pens, Cows are grazing in the wrong field, and you're the detective in overalls.",
        "Holy cow, we've got a code to milk: Bulls hit the bullseye, Cows are wandering off-target. Think you can outsmart the herd?",
        "Welcome to the farm: Bulls are right on the money, Cows are trespassing where they shouldn't, and too many misses will put you out to pasture.",
        "Ranch rules: Bulls are right digit, right pen. Cows are right digit, wrong pasture. Let's herd some numbers!",
        "Bulls are dead-center in the barn, Cows are loitering around the paddock—crack the farmer's secret combination!",
        "No bull here: hit 4 Bulls to lasso the victory, or get nudged by Cows telling you your digits are lost in the meadow.",
        "Don't have a cow, man! If a digit is in the code but out of place, she's just a Cow mooing for direction.",
        "Pasture alert: Each Bull brings you closer to the barn door; each Cow means you took a wrong turn at the silo.",
        "Grab the bull by the horns! Guess the digits, corral the clues, and don't let the cows run amok.",
        "Farm fresh deductive reasoning: Bulls are ripe for harvest, Cows are still green and out of position.",
        "Udderly perplexing: crack the 4-digit code before the herd breaks loose through the fence!"
    ]
    
    public static let defaultCowOpeners: [String] = [
        "Psst... heard any fresh pasture rumors?",
        "Moo-ve over, what's the word by the barn?",
        "Word around the silo is you know something...",
        "Hey Bull, spit it out—what did the tractor driver say?",
        "Tell me the latest paddock scoop!",
        "Chewing on anything juicy besides cud today?",
        "Don't keep me in the dark paddock, what's the rumor?",
        "Any truth to what the hens are clucking about?",
        "Psst... got any tips for cracking this farmer's lock?",
        "Spill the milk, Bull—what's the pasture saying?",
        "You've got that look... what secret are you hiding?",
        "Are the numbers wandering into the meadow again?"
    ]
    
    public private(set) var quotes: [String] = []
    public private(set) var cowOpeners: [String] = []
    
    public init() {
        self.quotes = loadQuotes()
        self.cowOpeners = loadCowOpeners()
    }
    
    private struct QuotesContainer: Decodable {
        let quotes: [String]
    }
    
    public func loadQuotes() -> [String] {
        if let url = Bundle.main.url(forResource: "quotes", withExtension: "json"),
           let data = try? Data(contentsOf: url) {
            if let decoded = try? JSONDecoder().decode([String].self, from: data), !decoded.isEmpty {
                return decoded
            }
            if let decoded = try? JSONDecoder().decode(QuotesContainer.self, from: data), !decoded.quotes.isEmpty {
                return decoded.quotes
            }
        }
        
        return QuoteProvider.defaultQuotes
    }
    
    public func loadCowOpeners() -> [String] {
        return QuoteProvider.defaultCowOpeners
    }
    
    public func randomCowOpener(excluding current: String? = nil) -> String {
        let pool = cowOpeners.isEmpty ? QuoteProvider.defaultCowOpeners : cowOpeners
        if let current = current, pool.count > 1 {
            let filtered = pool.filter { $0 != current }
            if let chosen = filtered.randomElement() {
                return chosen
            }
        }
        return pool.randomElement() ?? QuoteProvider.defaultCowOpeners[0]
    }
    
    public func randomQuote(excluding current: String? = nil) -> String {
        let pool = quotes.isEmpty ? QuoteProvider.defaultQuotes : quotes
        if let current = current, pool.count > 1 {
            let filtered = pool.filter { $0 != current }
            if let chosen = filtered.randomElement() {
                return chosen
            }
        }
        return pool.randomElement() ?? QuoteProvider.defaultQuotes[0]
    }
}
