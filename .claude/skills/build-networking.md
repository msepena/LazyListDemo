---
description: Build the PhotosNetworking Swift package on iPhone 17 simulator. Use after editing files under Packages/PhotosNetworking/.
---

# /build-networking

Builds `PhotosNetworking` against the iOS Simulator. Pulls in `PhotoModels` and `ImageCacheKit` transitively.

```bash
xcodebuild -workspace LazyListDemo.xcworkspace \
  -scheme PhotosNetworking \
  -destination 'platform=iOS Simulator,name=iPhone 17' \
  build
```

Report only errors and warnings; on success report `BUILD SUCCEEDED`.
