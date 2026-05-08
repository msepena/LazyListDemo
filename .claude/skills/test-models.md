---
description: Run unit tests for the PhotoModels Swift package on the host platform. Use after editing files under Packages/PhotoModels/.
---

# /test-models

Runs `PhotoModelsTests` via plain `swift test` — no simulator required.

```bash
swift test --package-path Packages/PhotoModels
```

Report only failures and the final pass/fail summary.
