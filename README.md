# Life XP – Your Life Checklist & Glow-Up Companion

Life XP is an iOS app (built with SwiftUI, currently prototyped in Swift Playgrounds) that turns your life into a kind of game – without toxic hustle, but with honest, concrete steps.

You track progress across four core dimensions:

- ❤️ **Love**
- 💸 **Money**
- 🧠 **Mind**
- 🌍 **Adventure**

You check off real-life tasks, earn XP, build streaks and see how “balanced” your life currently is.

---

## ✨ Features

### 🎮 Life as a (healthy) game

- **Life Score**  
  See how much of your current checklist you’ve already touched – as a global percentage.
- **XP System**  
  Each task gives XP. More XP = further into your Life XP “level”.
- **Dimensions**  
  Every task is tagged with one or more dimensions: Love / Money / Mind / Adventure.
- **Streaks**  
  Tracks how many days in a row you did *something* for your life. No punishment if you break it, just gentle encouragement.

---

### 📦 Life Packs – themed checklists

Curated “packs” for common life situations:

- **Relationship Core**  
  Talks about values & future, money conversations, conflict clean-up, surviving your first trip together, etc.
- **Glow-Up Era (PRO)**  
  Routine, boundaries, friend audit, style refresh, doing hard things even when you don’t feel like it.
- **Breakup & Healing (PRO)**  
  No-contact, learning from your relationship, solo “ex-date” experiences.
- **Money & Career**  
  Emergency fund, honest look at debt, asking for a raise, CV & LinkedIn clean-up.
- **Adulting 101**  
  Insurance, admin system, general health check.
- **Adventure & Memories**  
  Solo trip, legendary nights, “I was scared but did it anyway”.

Each item has:

- Title  
- Description  
- XP value  
- Dimensions (Love / Money / Mind / Adventure)  
- Optional **PRO** flag for premium content

---

### 🗺 Journeys – not just lists, but routes

Journeys are multi-day routes that combine tasks from different packs into one coherent flow. Examples:

- **Breakup → Glow-Up (30 days)**  
- **Get Your Sh\*t Together (7 days)**  
- **Soft Life Starter (14 days)**  

Per journey you get:

- % completion  
- Steps completed vs total  
- Focus dimensions (e.g. Mind + Love)

---

### 🏆 Badges, streaks & weekend challenges

- **Streak tracking**  
  - Current streak (days in a row you completed at least one task)  
  - Best streak so far  
- **Badges**  
  Unlock badges for:
  - Reaching certain XP thresholds  
  - Hitting streak milestones  
  - Focusing on specific dimensions (e.g. Love / Money)  
- **Weekend Challenge generator**  
  Let the app create a mini-challenge based on your mood:
  - Solo  
  - With friends  
  - With your partner

The challenge reuses existing tasks to build a fun, shareable checklist for the weekend.

---

### 📊 Stats & share cards

The **Stats** tab shows:

- Global Life Score (%)
- Total XP
- XP per dimension (with progress bars)
- Current streak & best streak
- Unlocked badges

There’s also a **share card** (9:16 aspect ratio) designed for TikTok/Instagram/Snapchat stories:

- Life Score & total XP  
- Bars for each dimension  
- Small CTA like: “Search in the App Store: Life XP”  

You simply take a screenshot and post it.

---

### 🧠 Tone, onboarding & safe mode

The onboarding flow asks:

- What your current main focus is (Love / Money / Mind / Adventure)
- How overwhelmed you feel (1–5)
- Which tone you prefer:

  - **Soft & gentle** – calm, kind, more comforting texts  
  - **Real talk** – more direct, slightly savage but respectful

There’s also:

- **Safe mode**  
  Hides heavier / more sensitive tasks (e.g. certain breakup/healing steps) if you’re not in the space for that.

---

### 💸 PRO content (dev placeholder for IAP)

Some packs/items are marked as **PRO**. In the current prototype:

- There is a simple boolean `premiumUnlocked` flag in `AppModel`.
- The **Settings** screen contains a dev toggle:
  - Used to test how the UI behaves when PRO is unlocked.
  - In a real release this would be replaced by StoreKit / in-app purchases.

---

## 🧱 Tech Stack

