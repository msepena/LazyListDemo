# LazyListDemo — Consolidated Code Review

**Date:** 2026-05-19
**Branch:** main
**Reviewers (parallel, read-only):** SwiftUI/WWDC, Swift Concurrency, HIG & Accessibility, Swift API Design.

Per-reviewer reports in this directory:

- `swiftui-wwdc.md`
- `swift-concurrency.md`
- `hig-accessibility.md`
- `swift-api-design.md`

No code was changed.

---

## Headline verdict

The architecture is sound — module boundaries match `CLAUDE.md`, Swift 6 isolation is correct, no data-race risks, no public-surface bugs that silently injure callers. The findings cluster into three themes:

1. **Accessibility is the largest gap.** Three a11y blockers in `RemoteImageView` / `PhotoRow` will leave VoiceOver users with silence or misleading announcements.
2. **A content bug in the detail screen** crops every non-square photo (the screen that exists to show the whole picture).
3. **Lifecycle/cancellation hygiene** around `PhotosViewModel.load()` — an orphan prefetch `Task` and `CancellationError` mis-routed into `.failed`.

Below is the cross-cutting issue inventory. Severity headings reflect the highest-severity bucket the issue landed in across reviewers.

---

## Critical

| # | Area | Where | Issue |
|---|------|-------|-------|
| C1 | A11y | `Packages/ImageUI/Sources/ImageUI/RemoteImageView.swift:13-29` | No accessibility label / `accessibilityHidden`. VoiceOver hears silence or a generic "in progress." |
| C2 | A11y | `Packages/PhotosFeature/Sources/PhotosFeature/PhotoRow.swift:12-28` | Row not combined into one a11y element — VoiceOver lands on up to three separate focuses per row. |
| C3 | A11y | `PhotoRow.swift:22`, `PhotoDetailView.swift:26` | `"\(width)×\(height)"` uses U+00D7 with no `accessibilityLabel`; pronunciation varies / may be silent. |

---

## Important

