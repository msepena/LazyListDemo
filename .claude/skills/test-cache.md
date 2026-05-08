---
description: Run unit tests for the ImageCacheKit Swift package on iPhone 17 simulator. Use after editing files under Packages/ImageCacheKit/.
---

# /test-cache

Runs `ImageCacheKitTests` on the iOS Simulator.

```bash
xcodebuild -workspace LazyListDemo.xcworkspace \
  -scheme ImageCacheKit \
  -destination 'platform=iOS Simulator,name=iPhone 17' \
  test
```

Report only failures and the final pass/fail summary.