- **Language:** Swift
- **UI:** SwiftUI
- **Architecture:**
  - `ObservableObject` (`AppModel`) as central state
  - `@StateObject` at root, injected into views via `@EnvironmentObject`
- **Persistence:**
  - `UserDefaults` for:
    - Completed item IDs
    - Tone mode
    - Safe mode
    - Streak data (current streak, best streak, last active day)
- **No backend** (yet):
  - All data is local sample data in code
  - No authentication / accounts / sync

---

## 🗂 Project structure (high level)

Rough structure of the Swift files:

- `AppModel.swift`  
  - Core models (`LifeDimension`, `ChecklistItem`, `CategoryPack`, `Journey`, `Badge`)  
  - Sample data (`SampleData`)  
  - `AppModel` state:
    - Packs & journeys
    - Completed items
    - Streak logic
    - Tone mode & safe mode
    - Badge calculation
    - Suggestions & coach messages

- `ContentView.swift`  
  - Root `TabView` with:
    - Home
    - Journeys
    - Packs
    - Stats
    - Settings
  - Fullscreen onboarding (`OnboardingView`)

- `OnboardingView.swift`  
  - Multi-step intro: welcome, focus, overwhelm, tone

- `HomeView.swift`  
  - Life Score card (with streaks & coach text)  
  - Daily suggestion card  
  - Dimension balance bars  
  - Quick links to Journeys & Weekend Challenge

- `JourneysView.swift`  
  - List of journeys  
  - Journey detail  
  - Weekend Challenge generator  
  - Badges view

- `PacksView.swift`  
  - Pack list  
  - Pack detail  
  - Checklist rows with PRO gating alerts

- `StatsAndShareViews.swift`  
  - Stats overview (global, dimension cards, badges snippet)  
  - Share preview + share story card

- `SettingsView.swift`  
  - Tone mode  
  - Safe mode  
  - Dev toggle to unlock PRO

---

## 🚀 Getting started

### Requirements

- Xcode (for Mac) **or** Swift Playgrounds (iPad / Mac)
- iOS 17+ target (adjust as needed in Xcode)

### Running in Xcode

1. Clone the repo:

   ```bash
   git clone https://github.com/<your-username>/life-xp-ios.git
   cd life-xp-ios
   ```

2. Open the project in Xcode (`.xcodeproj` or `.swiftpm`, depending on how you structure it).
3. Select an iOS simulator (or a physical device).
4. Build & run.

### Running from Swift Playgrounds on iPad

There are a couple of ways:

- **Via Working Copy + Files (recommended)**  
  - Clone the repo into **Working Copy**.  
  - Link the repo as a Swift Playgrounds document (`.swiftpm`).  
  - Open that document in **Swift Playgrounds**.  
  - Use Working Copy to pull/push changes (perfect for AI/Codex refactors via GitHub).

- **Or manual import**  
  - Zip the sources from GitHub,  
  - Import them into a new Swift Playgrounds app project,  
  - Replace the default `ContentView` & app files with the ones from this repo.

---

## 🧭 Roadmap / Ideas

Some potential future directions:

- ✅ Refine packs, wording and flows based on real user feedback  
- 🔜 Real **PRO unlock** using StoreKit (one-time purchase / subscription)  
- 🔜 iCloud / CloudKit sync (keep XP & progress across devices)  
- 🔜 Optional account system for social features  
- 🔜 More journeys (e.g. student life, moving out, career pivot)  
- 🔜 Theming system (neon, pastel, ultra-minimal, etc.)  
- 🔜 Anonymous global stats (e.g. “X% of users had a solo trip”)  
- 🔜 More shareable cards (badges, journeys, weekly recaps)

---

## ⚠️ Disclaimer

Life XP is **not** therapy, financial advice, or a replacement for professional help.  
It’s a playful, honest companion that gives you concrete steps and a bit of structure in chaos.

---

## 🤝 Contributing

Feedback, ideas or issues are welcome:

- Open an issue on GitHub
- Suggest new pack ideas, journeys, badges or copy improvements
- PRs for refactors, better architecture or tests are also appreciated

---

## 📜 License

Choose your license (MIT / Apache 2.0 / proprietary) and mention it here.
