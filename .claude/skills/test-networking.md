---
description: Run unit tests for the PhotosNetworking Swift package on iPhone 17 simulator. Use after editing files under Packages/PhotosNetworking/.
---

# /test-networking

Runs `PhotosNetworkingTests` on the iOS Simulator.

```bash
xcodebuild -workspace LazyListDemo.xcworkspace \
  -scheme PhotosNetworking \
  -destination 'platform=iOS Simulator,name=iPhone 17' \
  test
```

Report only failures and the final pass/fail summary.
