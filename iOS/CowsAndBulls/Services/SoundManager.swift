import Foundation
import AudioToolbox
import AVFoundation

/// Manages quirky audio cues and speech effects for the iOS game.
public class SoundManager: ObservableObject {
    public static let shared = SoundManager()
    
    @Published public var isMuted: Bool = false
    
    private let speechSynthesizer = AVSpeechSynthesizer()
    
    private init() {
        // Configure audio session to play nicely with device settings
        #if os(iOS)
        do {
            try AVAudioSession.sharedInstance().setCategory(.ambient, mode: .default)
            try AVAudioSession.sharedInstance().setActive(true)
        } catch {
            // Non-critical audio configuration
        }
        #endif
    }
    
    public func toggleMute() {
        isMuted.toggle()
    }
    
    public func playDigitTap() {
        guard !isMuted else { return }
        AudioServicesPlaySystemSound(1104) // iOS keyboard tap sound
    }
    
    public func playDelete() {
        guard !isMuted else { return }
        AudioServicesPlaySystemSound(1155) // Delete sound
    }
    
    public func playGuessSubmitted(bulls: Int, cows: Int) {
        guard !isMuted else { return }
        if bulls > 0 {
            AudioServicesPlaySystemSound(1057) // Crisp chime
        } else if cows > 0 {
            AudioServicesPlaySystemSound(1103) // Pop chime
        } else {
            AudioServicesPlaySystemSound(1052) // Low tick
        }
    }
    
    public func playVictory() {
        guard !isMuted else { return }
        AudioServicesPlaySystemSound(1025) // Fanfare / celebratory chime
        speak("Holy cow! You cracked the code!")
    }
    
    public func playLoss() {
        guard !isMuted else { return }
        AudioServicesPlaySystemSound(1073) // Gentle descending chime
        speak("Better luck next time!")
    }
    
    public func playConcede() {
        guard !isMuted else { return }
        AudioServicesPlaySystemSound(1054) // Soft notification
        speak("Round conceded. You'll get it next time!")
    }
    
    private func speak(_ text: String) {
        guard !isMuted else { return }
        let utterance = AVSpeechUtterance(string: text)
        utterance.rate = AVSpeechUtteranceDefaultSpeechRate * 0.95
        utterance.pitchMultiplier = 1.15 // Slightly quirky pitch
        utterance.volume = 0.85
        speechSynthesizer.speak(utterance)
    }
}
