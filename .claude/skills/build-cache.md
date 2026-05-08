---
description: Build the ImageCacheKit Swift package on iPhone 17 simulator. Use after editing files under Packages/ImageCacheKit/.
---

# /build-cache

Builds `ImageCacheKit` against the iOS Simulator (UIKit module — host-platform `swift build` won't work).

```bash
xcodebuild -workspace LazyListDemo.xcworkspace \
  -scheme ImageCacheKit \
  -destination 'platform=iOS Simulator,name=iPhone 17' \
  build
```

Report only errors and warnings; on success report `BUILD SUCCEEDED`.
