# Prompt 05: ct_finish() data-aware polish layer

## Context

`ct_finish()` is the data-aware companion to `ct_theme()`. It runs *after* the geom layer is built and can inspect the data + the active geom to apply value labels, sorting, highlighting, scale expansion, and end labels. This is where polish that depends on the data lives.

Depends on prompts 02 (scales) and 04 (locale formatters) being in.

Design doc: `consultr_plan_v2.html` — "ct_finish() — data-aware polish".

## Deliverables

1. **R/ct-finish.R** — `ct_finish()` returning a list of ggplot2 layers + scales + theme overrides that compose with `+`. Signature:
   ```r
   ct_finish(
     values     = FALSE,        # TRUE adds value labels; "auto" adds for column/bar
     sort       = NULL,         # "desc" | "asc" | NULL — reorder categorical x by value
     label_fmt  = NULL,         # name resolvable via fmt lookup ("brl", "number", "pct", "delta") or function
     highlight  = NULL,         # value(s) in fill/color mapping to emphasize; others muted
     end_labels = FALSE,        # for geom_line: label the last point of each series
     expand     = "auto"        # geom-aware scale expansion; FALSE to disable
   )
   ```
2. **Implementation notes**:
   - Return a small S3 object (`structure(list(...), class = "ct_finish")`) and write a `ggplot_add.ct_finish()` method (S3 dispatch hook ggplot2 already supports). This is how to inspect the plot at addition time and inject layers/scales conditionally.
   - **Auto-detect geom for `expand = "auto"`**: walk `plot$layers` to find the first non-blank-stat geom. Map: `GeomCol`/`GeomBar` → `expansion(mult = c(0, 0.15))` on y; `GeomLine` with date x → `expansion(mult = c(0, 0.08))` on x; else leave expansion alone.
   - **`label_fmt`**: if character, look up via `switch(label_fmt, brl = fmt_brl(), number = fmt_number(), pct = fmt_pct(), delta = fmt_delta())`. If function, use as-is. Validate and error with `cli::cli_abort()` if neither.
   - **`values = TRUE`**: add `geom_text()` above bars (col) or at points (point) showing the y aesthetic, formatted via `label_fmt`. Auto-pad y expansion to make room.
   - **`sort = "desc"`**: reorder factor levels of the x aesthetic by `-y`. Use `forcats`-style logic but without importing forcats — write it manually with `factor(x, levels = ...)`.
   - **`highlight`**: when not NULL, replace the color/fill scale with one that uses the active palette's main color for matching values and gray (`"#BBBBBB"`) for everything else.
   - **`end_labels = TRUE` for lines**: add `geom_text()` at the last x per group with the group label. Pair with a right-side scale expansion.
3. **Mark `ct_finish()` as experimental** via `@lifecycle experimental`.
4. **tests/testthat/test-ct-finish.R** — smoke tests for each arg in isolation:
   - `+ ct_finish(values = TRUE)` on `geom_col` adds a `geom_text` layer
   - `+ ct_finish(sort = "desc")` reorders the x factor
   - `+ ct_finish(label_fmt = "brl")` resolves to a function and applies it
   - `+ ct_finish(highlight = "B")` injects a manual color scale
   - `+ ct_finish(expand = "auto")` on `geom_col` adds y expansion
   - Bad `label_fmt` errors with a useful message

## Out of scope

- `geom_smooth` / `geom_ribbon` finishing — defer
- `facet`-aware polishing — defer (single panel for v0.1)
- Multi-line endpoint labels with smart de-overlap — defer to v0.2

## Acceptance check

```r
library(ggplot2)
d <- data.frame(g = LETTERS[1:5], v = c(3, 8, 5, 12, 7))

ggplot(d, aes(g, v)) +
  geom_col() +
  ct_finish(values = TRUE, sort = "desc", label_fmt = "brl", highlight = "D") +
  theme_strategy()

# Expected: D bar in navy, others gray; bars sorted by value descending;
# R$ value labels above each bar; y axis has room above the tallest bar.
```

## When to ask vs proceed

**Ask before**: choosing the muted color for non-highlighted categories (`"#BBBBBB"` may be too cold for editorial archetype).

**Proceed**: everything else.
