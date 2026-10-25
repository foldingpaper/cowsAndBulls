import Foundation

/// Manages quirky audio effects using macOS built-in afplay and say tools.
public class SoundEffect {
    public static let shared = SoundEffect()
    
    public var isEnabled: Bool = true
    public var speechEnabled: Bool = true
    
    public init() {}
    
    /// Run an audio command asynchronously in the background.
    private func runAsync(_ executable: String, arguments: [String]) {
        guard isEnabled else { return }
        DispatchQueue.global(qos: .userInitiated).async {
            let process = Process()
            process.executableURL = URL(fileURLWithPath: executable)
            process.arguments = arguments
            process.standardOutput = Pipe() // Silence output
            process.standardError = Pipe()
            do {
                try process.run()
                process.waitUntilExit()
            } catch {
                // Audio failure shouldn't interrupt the game
            }
        }
    }
    
    /// Play a sound file from /System/Library/Sounds/
    public func playSystemSound(_ soundName: String) {
        let soundPath = "/System/Library/Sounds/\(soundName).aiff"
        if FileManager.default.fileExists(atPath: soundPath) {
            runAsync("/usr/bin/afplay", arguments: [soundPath])
        }
    }
    
    /// Speak text using macOS text-to-speech.
    public func speak(_ text: String, voice: String? = nil) {
        guard isEnabled && speechEnabled else { return }
        var args = [text]
        if let voice = voice {
            args = ["-v", voice, text]
        }
        runAsync("/usr/bin/say", arguments: args)
    }
    
    /// Sound when submitting a guess.
    public func onGuess(bulls: Int, cows: Int) {
        if bulls > 0 && cows > 0 {
            playSystemSound("Glass")
        } else if bulls > 0 {
            playSystemSound("Tink")
        } else if cows > 0 {
            playSystemSound("Pop")
        } else {
            playSystemSound("Morse")
        }
    }
    
    /// Celebratory audio on victory.
    public func onWin() {
        playSystemSound("Hero")
        speak("Congratulations! You cracked the code!")
    }
    
    /// Empathetic audio on loss.
    public func onLoss() {
        playSystemSound("Basso")
        speak("Better luck next time!")
    }
    
    /// Empathetic audio on concede.
    public func onConcede() {
        playSystemSound("Purr")
        speak("Secret revealed. You'll get it next time!")
    }
}
