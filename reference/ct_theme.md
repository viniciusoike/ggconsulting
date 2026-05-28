# Build a consulting-grade ggplot2 theme

**\[experimental\]**

Flexible builder behind the archetype presets
([`theme_strategy()`](https://viniciusoike.github.io/ggconsulting/reference/theme_strategy.md)
and friends). Composes
[`ggplot2::theme_minimal()`](https://ggplot2.tidyverse.org/reference/ggtheme.html)
with executive-output overrides via `theme_sub_*()` helpers, sets the
theme `geom` element so
[`from_theme()`](https://ggplot2.tidyverse.org/reference/aes_eval.html)-aware
layers (e.g.
[`ggplot2::geom_line()`](https://ggplot2.tidyverse.org/reference/geom_path.html))
inherit the resolved linewidth and main colour, and applies the resolved
font with a fallback chain.

## Usage

``` r
ct_theme(
  palette = "strategy_navy",
  font = "Inter",
  font_fallback = c("Helvetica Neue", "Arial", "sans"),
  density = c("normal", "tight", "loose"),
  context = c("presentation", "report", "screen"),
  base_size = NULL,
  main_color = NULL
)
```

## Arguments

- palette:

  Palette name (e.g. `"strategy_navy"`) or character vector of colours.

- font:

  Preferred font family.

- font_fallback:

  Character vector of fallback families to try if `font` is unavailable.
  The generic R families `"sans"`, `"serif"`, and `"mono"` are always
  recognised as terminal fallbacks.

- density:

  One of `"normal"`, `"tight"`, `"loose"`. Controls `panel.spacing` and
  axis-text margins.

- context:

  One of `"presentation"`, `"report"`, `"screen"`. Drives default
  `base_size` and `plot.margin`.

- base_size:

  Base font size. If `NULL`, derived from `context`.

- main_color:

  Routed into the theme `geom` element's `ink` slot, so unmapped geoms
  pick it up via
  [`from_theme()`](https://ggplot2.tidyverse.org/reference/aes_eval.html).
  `NULL` falls back to the palette's first colour. Title colour is a
  fixed neutral near-black (`#1A1A1A`); override with a follow-on
  [`theme()`](https://ggplot2.tidyverse.org/reference/theme.html) call
  if you want it palette-tinted.

## Value

A
[`ggplot2::theme()`](https://ggplot2.tidyverse.org/reference/theme.html)
object.

## Examples

``` r
library(ggplot2)
p <- ggplot(mtcars, aes(wt, mpg)) +
  geom_point() +
  ct_theme()
```
