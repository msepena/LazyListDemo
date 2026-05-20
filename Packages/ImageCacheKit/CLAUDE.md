# ImageCacheKit

Thread-safe in-memory image cache backed by `NSCache<NSURL, UIImage>`. Used by
`PhotosNetworking.ImageLoader` to memoize decoded thumbnails.

## Rules for this module

- **`UIKit` only.** No `SwiftUI`, no networking, no model types from PhotoModels.
- **Synchronous API.** `NSCache` is documented thread-safe, so the wrapper is a
  plain `final class @unchecked Sendable` — callable from any actor without `await`.
- **Cost = `width × height × 4` bytes** (RGBA estimate). Don't change the cost
  function without re-tuning `totalCostLimit` (currently 64 MB / 200 entries).
- **No isolation default.** Module leaves Swift's nonisolated default in place
  so the cache is reachable from `MainActor` UI code and the `ImageLoader` actor
  alike.

## Public surface

- `ImageCache` (class): `image(for:)`, `insert(_:for:)`, `removeImage(for:)`, `removeAll()`.
- `ImageCache.shared`: process-wide singleton used by ImageLoader.

## Tests

`Tests/ImageCacheKitTests/` uses **Swift Testing**. iOS-platform target — needs
the simulator runtime, so use `/test-cache` (xcodebuild) rather than `swift test`.
