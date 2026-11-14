# 🚀 App Store Submission Checklist & Guide

**Project**: Cows and Bulls (Native SwiftUI iOS App)  
**Target Platform**: iOS 15.6+ (iPhone & iPad)  
**Target Category**: Games > Puzzle / Board  
**Target Age Rating**: 4+ (All Ages, Zero Data Collection)  

---

## 1. Launch Preparation Tracker

- [ ] **1. App Icon**: Finalize 1024×1024 PNG (RGB, no transparency, square).
- [ ] **2. Screenshots**: Capture 3–5 high-res simulator screenshots (`Cmd + S` in Simulator).
- [ ] **3. Apple Developer Account**: Active membership ($99/year) at [developer.apple.com](https://developer.apple.com).
- [ ] **4. Signing in Xcode**: Select Team in **Signing & Capabilities**; verify unique Bundle Identifier.
- [ ] **5. Web Links**: Set up a one-paragraph Privacy Policy URL and Support URL.
- [ ] **6. App Store Connect Record**: Create new app entry at [appstoreconnect.apple.com](https://appstoreconnect.apple.com).
- [ ] **7. Archive & Upload**: Build via **Product > Archive** and distribute to App Store Connect.
- [ ] **8. Submit for Review**: Attach build, screenshots, and metadata; submit for review.

---

## 2. Screenshot Requirements & Recommended Storyline

### Technical Specifications
| Device Category | Display Size | Pixel Resolution | How to Capture |
| :--- | :--- | :--- | :--- |
| **iPhone (Required)** | 6.7" / 6.9" Super Retina | $1290 \times 2796$ or $1320 \times 2868$ | Launch **iPhone 16 Pro Max** (or 15 Pro Max) in Simulator $\to$ press `Cmd + S` |
| **iPad (Optional\*)** | 13" iPad Pro | $2064 \times 2752$ | Launch **iPad Pro 13-inch (M4)** in Simulator $\to$ press `Cmd + S` |

*\*Note: If iPad support is unchecked in Xcode Deployment Info, iPad screenshots are not required.*

### Recommended 4-Slide Screenshot Storyline

1. **Slide 1: "The Pasture Welcome" (Hero Stage)**
   * **Subject**: The startup meadow screen before Attempt #1.
   * **Visuals**: Animated wandering Cow & Bull, active pasture theme banner, and the unrevealed docked guess bar.
   * **Headline Overlay**: *"Crack the 4-Digit Secret Code"*
   * **Subtitle**: *"Deduce the hidden numbers in 20 attempts or fewer."*

2. **Slide 2: "The Codebreaker's Desk" (Attempt History)**
   * **Subject**: Mid-game board showing 4–6 previous attempts.
   * **Visuals**: Distinct `#01`, `#02` rows with green `🐂` (right position) and orange `🐮` (wrong position) indicators, plus barnyard commentary.
   * **Headline Overlay**: *"Corral the Clues, Hunt the Bulls"*
   * **Subtitle**: *"Smart deduction journal keeps every guess in view."*

3. **Slide 3: "World Grazing Pastures" (Theming)**
   * **Subject**: Hero stage showcasing the theme switcher and atmospheric palettes.
   * **Visuals**: Split montage or preview of **Classic Barnyard**, **Swiss Alps**, **Texas Outback**, and **Midnight Pasture**.
   * **Headline Overlay**: *"6 Distinct Grazing Atmospheres"*
   * **Subtitle**: *"Customize your board with handcrafted world themes."*

4. **Slide 4: "Victory Celebration & Pure Privacy"**
   * **Subject**: The celebratory win modal with trophy confetti and revealed code.
   * **Visuals**: Congratulations modal, stats pill, and offline badge.
   * **Headline Overlay**: *"100% Offline Logic Puzzle"*
   * **Subtitle**: *"Zero ads. Zero tracking. Just pure deductive fun."*

---

## 3. App Store Connect Metadata Ready-to-Copy

### Basic Information
* **App Name**: `Cows and Bulls: Codebreaker` *(28 / 30 chars)*
* **Subtitle**: `Classic 4-Digit Number Puzzle` *(29 / 30 chars)*
* **Primary Category**: Games $\to$ Puzzle
* **Secondary Category**: Games $\to$ Board (or Family)
* **Age Rating**: **4+** (Select "None" for violence, adult content, gambling, and medical content).

### Search Keywords *(98 / 100 characters)*
```text
cows,bulls,codebreaker,mastermind,puzzle,logic,deduction,numbers,brain,offline,cipher,math,secret
```

### Promotional Text *(170 chars max)*
```text
Can you outsmart the herd? Guess the secret 4-digit code using Bulls & Cows deduction clues across 6 world pasture themes!
```

### Full Description
```markdown
Step into the pasture and test your deductive reasoning in Cows and Bulls, the classic 4-digit code-breaking game reimagined with charm, responsive modern design, and playful farm personality!

THE OBJECTIVE
The computer has locked in a secret 4-digit code where every digit is unique (from 0 to 9). You have 20 attempts to crack the code. After every guess, your herd gives you clues:
• 🐂 BULLS: A digit is correct and in the EXACT right spot!
• 🐮 COWS: A digit is in the secret code, but in the WRONG spot!

KEY FEATURES
• 🌾 Two-Phase Progressive Layout: An atmospheric Hero Stage welcomes you before guess #1, smoothly transforming into a focused deduction desk.
• ⌨️ iPad-Style Collapsible Keypad: Dock the keypad anytime to inspect up to 10 previous attempts simultaneously.
• 🚜 6 World Grazing Pastures: Play in Original iOS, sunny Classic Barnyard, crisp Swiss Alps, lush New Zealand, sun-drenched Texas Outback, or dark OLED Midnight.
• 💬 Farm Rumors & Comic Banter: Tap the header title or hero card to hear fresh, witty banter between Cow and Bull.
• 🔒 100% Offline & Private: No accounts, no ads, no in-app purchases, and zero data tracking. Your deductions remain on your device.

Grab the bull by the horns and crack the code!
```

---

## 4. Legal & Web URLs

Apple mandates two live web URLs:

### 1. Privacy Policy URL
Host a simple markdown or HTML page (e.g. GitHub Pages or GitHub Gist) containing:
> **Privacy Policy for Cows & Bulls**  
> *Last updated: 2026-11-13*  
> Cows & Bulls is built with a privacy-first, offline architecture. The application does not collect, store, transmit, or share any personal information, device identifiers, analytics, or user telemetry. All game state and preferences are stored exclusively on your device. The app requires no internet access to function.

### 2. Support URL
* Can be the public GitHub repository URL (`https://github.com/foldingpaper/cowsAndBulls`) or an issues page.

---

## 5. Xcode Signing & Archiving Guide

### Step 1: Configure Signing in Xcode
1. Open the project: `open iOS/CowsAndBulls.xcodeproj`
2. Select the top-level **CowsAndBulls** project in the Project Navigator.
3. Select the **CowsAndBulls** target $\to$ **Signing & Capabilities**.
4. Check **Automatically manage signing**.
5. Select your active **Team** (associated with your Apple Developer Program).
6. Verify the **Bundle Identifier** (e.g., `com.cowsandbulls.game` or your team domain `com.<yourname>.cowsandbulls`).

### Step 2: Build & Archive
1. In Xcode's destination dropdown (next to the Play/Stop button), select **Any iOS Device (arm64)**.
2. From the menu bar, choose **Product > Archive**.
3. When the build completes, the **Organizer** window will appear.
4. Click **Distribute App** $\to$ select **App Store Connect** $\to$ click **Upload**.
5. Leave standard options checked (Upload app symbols, manage signing) and proceed.

### Step 3: Finalize in App Store Connect
1. Visit [appstoreconnect.apple.com](https://appstoreconnect.apple.com) $\to$ **My Apps** $\to$ click **+ (New App)**.
2. Select **iOS**, enter your App Name, Primary Language, and choose your Bundle ID.
3. Upload your 6.7" iPhone screenshots under **App Previews and Screenshots**.
4. Paste the description, keywords, URLs, and age rating questionnaire.
5. In the **Build** section, link the build uploaded from Xcode.
6. Click **Save** and then **Submit for Review**.