| # | Area | Where | Issue |
|---|------|-------|-------|
| I1 | SwiftUI / content bug | `Packages/PhotoDetailFeature/Sources/PhotoDetailFeature/PhotoDetailView.swift:15-21` (+ `RemoteImageView.swift:17`, `Photo.swift:32-34`) | Detail view requests a **square** 800×800 image but forces the photo's real aspect ratio while `RemoteImageView` uses `.scaledToFill()` — every non-square photo is cropped on the screen meant to show the whole thing. |
| I2 | Concurrency (correctness) | `Packages/PhotosFeature/Sources/PhotosFeature/PhotosViewModel.swift:29` | Orphan `Task { await ImageLoader.shared.prefetch(…) }` — no owner, no cancellation, stacks on `.refreshable`. |
| I3 | Concurrency (correctness) | `PhotosViewModel.swift:22-33` | Generic `catch` reduces `CancellationError` / `URLError(.cancelled)` to `.failed("cancelled")`. View dismissal / refresh shows a phantom error. |
| I4 | API design | `Packages/PhotoModels/Sources/PhotoModels/Photo.swift:8-9` | `url` and `downloadURL` are `String`, forcing every call site through `URL(string:)` (see `PhotoDetailView.swift:29`). Use `URL`. |
| I5 | API design | `PhotosViewModel.swift:12, :31` | `LoadState.failed(String)` smuggles an error as a localised string — kills branching, fixes locale at fail time, drops the error chain. Carry `Error` (or a typed enum). |
| I6 | API design | `Packages/PhotosNetworking/Sources/PhotosNetworking/PhotoService.swift:17` | `fetchPhotos()` repeats the type name. Prefer `list()` or `photos()`. |
| I7 | API surface | `PhotoRow.swift`, `PhotosViewModel.swift` | `PhotoRow` and `PhotosViewModel` are `public` against the module's own `CLAUDE.md` guidance — tests use `@testable import`; drop to `internal`. |
| I8 | API surface | `Packages/ImageCacheKit/Sources/ImageCacheKit/ImageCache.swift:13` and `Packages/PhotosNetworking/Sources/PhotosNetworking/ImageLoader.swift:5, :10` | Both expose `shared` **and** a parameter-less public `init()`. Either accept tuning/cache injection (`init(countLimit:totalCostLimit:)`, `init(cache: ImageCache = .shared)`) or make `init` private. |
| I9 | API design | `ImageCache.swift:24` | `remove(for: url)` reads "remove for url" — noun missing. Rename `removeImage(for:)` (or mirror `Dictionary.removeValue(forKey:)`). |
| I10 | SwiftUI / HIG | `Packages/PhotosFeature/Sources/PhotosFeature/PhotosListView.swift:28-31` + `LazyListDemo/RootView.swift:10-12` | Tap-callback `Button` instead of `NavigationLink(value: photo)`. Loses chevron, system row highlight, "link" a11y trait. Switch to value-driven nav + `.navigationDestination(for: Photo.self)`. |
| I11 | HIG / Dynamic Type | `PhotoDetailView.swift:13-36` | At AX5 the native-aspect image fills the viewport — text only appears after a scroll. Cap with `@ScaledMetric` max height, or use `ViewThatFits`. |
| I12 | HIG / iPad | `PhotoDetailView.swift:13-39` and `RootView.swift` | Universal target, but detail is one `VStack` with no readable-content-guide constraint and no `NavigationSplitView`. iPad gets edge-to-edge text well past the ~70-char recommendation. |
| I13 | HIG / a11y | `PhotosListView.swift:25-26` | `ProgressView()` with no label — VoiceOver hears generic "in progress"; sighted users see an unmoored spinner. Use `ProgressView("Loading photos…")`. |
| I14 | HIG | `PhotosListView.swift:33-39` | `wifi.slash` for **all** error categories — misleads on decode/500 failures. Branch on `URLError.notConnectedToInternet` vs. server vs. decode; add a retry via `ContentUnavailableView.actions`. |
| I15 | HIG / localization | Multiple files (titles, error copy, dimensions) | Bare string literals; `Text(...)` resolves against the **package's** bundle, not the app's. Strings won't pick up future translations without `bundle: .module` (and `xcstrings` per package). |
| I16 | HIG / RTL | `PhotoRow.swift:13`, `RemoteImageView.swift` | `Image(uiImage:)` doesn't set `.flipsForRightToLeftLayoutDirection(false)` — photographic content should not mirror under RTL layout. |

---

## Should fix / minor

| # | Area | Where | Issue |
|---|------|-------|-------|
| S1 | Concurrency (perf trade-off) | `Packages/PhotosNetworking/Sources/PhotosNetworking/ImageLoader.swift:16-22` | `image(for:)` wraps the download in unstructured `Task { }`, so caller cancellation does **not** propagate. Defensible (cache warm-up), but worth a comment or a structured rewrite if scroll-tear-down bandwidth becomes a measured issue. |
| S2 | SwiftUI | `PhotosViewModel.swift:28-29` | Prefetch is a one-shot warmup of the first 12 thumbs. iOS 26 has `onScrollGeometryChange(for:of:action:)` / `scrollPosition(id:)` — a scroll-driven sliding window unlocks the loader plumbing already in place. |
| S3 | SwiftUI | `PhotoDetailView.swift:38` | `navigationBarTitleDisplayMode(.inline)` is pre-iOS 18; replace with `.toolbarTitleDisplayMode(.inline)` (or drop entirely — pushed destinations default to inline). |
| S4 | API | `Photo.swift:32-34` | `thumbnailURL(size:)` returns `URL?` that's never `nil` in practice — callers (`PhotoRow.swift:14`, `PhotoDetailView.swift:15`) propagate the optional then discard it. Return non-optional. |
| S5 | API | `PhotoService.swift:5-6` | `session` / `endpoint` are `public let`. Construction dependencies should be `private`. |
| S6 | HIG | `RemoteImageView.swift:20` | `Color.gray.opacity(0.15)` is not semantic — invisible in Dark Mode, low-contrast in Light. Use `Color(.secondarySystemFill)`. |
| S7 | HIG | `PhotoRow.swift:16`, `PhotoDetailView.swift:20` | Hardcoded corner radii (8, 12) — won't scale with image at AX5. Use `@ScaledMetric` thumb size, or `RoundedRectangle(cornerRadius: 8, style: .continuous)`. |
| S8 | HIG | `PhotoRow.swift:21` | `.headline` + `lineLimit(1)` truncates at AX5; consider relaxing to 2 lines at accessibility sizes. |
| S9 | HIG | `PhotoDetailView.swift:30` | `Link("View on Picsum", …)` lacks SF Symbol affordance and `accessibilityHint`. Use `Label("View on Picsum", systemImage: "arrow.up.right.square")`. |
| S10 | HIG | `PhotoDetailView.swift:37-39` | No trailing toolbar action (e.g. `ShareLink`). Standard expectation on photo detail screens. |

