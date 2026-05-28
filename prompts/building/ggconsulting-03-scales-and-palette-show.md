# Prompt 02: Scales and palette preview

## Context

Foundation is in. Five `strategy_*` palettes already exist in `R/palettes.R` as an internal `.ct_palettes` list, with `.resolve_palette()` as the lookup. Themes route the main color into `from_theme(ink)`, but mapped `color`/`fill` aesthetics still need scale functions.

Design doc: `consultr_plan_v2.html` — see "Scales and palettes" under ggconsulting.

## Deliverables

1. **R/scales.R** — implement four functions:
   - `scale_color_ct(palette = "strategy_navy", reverse = FALSE, ...)` — discrete, wraps `ggplot2::discrete_scale()`. Resolves palette via `.resolve_palette()`. **Interpolate + warn** (via `cli::cli_warn()`) when `n > length(palette)`.
   - `scale_fill_ct(...)` — same shape as above but for `fill`.
   - `scale_color_ct_c(palette = "strategy_navy", direction = 1, ...)` — continuous variant. Use `ggplot2::scale_color_gradientn()` internally with `colors = .resolve_palette(palette)`. The `_c` suffix matches the `viridis::scale_color_viridis_c()` idiom.
   - `scale_fill_ct_c(...)` — same for fill.
2. **R/ct-palette-show.R** — `ct_palette_show(palette = NULL)`:
   - If `palette = NULL`, show all palettes in `.ct_palettes` as a faceted strip plot.
   - If a name or vector, show just that one.
   - Returns a ggplot object so it composes with `+`. Use `geom_tile()` + `geom_text()` showing the hex code on each swatch.
3. **NAMESPACE** — `@export` all five functions via roxygen.
4. **\_pkgdown.yml** — add a "Scales" section under reference grouping `scale_color_ct`, `scale_fill_ct`, `scale_color_ct_c`, `scale_fill_ct_c`, `ct_palette_show`.
5. **tests/testthat/test-scales.R**:
   - Each scale returns an object inheriting from `"ScaleDiscrete"` or `"ScaleContinuous"` as appropriate.
   - Building a plot with a too-large `n` triggers a warning matching "interpolat".
   - `ct_palette_show()` returns a ggplot.

## Out of scope

- CVD-safe palette variants (separate prompt)
- Diverging palettes (separate prompt)
- Per-archetype palette families beyond `strategy_*` (handled in prompt 03)

## Acceptance check

```r
devtools::document()
devtools::test()

# Eyeball:
library(ggplot2)
ggplot(mtcars, aes(wt, mpg, color = factor(cyl))) +
  geom_point() +
  scale_color_ct("strategy_azure") +
  theme_strategy()

ct_palette_show()  # all 5 palettes faceted
```

## When to ask vs proceed

**Ask before**: deciding on the exact scale function naming if you find a strong reason to diverge from `scale_color_ct` / `scale_color_ct_c`.

**Proceed**: everything else — pick reasonable internals for `discrete_scale()` (e.g., `aesthetics = "colour"`, `scale_name = "ct"`).
