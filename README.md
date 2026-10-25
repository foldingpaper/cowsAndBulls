# Cows and Bulls (Swift CLI)

A command-line implementation of the classic **Cows and Bulls** code-breaking game written in Swift.

---

## 🎯 Game Rules

* The computer generates a secret **4-digit code** with **unique (non-repeating) digits** from `0` to `9`.
* For every digit in your guess that matches both the digit and its **exact position** $\rightarrow$ **Bull (`B` / 🐂)**.
* For every digit present in the code but in the **wrong position** $\rightarrow$ **Cow (`C` / 🐮)**.
* **4 Bulls** wins the round!
* You have up to **20 attempts** before losing.
* You can surrender anytime with `quit` or `concede` to reveal the secret code.

---

## 🚀 Quick Start

### Build and Run
```bash
# Build the project
make build

# Run the game
make run
# or directly:
./cows-and-bulls
```

### Run Tests
```bash
make test
```

---

## 🎮 Options & In-Game Commands

### Command Line Flags
| Flag | Description |
|---|---|
| `-c`, `--cartoon` | Launch directly with cartoon icons (`🐂` / `🐮`) |
| `-m`, `--mute` | Disable sound and voice effects |
| `--confirm` | Ask for explicit confirmation to lock in each guess |
| `--secret <code>` | Set a predetermined secret for debugging/testing |
| `-h`, `--help` | Show usage options |

### In-Game Commands
* `mode` or `m`: Toggle between Classic (`B`/`C`) and Cartoon (`🐂`/`🐮`) display modes.
* `sound` or `s`: Toggle audio effects on/off.
* `quit` or `concede`: Give up the round and reveal the secret code.
* `help` or `h`: Print instructions and rules.

---

## 🧩 Architecture & History

The project is structured with modularity in mind:
* `Sources/CowsAndBullsCore/`: Pure Swift engine handling game state, rules, validation, scoring, and secret generation. Ready to be shared directly with future platforms (such as the iOS app).
* `Sources/CowsAndBullsCLI/`: Interactive terminal UI, attempt history board renderer, and macOS audio engine (`afplay` & `say`).
* `Tests/CowsAndBullsCoreTests/`: Comprehensive test suite verifying game logic and edge cases.

For design rationales and architectural decisions (such as Native SwiftUI vs. Web-Wrapped), see [PROJECT_HISTORY.md](file:///Users/skand/projects/cowsAndBulls/PROJECT_HISTORY.md).
