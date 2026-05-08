---
description: Build the PhotosFeature Swift package on iPhone 17 simulator. Use after editing files under Packages/PhotosFeature/.
---

# /build-feature

Builds `PhotosFeature` against the iOS Simulator. Pulls in `PhotoModels` and `PhotosNetworking` (and transitively `ImageCacheKit`).

```bash
xcodebuild -workspace LazyListDemo.xcworkspace \
  -scheme PhotosFeature \
  -destination 'platform=iOS Simulator,name=iPhone 17' \
  build
```

Report only errors and warnings; on success report `BUILD SUCCEEDED`.
