# ggconsulting

An opinionated ggplot2 extension for executive-grade consulting output.
Ships three archetype themes, eleven palettes, locale-aware label
helpers (pt-BR + en-US), and a data-aware polish layer.

> **Heads up:** ggconsulting is in early development. The public API is
> being shaped against real consulting decks; expect breaking changes
> through `0.x`.

## Installation

The development version from GitHub:

``` r

# install.packages("pak")
pak::pak("viniciusoike/ggconsulting")
```

## Quick start

``` r

library(ggplot2)
#> Warning: package 'ggplot2' was built under R version 4.5.2
library(ggconsulting)
#> v ggconsulting set ggplot2 aesthetic defaults
#> i Opt out: `ct_unset_defaults()` or `options(ggconsulting.autoload = FALSE)`
#> i Column width / linewidth: use `ct_col()` / `ct_line()`, or apply
#>   `ct_theme()`/`theme_strategy()` for linewidth via `from_theme()`

ggplot(mtcars, aes(wt, mpg)) +
  geom_point() +
  labs(
    title    = "Fuel efficiency vs. vehicle weight",
    subtitle = "1974 Motor Trend data",
    caption  = "Source: datasets::mtcars"
  ) +
  theme_strategy()
```

![](reference/figures/README-example-1.png)

[`theme_strategy()`](https://viniciusoike.github.io/ggconsulting/reference/theme_strategy.md)
routes the palette’s main colour through ggplot2 4.x’s
[`from_theme()`](https://ggplot2.tidyverse.org/reference/aes_eval.html)
mechanism, so unmapped geoms inherit it automatically — no
`scale_color_*()` calls needed for the single-series case.

ggconsulting also sets a small set of aesthetic defaults on
[`library()`](https://rdrr.io/r/base/library.html) attach (currently
`geom_point` `size = 2.5`). Opt out via:

``` r

options(ggconsulting.autoload = FALSE)
# or, mid-session:
ct_unset_defaults()
```

## What’s inside

**Themes**

- [`ct_theme()`](https://viniciusoike.github.io/ggconsulting/reference/ct_theme.md)
  — composable theme builder with `palette`, `font`, `density`, and
  `context` arguments. Built on ggplot2 4.x `theme_sub_*()` helpers and
  routed through
  [`element_geom()`](https://ggplot2.tidyverse.org/reference/element.html)
  for
  [`from_theme()`](https://ggplot2.tidyverse.org/reference/aes_eval.html)
  linkage.
- [`theme_strategy()`](https://viniciusoike.github.io/ggconsulting/reference/theme_strategy.md)
  — minimal, generous-whitespace, navy-default preset inspired by
  top-tier global strategy consultancies.
- [`theme_finance()`](https://viniciusoike.github.io/ggconsulting/reference/theme_finance.md)
  — serif preset with denser defaults (`density = "tight"`,
  `context = "report"`) tuned for printed pages and pitch books.
- [`theme_editorial()`](https://viniciusoike.github.io/ggconsulting/reference/theme_editorial.md)
  — serif preset with italic subtitles and a warmer palette for client
  memos and market commentary.

**Palettes and scales**

- Eleven shipped palettes — five strategy (`strategy_navy`,
  `strategy_emerald`, `strategy_crimson`, `strategy_azure`,
  `strategy_slate`), three finance (`finance_classic`, `finance_steel`,
  `finance_burgundy`), and three editorial (`editorial_warm`,
  `editorial_clay`, `editorial_oxide`).
- [`scale_color_ct()`](https://viniciusoike.github.io/ggconsulting/reference/ct_scales.md)
  /
  [`scale_fill_ct()`](https://viniciusoike.github.io/ggconsulting/reference/ct_scales.md)
  — discrete scales backed by the palettes; interpolate and warn when
  `n` exceeds the palette size.
- [`scale_color_ct_c()`](https://viniciusoike.github.io/ggconsulting/reference/ct_scales.md)
  /
  [`scale_fill_ct_c()`](https://viniciusoike.github.io/ggconsulting/reference/ct_scales.md)
  — continuous variants. British-spelling aliases (`scale_colour_ct*`)
  are also exported.
- [`ct_palette_show()`](https://viniciusoike.github.io/ggconsulting/reference/ct_palette_show.md)
  — quick swatch preview for a single palette, a custom hex vector, or
  every shipped palette faceted.

**Locale-aware labels**

- `ct_locale("pt-BR" | "en-US")` — session-scoped locale switch stored
  in `options(ggconsulting.locale)`. Does not touch
  [`Sys.setlocale()`](https://rdrr.io/r/base/locales.html); portable
  across Windows / Linux / macOS CI.
- [`fmt_number()`](https://viniciusoike.github.io/ggconsulting/reference/ct_formatters.md),
  [`fmt_pct()`](https://viniciusoike.github.io/ggconsulting/reference/ct_formatters.md),
  [`fmt_delta()`](https://viniciusoike.github.io/ggconsulting/reference/ct_formatters.md),
  [`fmt_currency()`](https://viniciusoike.github.io/ggconsulting/reference/ct_formatters.md)
  — locale-aware formatters.
- [`fmt_brl()`](https://viniciusoike.github.io/ggconsulting/reference/ct_formatters.md)
  — always renders Brazilian Real with `R$` and a non-breaking space,
  regardless of active locale. Supports `style = "accounting"` for
  parens-wrapped negatives.
- [`fmt_month()`](https://viniciusoike.github.io/ggconsulting/reference/ct_formatters.md)
  — `Date` / `POSIXct` → localised month string, using internal pt-BR
  and en-US tables (no `LC_TIME` reliance).

**Data-aware polish layer**

- [`ct_finish()`](https://viniciusoike.github.io/ggconsulting/reference/ct_finish.md)
  — runs *after* the geom layer is built and can inject value labels
  above bars or next to points, reorder a categorical x by y, format
  labels via shortcut names (`"brl"`, `"number"`, `"pct"`, `"delta"`) or
  a user-supplied function, highlight specific x values while muting the
  rest, label the last point of each line series, and apply geom-aware
  scale expansion.

**Mechanical wrappers**

- [`ct_col()`](https://viniciusoike.github.io/ggconsulting/reference/ct_geoms.md),
  [`ct_line()`](https://viniciusoike.github.io/ggconsulting/reference/ct_geoms.md),
  [`ct_point()`](https://viniciusoike.github.io/ggconsulting/reference/ct_geoms.md)
  — thin wrappers with consulting-grade defaults for call-site
  overrides.
- [`ct_set_defaults()`](https://viniciusoike.github.io/ggconsulting/reference/ct_defaults.md)
  /
  [`ct_unset_defaults()`](https://viniciusoike.github.io/ggconsulting/reference/ct_defaults.md)
  —
  [`update_geom_defaults()`](https://ggplot2.tidyverse.org/reference/update_defaults.html)-driven
  aesthetic baseline with honest revert.

## Roadmap

`install_consulting_fonts()`, three vignettes (theme comparison, locale
and number formatting, font setup), and a polished pkgdown gallery. The
companion package `ctplot` — `ct_waterfall()`, `ct_slope()`,
`ct_dumbbell()`, and PPT export via `officer` — will follow in a
separate repo.
