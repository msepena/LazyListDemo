# PhotosFeature

UI layer of the LazyListDemo app. Contains the view model, list/row/image
SwiftUI views, and the public `PhotosListView` entry point that the App target
embeds.

## Rules for this module

- **MainActor by default.** `Package.swift` sets
  `swiftSettings: [.defaultIsolation(MainActor.self)]`, so views and view
  models are MainActor without explicit annotation. Don't add `@MainActor`
  decorations — they're redundant here.
- **`@Observable` view models.** No `ObservableObject`, no `@Published`. Use the
  `Observation` macro and reference the VM via `@State` from the consuming view
  (it owns the lifecycle, even though the type is a class).
- **Lazy image loading via `task(id:)`.** `RemoteImageView` uses
  `.task(id: url) { ... }` so SwiftUI auto-cancels the load when a row
  recycles. Don't use `.onAppear` + manual `Task` here.
- **Public entry point = `PhotosListView`.** Anything else exposed publicly
  should be reviewed; the App target should not need to construct VMs or rows
  directly.

## Dependencies

- `PhotoModels`
- `PhotosNetworking`

(`ImageCacheKit` is intentionally a transitive dep through `PhotosNetworking` —
this module shouldn't import it directly.)

## Public surface

- `PhotosListView` (struct): photo list with pull-to-refresh and error states.
  Emits row taps via the `onSelectPhoto: (Photo) -> Void` closure; the
  embedding view is responsible for the `NavigationStack`.
- `PhotoDetailView` (struct): per-photo detail page (large image, author,
  dimensions, source link). Stateless — takes a `Photo`.
- `PhotoRow`, `RemoteImageView`, `PhotosViewModel`: also public so they can be
  composed or tested, but `PhotosListView` is the primary export.

## Tests

`Tests/PhotosFeatureTests/` uses **Swift Testing**. View-model tests should
annotate `@MainActor` (the test target doesn't inherit the module's default
isolation). Run via `/test-feature`.
