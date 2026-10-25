# Project History & Architectural Decisions

This document tracks the evolution, key milestones, and architectural decisions for the **Cows and Bulls** project.

---

## 1. Project Overview & Requirements

* **Game**: Cows and Bulls (classic 4-digit code-breaking game).
* **Mode**: Single-player vs computer opponent.
* **Architecture**: 100% local in-memory state; zero backend server dependencies.
* **Rules Baseline** (documented in [`rawDocs/game.txt`](file:///Users/skand/projects/cowsAndBulls/rawDocs/game.txt)):
  * 4 unique (non-repeating) digits from `0` to `9` (leading zeros permitted).
  * Up to 20 attempts before a loss.
  * Early surrender/concede reveals the secret number.
  * Bulls = correct digit in correct position; Cows = correct digit in wrong position.
* **Roadmap** (documented in [`rawDocs/plan.txt`](file:///Users/skand/projects/cowsAndBulls/rawDocs/plan.txt)):
  * **Phase 1**: Command-line game (CLI).
  * **Phase 2**: Mobile app (iOS).

---

## 2. Phase 1: Swift CLI Implementation (Completed)

* **Language Decision**: Swift 5.8 was selected for the CLI to establish a unified codebase that can be directly shared with the iOS app.
* **Package Structure**:
  * [`Sources/CowsAndBullsCore/`](file:///Users/skand/projects/cowsAndBulls/Sources/CowsAndBullsCore): Pure Swift library containing game rules, validation, scoring algorithms, and secret code generation.
  * [`Sources/CowsAndBullsCLI/`](file:///Users/skand/projects/cowsAndBulls/Sources/CowsAndBullsCLI): Interactive terminal interface featuring:
    * Clear attempt history table re-rendered each round.
    * Guess locking mechanism with pre-submission validation.
    * Dual display modes: **Classic** (`B` / `C`, default) and **Cartoon** (`🐂` / `🐮`).
    * Quirky commentary on cows and bulls found.
    * Native macOS audio effects via non-blocking `afplay` and text-to-speech `say` (with mute/toggle option).
    * Celebratory win fanfare and empathetic game-over/concede screens.
  * [`Tests/CowsAndBullsCoreTests/`](file:///Users/skand/projects/cowsAndBulls/Tests/CowsAndBullsCoreTests): Full automated test suite (26 passing test cases).
* **Build System**: [`Makefile`](file:///Users/skand/projects/cowsAndBulls/Makefile) provided for `make build`, `make test`, and `make run`.

---

## 3. Architectural Decision Record (ADR): Mobile App Tech Stack

### Date: 2026-10-24
### Status: **Accepted**

### Context
When planning Phase 2 (the mobile app in [`iOS/`](file:///Users/skand/projects/cowsAndBulls/iOS)), the team evaluated whether to implement the mobile client as a **web-wrapped application** (e.g., Capacitor, Cordova, or an embedded `WKWebView`) or as a **Native SwiftUI** application.

### Options Considered

#### Option A: Web-Wrapped App (HTML/CSS/JS + Capacitor/Cordova/WKWebView)
* **Pros**:
  * Write once for cross-platform (Web, Android, iOS).
  * Rapid UI/CSS styling and instant in-browser preview without needing Xcode installed.
* **Cons**:
  * Cannot directly consume the existing [`CowsAndBullsCore`](file:///Users/skand/projects/cowsAndBulls/Sources/CowsAndBullsCore) Swift module; requires duplicating game logic in JavaScript/TypeScript.
  * Introduces WebView performance overhead, potential touch/scroll latencies, and non-native input keyboard handling.
  * Still requires full `Xcode.app` on macOS to compile and sign the final iOS `.ipa`.
  * Extra tooling complexity (Node.js, npm packages, bridge dependencies).

#### Option B: Native SwiftUI (Chosen)
* **Pros**:
  * **Direct Logic Sharing**: Links directly to [`CowsAndBullsCore`](file:///Users/skand/projects/cowsAndBulls/Sources/CowsAndBullsCore) with zero code duplication.
  * **Minimal Footprint**: The entire UI (number pad, attempt history scroll view, cartoon icon animations) requires only ~150–200 lines of clean, declarative Swift.
  * **Native Polish**: Out-of-the-box support for iOS haptics (`UIImpactFeedbackGenerator`), native numeric keypad, smooth scrolling, and `AVFoundation` audio playback.
  * **Consistent Ecosystem**: Aligns the CLI and iOS codebase under the same language, toolchain, and mental model.
* **Cons**:
  * Limited to Apple platforms (iOS/iPadOS/macOS).
  * Requires `Xcode.app` installed to run in the iOS Simulator or deploy to a device.

### Decision
**Proceed with Native SwiftUI.** 

Given that the target is specifically iOS and the game engine is already implemented and validated in Swift, Native SwiftUI delivers the cleanest architecture, maximum code reuse, and the most responsive mobile user experience without web-wrapper overhead.

---

## 4. Phase 2: Native SwiftUI iOS App (Completed)

* **Architecture**: Complete SwiftUI iOS app placed in [`iOS/`](file:///Users/skand/projects/cowsAndBulls/iOS).
* **Xcode Project**: Fully configured [`iOS/CowsAndBulls.xcodeproj`](file:///Users/skand/projects/cowsAndBulls/iOS/CowsAndBulls.xcodeproj) ready to open in Xcode (`open iOS/CowsAndBulls.xcodeproj`).
* **Components Built**:
  * **Core Logic Sharing**: Complete game rules and scoring models imported in [`iOS/CowsAndBulls/Core/`](file:///Users/skand/projects/cowsAndBulls/iOS/CowsAndBulls/Core).
  * **MVVM Layer**: [`GameViewModel.swift`](file:///Users/skand/projects/cowsAndBulls/iOS/CowsAndBulls/ViewModels/GameViewModel.swift) handling reactive state, error messages, and guess submission.
  * **Interactive Keypad & Input**: [`KeypadView.swift`](file:///Users/skand/projects/cowsAndBulls/iOS/CowsAndBulls/Views/KeypadView.swift) with automatic dimming of already-used digits, and prominent `🔒 Lock In Guess` button.
  * **Attempt History Board**: [`AttemptBoardView.swift`](file:///Users/skand/projects/cowsAndBulls/iOS/CowsAndBulls/Views/AttemptBoardView.swift) and [`AttemptRowView.swift`](file:///Users/skand/projects/cowsAndBulls/iOS/CowsAndBulls/Views/AttemptRowView.swift) presenting cartoon 🐮 and 🐂 face indicators with quirky commentary for every attempt.
  * **Tactile & Sound Feedback**: [`HapticManager.swift`](file:///Users/skand/projects/cowsAndBulls/iOS/CowsAndBulls/Services/HapticManager.swift) and [`SoundManager.swift`](file:///Users/skand/projects/cowsAndBulls/iOS/CowsAndBulls/Services/SoundManager.swift) via `AudioToolbox` and `AVSpeechSynthesizer`.
  * **Celebratory & Empathetic Overlays**:
    * [`VictoryView.swift`](file:///Users/skand/projects/cowsAndBulls/iOS/CowsAndBulls/Views/VictoryView.swift): Celebratory congratulations modal with stats and secret reveal.
    * [`GameOverView.swift`](file:///Users/skand/projects/cowsAndBulls/iOS/CowsAndBulls/Views/GameOverView.swift): Empathetic better luck next time modal when running out of attempts or conceding early.
    * [`RulesSheetView.swift`](file:///Users/skand/projects/cowsAndBulls/iOS/CowsAndBulls/Views/RulesSheetView.swift): Rules and indicator explanations.

---

## 5. Status & Future Enhancements

* [x] Core game engine implementation and unit tests.
* [x] Feature-complete Swift CLI game with audio, board rendering, and cartoon toggles.
* [x] Architectural decision: Native SwiftUI for iOS.
* [x] Native SwiftUI project scaffolding and implementation in [`iOS/`](file:///Users/skand/projects/cowsAndBulls/iOS).
* [x] Verified compilation across iOS 18 SDK and added shared scheme [`CowsAndBulls.xcscheme`](file:///Users/skand/projects/cowsAndBulls/iOS/CowsAndBulls.xcodeproj/xcshareddata/xcschemes/CowsAndBulls.xcscheme).
* [ ] (Optional) Computer AI Solver / reverse mode (where player sets the secret and computer guesses).
