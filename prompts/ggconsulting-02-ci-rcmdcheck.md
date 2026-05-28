# Prompt 06: R-CMD-check CI workflow

## Context

`.github/workflows/` currently has only `pkgdown.yaml`. Before more code lands, add R-CMD-check on macOS/Linux/Windows so regressions surface on every PR. Cheap to set up, expensive to skip.

## Deliverables

1. **.github/workflows/R-CMD-check.yaml** — use the standard tidyverse template via `usethis::use_github_action("check-standard")` or copy from r-lib/actions. Matrix: macos-latest, windows-latest, ubuntu-latest (R release + R devel for ubuntu). On push to `main` and on all PRs.
2. **.github/workflows/test-coverage.yaml** — add via `usethis::use_github_action("test-coverage")`. Posts coverage to codecov.io (or just runs locally if you don't want to set up codecov).
3. **Update README.Rmd / README.md** — add badges:
   - R-CMD-check status
   - Lifecycle: experimental
   - License: MIT
   - (Optional) Coverage if codecov is set up
   Render with `devtools::build_readme()`.
4. **DESCRIPTION** — confirm no missing fields that `R CMD check --as-cran` would flag. Common ones to verify:
   - `Encoding: UTF-8`
   - `LazyData: true` — only if you have `data/` shipped; if not, **remove it** (will get a NOTE otherwise)
   - All `Imports:` packages are used somewhere
   - No `Depends:` (use `Imports:`)
5. **Run `R CMD check --as-cran` locally** and ensure clean. Fix any NOTEs/WARNINGs.

## Out of scope

- pkgdown deployment (already set up in `.github/workflows/pkgdown.yaml`)
- Pre-commit hooks
- Linting workflow (separate prompt if wanted)

## Acceptance check

- Push to a branch, open a PR, see green check on all three OSes
- `devtools::check()` locally passes with 0 errors, 0 warnings, ≤ 1 NOTE (usually "new submission" if first time)

## When to ask vs proceed

**Proceed**: standard tidyverse CI template. No design decisions here.
