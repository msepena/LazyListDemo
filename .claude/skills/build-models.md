---
description: Build the PhotoModels Swift package on the host platform (no iOS sim needed). Use after editing files under Packages/PhotoModels/.
---

# /build-models

Builds `PhotoModels` via plain `swift build` — fast feedback, no simulator required (the module is Foundation-only).

```bash
swift build --package-path Packages/PhotoModels
```

Report only errors and warnings; on success report `BUILD SUCCEEDED`.
