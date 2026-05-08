---
description: Build the PhotoDetailFeature Swift package on iPhone 17 simulator. Use after editing files under Packages/PhotoDetailFeature/.
---

# /build-detail

Builds `PhotoDetailFeature` against the iOS Simulator. Pulls in `PhotoModels` and `ImageUI` (and transitively `PhotosNetworking`, `ImageCacheKit`).

```bash
xcodebuild -workspace LazyListDemo.xcworkspace \
  -scheme PhotoDetailFeature \
  -destination 'platform=iOS Simulator,name=iPhone 17' \
  build
```

Report only errors and warnings; on success report `BUILD SUCCEEDED`.
