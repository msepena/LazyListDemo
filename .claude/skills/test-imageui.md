---
description: Run unit tests for the ImageUI Swift package on iPhone 17 simulator. Use after editing files under Packages/ImageUI/.
---

# /test-imageui

Runs `ImageUITests` on the iOS Simulator.

```bash
xcodebuild -workspace LazyListDemo.xcworkspace \
  -scheme ImageUI \
  -destination 'platform=iOS Simulator,name=iPhone 17' \
  test
```

Report only failures and the final pass/fail summary.
