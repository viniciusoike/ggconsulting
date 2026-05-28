# Prompt 03: Finance and editorial archetypes

## Context

`theme_strategy()` is in. Two more archetypes need to land to validate the `ct_theme()` builder abstraction — `theme_finance()` (denser, serif body, classical) and `theme_editorial()` (warmer palette, italic subtitles, more typographic personality). Their palettes are missing too.

Design doc: `consultr_plan_v2.html` — "Three archetypes" under ggconsulting.

## Deliverables

1. **R/palettes.R** — add palette families. Keep the existing 5 `strategy_*` entries; append:
   - `finance_classic`, `finance_steel`, `finance_burgundy` — three palettes for the finance family. Conservative blue/gray dominant, optional burgundy or forest green accent. Each 6 colors.
   - `editorial_warm`, `editorial_clay`, `editorial_oxide` — three palettes for editorial. Warmer (red, ochre, teal). Each 6 colors.
   - **Ask before locking the hex values** — pick reasonable starting points and ask.
2. **R/theme-finance.R** — `theme_finance(main_color = NULL, ...)` preset path through `ct_theme()`. Defaults: `palette = "finance_classic"`, `font = "Source Serif 4"` with serif fallback chain `c("Source Serif 4", "Georgia", "Times New Roman", "serif")`. Densities default to `"normal"`. Subtle gridlines (lighter than strategy). Title is regular weight (not bold) — finance reports lean restrained.
3. **R/theme-editorial.R** — `theme_editorial(main_color = NULL, ...)` preset path. Defaults: `palette = "editorial_warm"`, `font = "Source Serif 4"` with serif fallback. Subtitle is italic, slightly larger than strategy's. Title may be a touch larger and tightly leaded.
4. **Update R/ct-theme.R** — the font fallback chain in `.resolve_font()` currently hardcodes `c("Helvetica Neue", "Arial", "sans")`. Accept a fallback chain as a second argument and pass appropriate chains from each archetype function. Don't break the existing call site.
5. **\_pkgdown.yml** — add `theme_finance`, `theme_editorial` to the "Themes" reference section.
6. **tests/testthat/test-archetypes.R** — for each archetype:
   - Returns a `"theme"`/`"gg"` object
   - Sets the expected `geom$ink` to the palette's first color
   - Skip font-dependent assertions if the font isn't installed.

## Out of scope

- CVD-safe variants of these palettes (separate prompt later)
- Vignettes showing side-by-side archetype comparison (later)
- Custom `main_color` overrides beyond what `theme_strategy()` already supports

## Acceptance check

```r
library(ggplot2)
p <- ggplot(economics, aes(date, unemploy)) + geom_line()
p + theme_strategy()
p + theme_finance()
p + theme_editorial()

# All three should look visibly distinct:
# - strategy: bold left-aligned title, generous whitespace, navy
# - finance: regular-weight serif title, denser, conservative blue-gray
# - editorial: italic subtitle, warmer palette
```

## When to ask vs proceed

**Ask before**: locking palette hex values for any of the 6 new palettes — share a swatch grid via `ct_palette_show()` first.

**Proceed**: typography and spacing tuning, font fallback chain composition.
