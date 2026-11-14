# Project History & Architectural Decisions

This document tracks the evolution, key milestones, and architectural decisions for the **Cows and Bulls** project.
* For a curated showcase of playful UX flourishes, see [`NICE_IDEAS.md`](file:///Users/skand/projects/cowsAndBulls/NICE_IDEAS.md).
* For the pre-device deployment stability verification, see [`DEVICE_STABILITY_AUDIT.md`](file:///Users/skand/projects/cowsAndBulls/DEVICE_STABILITY_AUDIT.md).
* For the complete App Store upload and metadata guide, see [`APP_STORE_SUBMISSION_CHECKLIST.md`](file:///Users/skand/projects/cowsAndBulls/APP_STORE_SUBMISSION_CHECKLIST.md).

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

## 5. Phase 3: Externalized Farm Intro Quotes (Completed)

* **Date**: 2026-10-26 – 2026-11-01
* **Objective**: Introduce quirky farm-themed 1-to-1.5 liner introductions that cycle dynamically on each new game, externalized in JSON for easy maintenance.
* **CLI Implementation**:
  * [`Resources/quotes.json`](file:///Users/skand/projects/cowsAndBulls/Resources/quotes.json): Externalized pool of 12 witty cow/bull quotes.
  * [`QuoteProvider.swift`](file:///Users/skand/projects/cowsAndBulls/Sources/CowsAndBullsCLI/QuoteProvider.swift): Service to parse JSON bundle resource or fallback safely to built-in defaults, providing non-repeating random selection.
  * Integrated into [`BoardRenderer.swift`](file:///Users/skand/projects/cowsAndBulls/Sources/CowsAndBullsCLI/BoardRenderer.swift) and [`CLIApp.swift`](file:///Users/skand/projects/cowsAndBulls/Sources/CowsAndBullsCLI/CLIApp.swift) to display `🌾 [quote]` in the game header.
* **iOS Implementation**:
  * [`iOS/CowsAndBulls/Resources/quotes.json`](file:///Users/skand/projects/cowsAndBulls/iOS/CowsAndBulls/Resources/quotes.json): Bundled resource in the iOS target.
  * [`iOS/CowsAndBulls/Services/QuoteProvider.swift`](file:///Users/skand/projects/cowsAndBulls/iOS/CowsAndBulls/Services/QuoteProvider.swift): Dedicated provider for SwiftUI views.
  * [`iOS/CowsAndBulls/Views/QuoteBannerView.swift`](file:///Users/skand/projects/cowsAndBulls/iOS/CowsAndBulls/Views/QuoteBannerView.swift): Interactive rotating quote banner positioned under the header bar, featuring tap-to-cycle with tactile feedback, auto-rotation timer, and per-new-game quote cycling.

---

## 6. Phase 4: World Pasture Theme Selector (Completed)

* **Date**: 2026-11-01
* **Design Philosophy**: Keep the signature farm identity, retaining **Original** as the clean Apple iOS default while offering 5 immersive world grazing pastures.
* **Themes Built**:
  1. 🐮 **Original** (Default): Native Apple system grouped colors adapting seamlessly to system Light and Dark modes.
  2. 🚜 **Classic Barnyard**: Warm sunny amber, rustic red barn headers, and countryside pasture greens.
  3. 🏔️ **Swiss Alpine Meadow**: Crisp mountain sky-blue, snow slate, edelweiss gold & brass cowbells.
  4. 🇳🇿 **New Zealand Pasture**: Rich emerald rolling hills, deep fern greens, and misty morning teal atmosphere.
  5. 🤠 **Texas / Outback Ranch**: Sun-drenched canyon terracotta, rustic leather tan, and golden sunset hues.
  6. 🌙 **Midnight Pasture**: Moonlit indigo night sky, dark slate, and glowing firefly accents (OLED dark theme).
* **Components Built**:
  * [`PastureTheme.swift`](file:///Users/skand/projects/cowsAndBulls/iOS/CowsAndBulls/Views/PastureTheme.swift): Strong enum defining the 6 palettes (app background, card, surface, text, bull/cow accents, preferred color scheme).
  * [`PastureThemeSelectorView.swift`](file:///Users/skand/projects/cowsAndBulls/iOS/CowsAndBulls/Views/PastureThemeSelectorView.swift): Compact horizontal capsule switcher placed right on the main game board between the Quote Banner and Attempt Progress pill.
  * [`GameViewModel.swift`](file:///Users/skand/projects/cowsAndBulls/iOS/CowsAndBulls/ViewModels/GameViewModel.swift): Theme state management with `@AppStorage` / `UserDefaults` persistence across app launches.
  * Verified compilation across iOS Simulator via `xcodebuild` (`** BUILD SUCCEEDED **`).

---

## 7. Architectural Decision Record (ADR): Responsive Dynamic Layout & Progressive Disclosure

### Date: 2026-11-02
### Status: **Accepted**

### Context
On standard mobile viewports (~844pt height), having permanent top chrome (Header, Quote Banner, Pasture Switcher, Attempt Counter) alongside a fixed 4-row keypad and full-width "Lock In" button consumed ~490pt of vertical space. This constrained the Attempt Board to only ~270pt (showing only 3–4 attempts before requiring scrolling). Furthermore, the quirky quotes lacked a grand stage on initial round startup.

### Architectural Decisions

1. **Two-Phase Progressive Disclosure**:
   * **Phase 1: "The Pasture Welcome" (Attempt 0)**: The entire board area transforms into a vibrant **Hero Stage** showcasing rich quote typography, animated wandering cows & bulls (`🐮`, `🐂`, `🌾`), and the full World Pasture theme switcher.
   * **Phase 2: "The Codebreaker's Desk" (Attempt 1+)**: Upon submitting the first guess, the Hero Stage smoothly scales and fades away, giving 100% of the screen over to the Attempt History Board.
2. **Unified Input & Lock-In Bar**:
   * Combines the 4-digit input slots and the prominent `[ 🔒 Lock In ]` button into a single horizontal row (`[ 4 ] [ 8 ] [ 1 ] [ _ ]  [ 🔒 Lock In ]  [ ⌵ ]`), reclaiming ~50pt of vertical space.
3. **Collapsible iPad-Style Keypad Dock**:
   * Supports an expanded typing state and a collapsed dock state.
   * Collapsing the keypad expands the Attempt Board from ~320pt to **~550pt** (fitting 8–10 attempts simultaneously).
   * Tapping or dragging through previous attempts on the board automatically dismisses/collapses the keypad.
   * The merged input bar remains docked at the bottom even when collapsed, allowing instant lock-in or one-tap keypad reopening.
4. **Chronological Journal with Rock-Solid Auto-Scroll**:
   * Preserves the top-to-bottom deduction timeline (`#01` down to `#20`).
   * Eliminates sort-order toggle buttons to avoid cognitive clutter.
   * Fixes auto-scroll reliability by using standard `VStack` and a bottom scroll anchor.
5. **Active Tappable Header Title & Dialogue Modal**:
   * The header title `[🐮 Cows & Bulls 🐂]` is interactive. Tapping it summons the "Pasture Rumors & Wisdom" sheet.
   * Dropped the separate `🌾` icon from the top chrome, reducing right-hand actions to 4 buttons and freeing over 200pt of horizontal space so the title never wraps onto a second line on any screen size.
   * The quote sheet is styled as comic dialogue/banter between Cow 🐮 and Bull 🐂, retaining the playful farm dynamic with an option to "Overhear Another Rumor".
   * Quotes now use friendly, rounded semibold typography (`.rounded`) instead of stiff serif italics.
6. **Keypad Expansion Auto-Scroll**:
   * Tapping the keyboard icon to restore the keypad triggers an automatic scroll animation, ensuring recent attempts remain fully visible above the raised keypad.

---

## 8. Physical Device Readiness & Stability Audit (Completed)

* **Date**: 2026-11-09
* **Scope**: Comprehensive pre-deployment stability audit across all iOS presentation, service, and core layers documented in [`DEVICE_STABILITY_AUDIT.md`](file:///Users/skand/projects/cowsAndBulls/DEVICE_STABILITY_AUDIT.md).
* **Key Hardening Actions**:
  * **Force-Unwrap Elimination**: Converted all optional extractions to safe `if let` bindings, ensuring zero runtime force-unwraps.
  * **Index Bounds Resilience**: Protected digit box indices using `indices.contains(index)` to prevent out-of-bounds crashes during rapid typing/deleting.
  * **Audio & Haptic Isolation**: Confirmed `AVAudioSession` category configuration is protected by `do/catch`, and haptics use transient generators behind `#if canImport(UIKit)`.
  * **Graceful Degradation**: Dual-schema JSON decoding for quotes with automatic fallback to 12 in-memory default quotes.
  * **Version Compatibility**: Guarded modern iOS 16 `.presentationDetents` behind `#available(iOS 16.0, *)` to support iOS 15.6 deployment target.

---

## 9. Status & Future Enhancements

* [x] Core game engine implementation and unit tests (26 passing tests).
* [x] Feature-complete Swift CLI game with audio, board rendering, and cartoon toggles.
* [x] Architectural decision: Native SwiftUI for iOS.
* [x] Native SwiftUI project scaffolding and implementation in [`iOS/`](file:///Users/skand/projects/cowsAndBulls/iOS).
* [x] Verified compilation across iOS 18 SDK and added shared scheme [`CowsAndBulls.xcscheme`](file:///Users/skand/projects/cowsAndBulls/iOS/CowsAndBulls.xcodeproj/xcshareddata/xcschemes/CowsAndBulls.xcscheme).
* [x] Externalized quirky farm quotes in JSON and CLI integration.
* [x] World Pasture Theme Selector with 6 presets and persistent storage.
* [x] Custom 1024×1024 App Icon with playful farm duo and padlock.
* [x] Implement Progressive Disclosure Hero Stage for Attempt 0 ([`HeroStageView.swift`](file:///Users/skand/projects/cowsAndBulls/iOS/CowsAndBulls/Views/HeroStageView.swift)).
* [x] Implement Unified Merged Input & Lock-in Bar with iPad-style collapsible keypad ([`UnifiedGuessInputBar.swift`](file:///Users/skand/projects/cowsAndBulls/iOS/CowsAndBulls/Views/UnifiedGuessInputBar.swift), [`KeypadView.swift`](file:///Users/skand/projects/cowsAndBulls/iOS/CowsAndBulls/Views/KeypadView.swift)).
* [x] Implement rock-solid chronological auto-scroll & scroll-to-dismiss gesture on attempt board ([`AttemptBoardView.swift`](file:///Users/skand/projects/cowsAndBulls/iOS/CowsAndBulls/Views/AttemptBoardView.swift)).
* [x] Implement interactive title trigger and Cow & Bull dialogue sheet in [`MainGameView.swift`](file:///Users/skand/projects/cowsAndBulls/iOS/CowsAndBulls/Views/MainGameView.swift).
* [x] Physical device stability & zero-crash resilience audit ([`DEVICE_STABILITY_AUDIT.md`](file:///Users/skand/projects/cowsAndBulls/DEVICE_STABILITY_AUDIT.md)).
* [ ] (Optional) Computer AI Solver / reverse mode (where player sets the secret and computer guesses).
