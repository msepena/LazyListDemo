# ImageUI

Shared SwiftUI image views for the LazyListDemo app. Sits between
`PhotosNetworking` and the feature modules so list and detail screens
can render the same `ImageLoader`-backed view without depending on
each other.

## Rules for this module

- **MainActor by default.** `Package.swift` sets
  `swiftSettings: [.defaultIsolation(MainActor.self)]`. Don't add
  `@MainActor` decorations — they're redundant here.
- **Stateless input.** `RemoteImageView` takes a `URL?`, not a domain
  model — keep it that way so callers can compose it however they need.
- **Lazy load via `task(id:)`.** Don't switch to `onAppear` — SwiftUI's
  automatic cancellation on cell recycle is the whole point.

## Dependencies

- `PhotosNetworking` (for `ImageLoader.shared`)

## Public surface

- `RemoteImageView`: SwiftUI view that loads a URL through `ImageLoader.shared`.

## Tests

`Tests/ImageUITests/` uses **Swift Testing**. View tests should annotate
`@MainActor` (the test target doesn't inherit the module's default isolation).
