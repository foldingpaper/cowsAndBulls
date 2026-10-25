# Cows and Bulls (iOS App)

A native iOS implementation of **Cows and Bulls** built with **SwiftUI** and shared core logic from `CowsAndBullsCore`.

---

## 📱 Features

- **Cartoon-like Cow & Bull Faces**: 🐮 for Cows and 🐂 for Bulls with quirky commentary.
- **Clear Attempt Board**: Scrollable list showing all previous attempts in clear view.
- **Intuitive 4-Digit Keypad**: On-screen keypad with automatic dimming of already-used digits to enforce the unique digits rule, plus a dedicated **"🔒 Lock In Guess"** button.
- **Audio & Haptic Effects**: Tactile haptics (`UIImpactFeedbackGenerator` & `UINotificationFeedbackGenerator`) and sound effects (`AudioToolbox` & `AVSpeechSynthesizer`).
- **Celebratory Victory Screen**: Big celebratory congratulations modal with stats and performance ratings.
- **Empathetic Better Luck Next Time Screen**: Kind, encouraging message when out of attempts or conceding early, with the secret code revealed.
- **Zero Backend**: 100% offline in-memory state.

---

## 🚀 How to Run in Xcode

1. Open the project in Xcode:
   ```bash
   open iOS/CowsAndBulls.xcodeproj
   ```
2. Select an iOS Simulator (e.g. **iPhone 15** or **iPhone 16**) from the target device dropdown at the top.
3. Press **Cmd + R** (or click the **Play** button) to build and run!

---

## 📂 Architecture

```
iOS/
├── CowsAndBulls.xcodeproj/      # Valid Xcode project file
└── CowsAndBulls/
    ├── App/
    │   └── CowsAndBullsApp.swift      # SwiftUI @main entry point
    ├── Core/                          # Pure game engine logic (shared with CLI)
    │   ├── Attempt.swift
    │   ├── GameConfig.swift
    │   ├── GameEngine.swift
    │   ├── Score.swift
    │   ├── SecretGenerator.swift
    │   └── Validation.swift
    ├── ViewModels/
    │   └── GameViewModel.swift        # State management, input buffer, game loop
    ├── Views/
    │   ├── MainGameView.swift         # Root layout view
    │   ├── AttemptBoardView.swift     # Scrollable attempt history
    │   ├── AttemptRowView.swift       # Cartoon indicators and quirky commentary
    │   ├── CurrentGuessInputView.swift# 4-digit input slots
    │   ├── KeypadView.swift           # 0-9 keypad with "Lock In" button
    │   ├── VictoryView.swift          # Celebratory modal
    │   ├── GameOverView.swift         # Empathetic game over modal
    │   ├── RulesSheetView.swift       # Rules and instructions sheet
    │   └── ColorTheme.swift           # Semantic color palette
    ├── Services/
    │   ├── HapticManager.swift        # iOS haptics
    │   └── SoundManager.swift         # Sound effects and speech synthesis
    └── Resources/
        ├── Info.plist
        └── Assets.xcassets/           # App icon and accent color
```
