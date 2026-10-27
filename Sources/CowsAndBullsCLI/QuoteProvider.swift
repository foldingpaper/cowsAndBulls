import Foundation

public class QuoteProvider {
    public static let shared = QuoteProvider()
    
    public static let defaultQuotes: [String] = [
        "The steaks have never been higher: Bulls mean you're spot-on, Cows mean you're in the right pasture but the wrong stall.",
        "Welcome to the pasture! Bulls are locked in their pens, Cows are grazing in the wrong field, and you're the detective in overalls.",
        "Holy cow, we've got a code to milk: Bulls hit the bullseye, Cows are wandering off-target. Think you can outsmart the herd?",
        "Welcome to the farm: Bulls are right on the money, Cows are trespassing where they shouldn't, and too many misses will put you out to pasture.",
        "Ranch rules: Bulls are right digit, right pen. Cows are right digit, wrong pasture. Let's herd some numbers!",
        "Bulls are dead-center in the barn, Cows are loitering around the paddock—crack the farmer's secret combination!"
    ]
    
    public private(set) var quotes: [String] = []
    
    public init() {
        self.quotes = loadQuotes()
    }
    
    private struct QuotesContainer: Decodable {
        let quotes: [String]
    }
    
    public func loadQuotes() -> [String] {
        let fileManager = FileManager.default
        var searchPaths: [String] = []
        
        // 1. Explicit environment variable override
        if let envPath = ProcessInfo.processInfo.environment["COWS_AND_BULLS_QUOTES_PATH"] {
            searchPaths.append(envPath)
        }
        
        // 2. Current working directory
        let cwd = fileManager.currentDirectoryPath
        searchPaths.append("\(cwd)/Resources/quotes.json")
        searchPaths.append("\(cwd)/quotes.json")
        
        // 3. Executable binary directory & parent directory
        if let execURL = Bundle.main.executableURL {
            let execDir = execURL.deletingLastPathComponent().path
            searchPaths.append("\(execDir)/Resources/quotes.json")
            searchPaths.append("\(execDir)/quotes.json")
            searchPaths.append("\(execDir)/../Resources/quotes.json")
        }
        
        for path in searchPaths {
            guard fileManager.fileExists(atPath: path) else { continue }
            guard let data = try? Data(contentsOf: URL(fileURLWithPath: path)) else { continue }
            
            // Format A: JSON Array of Strings ["quote 1", "quote 2", ...]
            if let decoded = try? JSONDecoder().decode([String].self, from: data), !decoded.isEmpty {
                return decoded
            }
            
            // Format B: JSON Object with "quotes" key { "quotes": ["quote 1", ...] }
            if let decoded = try? JSONDecoder().decode(QuotesContainer.self, from: data), !decoded.quotes.isEmpty {
                return decoded.quotes
            }
        }
        
        return QuoteProvider.defaultQuotes
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
