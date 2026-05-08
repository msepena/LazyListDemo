# PhotoModels

Pure data layer for the LazyListDemo app. Contains the `Photo` struct that maps the
Picsum `/v2/list` JSON.

## Rules for this module

- **Foundation only.** No `UIKit`, `SwiftUI`, or platform imports.
- **Sendable + Codable + Identifiable.** All public types are immutable value types
  with `let` properties.
- **No business logic.** Helpers limited to URL formatting / derived values
  (e.g. `thumbnailURL(size:)`).
- **No isolation default.** This package leaves Swift's nonisolated default in
  place — types here must be safe to use from any context.

## Public surface

- `Photo` (struct): Picsum photo metadata.
- `Photo.thumbnailURL(size:)`: builds a `https://picsum.photos/id/<id>/<size>/<size>`
  URL for list-row thumbnails (the raw `download_url` is full resolution).

## Tests

`Tests/PhotoModelsTests/` uses **Swift Testing** (`import Testing`, `@Test`,
`#expect`). No XCTest. Run via `swift test --package-path Packages/PhotoModels`
or `/test-models`.
