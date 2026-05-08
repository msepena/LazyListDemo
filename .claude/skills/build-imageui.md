---
description: Build the ImageUI Swift package on iPhone 17 simulator. Use after editing files under Packages/ImageUI/.
---

# /build-imageui

Builds `ImageUI` against the iOS Simulator. Pulls in `PhotosNetworking` (and transitively `PhotoModels`, `ImageCacheKit`).

```bash
xcodebuild -workspace LazyListDemo.xcworkspace \
  -scheme ImageUI \
  -destination 'platform=iOS Simulator,name=iPhone 17' \
  build
```

Report only errors and warnings; on success report `BUILD SUCCEEDED`.
