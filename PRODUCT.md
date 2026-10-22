# MindSpace (repo `productivity-journal-mobile`) — product notes

Describes only what exists in this repository today (2026-10-22).

## Naming

The repository is called `productivity-journal-mobile`, but the code is a
journal **and** meditation app named **MindSpace** (`MindSpace` executable
target, `MindSpaceCore` library). It is not one of the name-substituted
SwiftUI template copies; its lifecycle in the portfolio is not decided yet.

## What it is

A SwiftUI app (iOS 17+, macOS 14+ so SwiftPM can build it on a Mac) with
three tabs, dark colour scheme:

- **Breathe** (`MeditationView`): pick 1, 3, 5, 10, 15, 20 or 30 minutes,
  start / pause / resume / reset a countdown with a progress ring.
- **Journal** (`JournalView`): list of entries (newest first), empty state,
  "+" sheet with title, text, mood picker (5 moods with emoji) and
  comma-separated tags; swipe to delete.
- **Stats** (`StatsView`): completed meditation sessions and minutes, journal
  streak in days (today or yesterday keeps the streak alive), mood
  distribution, total entries.

## Data

- Journal entries are stored on the device in `UserDefaults` as JSON.
- Meditation stats live in memory and reset when the app restarts.
- No account, no backend, no network calls, no analytics.

## Domain logic (`Sources/MindSpaceCore`, Foundation only)

Tag parsing, streak calculation, mood counts / share / average, search
(newest first; not wired into the UI yet), and the `MeditationSession`
countdown state machine. Covered by XCTest in `Tests/MindSpaceCoreTests`
(3 files: `JournalStatsTests.swift`, `MeditationSessionTests.swift`,
`MoodAndEntryTests.swift`).

## Build and distribution status

- CI (macOS 14, Xcode 15.4 / Swift 5.10) runs `swift build` and `swift test`.
- There is no Xcode project, no iOS simulator build in CI, no signing, no
  TestFlight or App Store listing.

## Not built yet

See [docs/UPGRADE-PLAN.md](docs/UPGRADE-PLAN.md): iOS simulator build in CI,
persisted meditation stats, editing entries, search UI, accessibility labels.
