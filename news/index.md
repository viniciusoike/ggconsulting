# Changelog

## ggconsulting (development version)

### Foundation (prompt 01)

- [`ct_theme()`](https://viniciusoike.github.io/ggconsulting/reference/ct_theme.md)
  builder composed via `theme_sub_*()` helpers and routed through
  [`element_geom()`](https://ggplot2.tidyverse.org/reference/element.html)
  so
  [`from_theme()`](https://ggplot2.tidyverse.org/reference/aes_eval.html)-aware
  geoms inherit the palette’s main colour (`ink`) and a default
  linewidth.
- [`theme_strategy()`](https://viniciusoike.github.io/ggconsulting/reference/theme_strategy.md)
  archetype as a preset path.
- Five starter palettes: `strategy_navy`, `strategy_emerald`,
  `strategy_crimson`, `strategy_azure`, `strategy_slate`.
- [`ct_col()`](https://viniciusoike.github.io/ggconsulting/reference/ct_geoms.md)
  /
  [`ct_line()`](https://viniciusoike.github.io/ggconsulting/reference/ct_geoms.md)
  /
  [`ct_point()`](https://viniciusoike.github.io/ggconsulting/reference/ct_geoms.md)
  mechanical wrappers for explicit-override use at the call site.
- [`ct_set_defaults()`](https://viniciusoike.github.io/ggconsulting/reference/ct_defaults.md)
  /
  [`ct_unset_defaults()`](https://viniciusoike.github.io/ggconsulting/reference/ct_defaults.md)
  for true aesthetic defaults (currently `geom_point` `size = 2.5`),
  autoloaded on library attach with an opt-out option.
- `has_font()` internal helper.

### CI (prompt 02)

- `R-CMD-check` workflow across macOS, Windows, Ubuntu (R release) and
  Ubuntu (R devel).
- `test-coverage` workflow via covr + Codecov v4.
- README badges: R-CMD-check status, Codecov coverage, License: MIT.

### Scales and palette preview (prompt 03)

- [`scale_color_ct()`](https://viniciusoike.github.io/ggconsulting/reference/ct_scales.md)
  /
  [`scale_fill_ct()`](https://viniciusoike.github.io/ggconsulting/reference/ct_scales.md)
  — discrete scales backed by ggconsulting palettes; interpolate and
  emit a
  [`cli::cli_warn()`](https://cli.r-lib.org/reference/cli_abort.html)
  when `n` exceeds the palette size.
- [`scale_color_ct_c()`](https://viniciusoike.github.io/ggconsulting/reference/ct_scales.md)
  /
  [`scale_fill_ct_c()`](https://viniciusoike.github.io/ggconsulting/reference/ct_scales.md)
  — continuous variants via
  [`ggplot2::scale_color_gradientn()`](https://ggplot2.tidyverse.org/reference/scale_gradient.html)
  /
  [`scale_fill_gradientn()`](https://ggplot2.tidyverse.org/reference/scale_gradient.html).
- British-spelling aliases:
  [`scale_colour_ct()`](https://viniciusoike.github.io/ggconsulting/reference/ct_scales.md),
  [`scale_colour_ct_c()`](https://viniciusoike.github.io/ggconsulting/reference/ct_scales.md).
- [`ct_palette_show()`](https://viniciusoike.github.io/ggconsulting/reference/ct_palette_show.md)
  — swatch preview for a single palette, a custom hex vector, or every
  shipped palette faceted.
