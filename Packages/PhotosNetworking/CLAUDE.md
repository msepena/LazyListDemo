# PhotosNetworking

Networking + image-loading layer. Wraps `URLSession` with two responsibilities:

1. **`PhotoService`** — fetches the `/v2/list` JSON.
2. **`ImageLoader`** — actor that loads thumbnails through `ImageCache`, dedupes
   in-flight requests, and offers a bounded `withTaskGroup` prefetch.

## Rules for this module

- **No `SwiftUI`.** This module is consumed by both views and tests; UI deps belong
  in `PhotosFeature`.
- **`PhotoService.fetchPhotos()` is `@concurrent`** so it runs on a background
  executor regardless of caller isolation. Don't drop that attribute.
- **`ImageLoader` is an `actor`.** Shared mutable state (`inFlight: [URL: Task]`)
  must stay actor-isolated — never expose it via `nonisolated`.
- **Bounded prefetch.** `prefetch(_:maxConcurrent:)` keeps a steady window of
  N concurrent downloads via the prime + drain pattern. Default 6 (matches
  typical browser per-host limits). Don't replace with naive
  `for url in urls { group.addTask { ... } }`.
- **No isolation default.** Module is nonisolated by default; the actor and
  `@concurrent` opt-ins are explicit.

## Dependencies

- `PhotoModels` (for `Photo`)
- `ImageCacheKit` (for `ImageCache.shared`)

## Public surface

- `PhotoService` (struct, `Sendable`): `fetchPhotos()`.
- `ImageLoader` (actor): `image(for:)`, `prefetch(_:maxConcurrent:)`.
- `ImageLoader.shared`: the singleton consumed by views.

## Tests

`Tests/PhotosNetworkingTests/` uses **Swift Testing**. Network-touching tests
should stub `URLSession` via `URLProtocol` rather than hitting picsum.photos.
Run via `/test-networking`.
