---
description: Run unit tests for the PhotoDetailFeature Swift package on iPhone 17 simulator. Use after editing files under Packages/PhotoDetailFeature/.
---

# /test-detail

Runs `PhotoDetailFeatureTests` on the iOS Simulator.

```bash
xcodebuild -workspace LazyListDemo.xcworkspace \
  -scheme PhotoDetailFeature \
  -destination 'platform=iOS Simulator,name=iPhone 17' \
  test
```

Report only failures and the final pass/fail summary.
