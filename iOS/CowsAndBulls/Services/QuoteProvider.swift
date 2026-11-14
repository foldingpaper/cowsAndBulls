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
        "Udderly perplexing: crack the 4-digit code before the herd breaks loose through the fence!",
        "Zero Bulls, zero Cows? Great! Four suspects eliminated in one shot.",
        "A Cow is just a lost Bull taking the scenic route—swap her stall!",
        "Two Bulls means you're halfway to glory—don't moo-ve those digits!",
        "Four unique digits, zero duplicates—that's pasture law!",
        "Hit three Bulls and zero Cows? Just one stray left to lasso.",
        "Every miss is just a clue telling you where NOT to graze.",
        "Silence is a clue: digits that don't moo aren't in the code.",
        "Even the sharpest bull switches the middle digits when stuck.",
        "A locked Bull is worth two Cows grazing across the fence.",
        "The lock doesn't care how loud you moo, only how you deduce!",
        "Four Bulls unlock the oats. Let's corral this secret!",
        "True ranch champions crack the vault in single digits.",
        "Listen, a true champion doesn't just guess digits—he senses their pasture aura. Right now, stall three is practically vibrating!",
        "The farmer thought hiding the combination in the silo would fool me. Ha! I speak fluent grain bin, and the oats told me everything.",
        "My horn-tilt theorem never fails: if digit two feels like cold steel and digit four feels like sweet clover, you swap them immediately. It's ranch physics!",
        "I was about to crack the lock on turn two, but where's the drama in that? The crowd came to watch a master herd numbers down to the wire.",
        "According to my sources—the barn owl and a very observant goat—digit five was seen loitering near the tractor. Treat that number with extreme suspicion!",
        "You call it an incorrect guess; I call it a tactical reconnaissance mission to confirm which numbers lacked the courage to be in the code.",
        "The roosters started taking bets on turn four. I put three bales of alfalfa on us cracking this lock before lunchtime. Don't let me down, detective!",
        "Every lock has a weak spot. You just glare at it with supreme bovine authority until the brass tumblers surrender under the pressure.",
        "I overheard the barn mice discussing number theory last Tuesday. None of it made sense, but it gave me a very strong feeling about the outer slots.",
        "Rule number one of the rodeo: never blink when you lock in digit three. Numbers can sense fear, but they respect pure horn energy.",
        "The farmer checked the padlock twice before heading to town. That tells me two things: the secret is delicious, and he knows I'm close.",
        "Some folks need twenty tries; I merely take scenic thinking breaks. Every missed digit is just an apology waiting to become a Bull!"
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
        "Are the numbers wandering into the meadow again?",
        "Psst... did you crack stall one yet?",
        "Hey Bull, got any fresh pasture gossip?",
        "Word at the fence is you've got a secret plan...",
        "Don't just flex your horns—what's the clue?",
        "Is that steam, or are you thinking hard?",
        "Psst... digit 0 was sneaking by the barn!",
        "Chewing on any hot paddock tips today?",
        "Bull, are we cracking this or napping?",
        "Did the farmer drop a clue by the silo?",
        "Spill the grain, Bull—what's the word?",
        "Think the secret is evens or odds today?",
        "Psst... my tail twitch says a Bull is near!",
        "I love how you pause to look wise right before guessing wrong.",
        "I'd give you a hint, but watching you sweat is pure comedy.",
        "Are you actually solving it, or just chewing dramatically?",
        "Zero bulls again? Don't worry, confidence looks great on you.",
        "Even the barn cat figured out digit four three turns ago.",
        "Psst... is your strategy 'guess and pray', or is there a plan?",
        "Careful, Bull—overthinking might pop that shiny nose ring.",
        "I brought clover for brainpower. Clearly, you need both leaves.",
        "You stare at that lock like it owes you pasture rent.",
        "If scratching your ear counted as math, we'd be done by now.",
        "Psst... rumor has it the code has fewer digits than your excuses.",
        "Don't look now, but the scarecrow is laughing at your board."
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
