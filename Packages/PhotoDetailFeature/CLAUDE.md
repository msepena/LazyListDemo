# PhotoDetailFeature

Per-photo detail screen for the LazyListDemo app.

## Rules for this module

- **MainActor by default.** `Package.swift` sets
  `swiftSettings: [.defaultIsolation(MainActor.self)]`. Don't add
  `@MainActor` decorations — they're redundant here.
- **Stateless `PhotoDetailView`.** No view model — content is fully derived
  from the input `Photo`. Add a VM only if per-photo loading (EXIF,
  comments, etc.) is introduced later.
- **Use `RemoteImageView` from `ImageUI`.** Don't duplicate the
  image-loading view; both list and detail share the same caching path
  through that shared module. This module must not depend on
  `PhotosFeature` — sibling feature modules should not depend on each
  other.

## Dependencies

- `PhotoModels`
- `ImageUI`

## Public surface

- `PhotoDetailView`: detail page (large image, author, dimensions, source link).

## Tests

`Tests/PhotoDetailFeatureTests/` uses **Swift Testing**. View tests should
annotate `@MainActor` (the test target doesn't inherit the module's default
isolation).
