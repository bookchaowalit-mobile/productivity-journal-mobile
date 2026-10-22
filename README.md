# MindSpace — Journal & Meditation (Mobile)

SwiftUI app for journaling and guided breathing: write mood-tagged journal
entries, run a meditation countdown, and see streaks and mood statistics.

Part of [Chaowalit Greepoke](https://bookchaowalit.com)'s 101 Portfolio Projects.

> **Naming:** the repo is `productivity-journal-mobile`; the app in it is
> **MindSpace** (journal + meditation). It is its own app, not a copy of the
> SwiftUI template. What exists today: [PRODUCT.md](PRODUCT.md).

## Structure

- `Sources/MindSpaceCore` — Foundation-only domain logic, unit-tested in
  `Tests/MindSpaceCoreTests` (XCTest):
  - `JournalEntry` / `Mood` (Codable), tag parsing (trim, `#`-strip, de-dup)
  - streak calculation (today or yesterday counts, time-zone aware via `Calendar`)
  - mood counts, shares and average, search (newest first)
  - `MeditationSession`: pure countdown state machine (select, start, pause,
    resume, reset, tick, completion stats, progress, `MM:SS`)
- `Sources/MindSpace` — SwiftUI executable target (Breathe / Journal / Stats
  tabs). `JournalStore` persists entries in `UserDefaults`; `MeditationTimer`
  drives `MeditationSession` with a one-second Combine timer.

The code is built and tested only in CI (no local Swift toolchain was used to
write it). See [docs/UPGRADE-PLAN.md](docs/UPGRADE-PLAN.md).

## Tech Stack

- **UI:** SwiftUI (iOS 17+; macOS 14+ so SwiftPM can build on a Mac)
- **Language:** Swift 5.10 (`swift-tools-version: 5.10`)
- **Tests:** XCTest via SwiftPM

## Getting Started

```bash
swift build
swift test          # runs MindSpaceCoreTests
open Package.swift  # opens in Xcode 15+
```

CI (`.github/workflows/build.yml`, macOS 14 with Xcode 15.4 / Swift 5.10) runs
`swift build` and `swift test` fail-closed, plus the shared `security.yml` scans
(gitleaks, Semgrep, OSV-Scanner, Trivy) from `platform-ci-workflows` v1.1.1.

## Related

- **Frontend:** [bookchaowalit-website/journal-frontend](https://github.com/bookchaowalit-website/bookchaowalit-journal-frontend)
- **Portfolio:** [bookchaowalit.com](https://bookchaowalit.com)

## License

MIT
