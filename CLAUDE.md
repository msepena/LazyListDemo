# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project

SwiftUI iOS app named **LazyListDemo** (bundle id `com.test.LazyListDemo`). Displays the Picsum `/v2/list` photo feed in a lazy SwiftUI `List` with NSCache-backed thumbnail caching, in-flight request dedup, and bounded prefetch.

- iOS deployment target: **26.4**
- Swift language mode: **6.0** (`SWIFT_VERSION = 6.0`)
- Approachable Concurrency enabled on the App target (`SWIFT_APPROACHABLE_CONCURRENCY = YES`, `SWIFT_DEFAULT_ACTOR_ISOLATION = MainActor`)
- Targeted device family: universal (iPhone + iPad)
- Workspace: `LazyListDemo.xcworkspace` (contains `LazyListDemo.xcodeproj` + 5 local Swift packages)

## Modular layout

The code is split across **five local Swift packages** under `Packages/`, plus the App target. Each package has its own `Package.swift`, isolated tests, and a module-scoped `CLAUDE.md` that's auto-loaded when working on that module's files.

```
App (LazyListDemo.xcodeproj target — LazyListDemoApp + ContentView + AppCoordinator)
 ├─ PhotosFeature       (list — VMs + Views, MainActor by default)
 │   ├─ PhotoModels     (Photo struct — Foundation only)
 │   └─ PhotosNetworking (PhotoService + ImageLoader actor)
 │       ├─ PhotoModels
 │       └─ ImageCacheKit (NSCache wrapper)
 └─ PhotoDetailFeature  (detail — MainActor by default)
     ├─ PhotoModels
     └─ PhotosFeature   (reuses RemoteImageView)
```

Per-module guidance:
- `Packages/PhotoModels/CLAUDE.md`
- `Packages/ImageCacheKit/CLAUDE.md`
- `Packages/PhotosNetworking/CLAUDE.md`
- `Packages/PhotosFeature/CLAUDE.md`
- `Packages/PhotoDetailFeature/CLAUDE.md`

`PhotosFeature` and `PhotoDetailFeature` opt into `defaultIsolation(MainActor.self)` (set in their `Package.swift`). The leaf modules stay nonisolated by default — that's why `ImageCache` doesn't need a `nonisolated` keyword and `ImageLoader`'s `actor` isolation is explicit rather than an opt-out.

## Build and test

All commands run from the repo root. Substitute a real device name from `xcrun simctl list devices available` if the example destination is unavailable.

```bash
# Build the whole app (workspace builds all 4 packages + App in dependency order)
xcodebuild -workspace LazyListDemo.xcworkspace -scheme LazyListDemo \
  -destination 'platform=iOS Simulator,name=iPhone 17' build

# Run app + integration tests
xcodebuild -workspace LazyListDemo.xcworkspace -scheme LazyListDemo \
  -destination 'platform=iOS Simulator,name=iPhone 17' test

# Build/test a specific module
xcodebuild -workspace LazyListDemo.xcworkspace -scheme PhotosFeature \
  -destination 'platform=iOS Simulator,name=iPhone 17' test
# (replace PhotosFeature with PhotoModels, ImageCacheKit, or PhotosNetworking)

# PhotoModels is platform-agnostic — fastest feedback via host SwiftPM:
swift test --package-path Packages/PhotoModels
```

There are also project-scoped slash commands wrapping these — see `.claude/skills/`:
`/build-models`, `/test-models`, `/build-cache`, `/test-cache`, `/build-networking`, `/test-networking`, `/build-feature`, `/test-feature`.

## Test framework split

- **Module tests** (`Packages/<Module>/Tests/`) — Swift Testing (`import Testing`, `@Test`, `#expect`). PhotosFeature tests run on `@MainActor` since the test target doesn't inherit the module's default isolation.
- **`LazyListDemoTests/`** — Swift Testing, hosted by the App target.
- **`LazyListDemoUITests/`** — XCTest (`XCTestCase`, `XCUIApplication`). UI tests launch the app via `XCUIApplication().launch()` and run on `@MainActor`. `LazyListDemoUITestsLaunchTests` exists for launch-performance measurements.