---

## Nits

- **API:** `Photo.CodingKeys` should be `private` (`Photo.swift:27`); single-letter `c` for cache factory closure (`ImageCache.swift:7`); `PhotosListView.onSelectPhoto` stored as `internal` despite the type being public (`PhotosListView.swift:6`); zero `///` doc comments on any public surface across the six packages.
- **Concurrency:** Document **why** `ImageCache: @unchecked Sendable` is safe (`ImageCache.swift:3`); `[weak self]` inside `ImageLoader`'s `withTaskGroup` is ceremony for a singleton (`ImageLoader.swift:37, :43`); `Task.checkCancellation()` could be inserted between download and decode for future scale (`PhotoService.swift:17-20`).
- **SwiftUI / HIG:** `RootView`'s `#Preview` runs the live `PhotosViewModel()` — inject a stub-seeded VM (`RootView.swift:23-25`); off-grid spacers (`2`, `12`, `4`) in `PhotoRow` (`PhotoRow.swift:13, 18, 27`); `LoadState` would benefit from `Equatable` for tests if kept public; `AppRoute` is correctly in the App target today but worth re-evaluating the moment a non-list screen needs to push detail.

---

## Cross-cutting confirmations (NOT issues)

These came up in more than one report and are explicitly *fine*:

- Module boundary graph in `CLAUDE.md` matches reality — `PhotoDetailFeature` does **not** import `PhotosFeature`, leaf modules import only what they need.
- `Photo` is `final Sendable` with explicit conformance — correct for a public payload in a nonisolated leaf module.
- `RemoteImageView` uses `.task(id: url)` for cell-recycle cancellation — modern and correct.
- `ImageLoader.inFlight` access is reentrancy-safe (read/write happen synchronously with no `await` between them; `defer { inFlight[url] = nil }` runs after `cache.insert`).
- No redundant `@MainActor` annotations inside the MainActor-default modules — matches Approachable Concurrency guidance.
- No `@Published` / `ObservableObject` / `NavigationView` / `NavigationLink(destination:)` leftovers anywhere.

---

## Suggested triage order (if changes are made later)

1. **C1–C3** (accessibility blockers) — small, mechanical, immediate win.
2. **I1** (detail crops content) — content-correctness bug, one-line fix in the URL helper.
3. **I2, I3** (cancellation lifecycle) — structure `prefetch` into `load()`; add a `catch is CancellationError` branch.
4. **I4, I5** (`URL` typing, `LoadState.failed(Error)`) — public-surface change but tiny radius; touches `Photo` + view-model only.
5. **I7, I8** (drop unwarranted `public`, fix `init` shape) — pure API hygiene.
6. Remainder (SwiftUI / HIG polish, iPad split view, localisation) can ship incrementally.

---

## Tally

- **3 critical** (all accessibility)
- **16 important** (1 content bug, 2 concurrency correctness, 6 API design, 7 HIG / a11y / Dynamic Type / iPad / localisation / RTL)
- **10 should-fix / minor**
- **~15 nits**

Reports in this directory contain the full per-reviewer detail, including WWDC anchors and suggested fixes.
