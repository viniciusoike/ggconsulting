# Package index

## Themes

Composable theme builder and archetype presets.

- [`ct_theme()`](https://viniciusoike.github.io/ggconsulting/reference/ct_theme.md)
  **\[experimental\]** : Build a consulting-grade ggplot2 theme
- [`theme_strategy()`](https://viniciusoike.github.io/ggconsulting/reference/theme_strategy.md)
  : Strategy archetype theme
- [`theme_finance()`](https://viniciusoike.github.io/ggconsulting/reference/theme_finance.md)
  : Finance archetype theme
- [`theme_editorial()`](https://viniciusoike.github.io/ggconsulting/reference/theme_editorial.md)
  : Editorial archetype theme

## Scales and palettes

Discrete and continuous colour/fill scales backed by ggconsulting
palettes, plus a swatch preview helper.

- [`scale_color_ct()`](https://viniciusoike.github.io/ggconsulting/reference/ct_scales.md)
  [`scale_colour_ct()`](https://viniciusoike.github.io/ggconsulting/reference/ct_scales.md)
  [`scale_fill_ct()`](https://viniciusoike.github.io/ggconsulting/reference/ct_scales.md)
  [`scale_color_ct_c()`](https://viniciusoike.github.io/ggconsulting/reference/ct_scales.md)
  [`scale_colour_ct_c()`](https://viniciusoike.github.io/ggconsulting/reference/ct_scales.md)
  [`scale_fill_ct_c()`](https://viniciusoike.github.io/ggconsulting/reference/ct_scales.md)
  **\[experimental\]** : Consulting colour and fill scales
- [`ct_palette_show()`](https://viniciusoike.github.io/ggconsulting/reference/ct_palette_show.md)
  : Preview ggconsulting palettes as a swatch

## Data-aware polish

[`ct_finish()`](https://viniciusoike.github.io/ggconsulting/reference/ct_finish.md)
runs after the geom layer is built and inspects the plot to inject value
labels, sorting, highlighting, end labels, and scale expansion.

- [`ct_finish()`](https://viniciusoike.github.io/ggconsulting/reference/ct_finish.md)
  **\[experimental\]** : Apply data-aware finishing touches to a plot

## Geom wrappers

Drop-in replacements for
[`ggplot2::geom_col()`](https://ggplot2.tidyverse.org/reference/geom_bar.html),
[`geom_line()`](https://ggplot2.tidyverse.org/reference/geom_path.html),
and
[`geom_point()`](https://ggplot2.tidyverse.org/reference/geom_point.html)
with consulting-grade defaults baked in at the call site.

- [`ct_col()`](https://viniciusoike.github.io/ggconsulting/reference/ct_geoms.md)
  [`ct_line()`](https://viniciusoike.github.io/ggconsulting/reference/ct_geoms.md)
  [`ct_point()`](https://viniciusoike.github.io/ggconsulting/reference/ct_geoms.md)
  : Drop-in replacements for geom_col(), geom_line(), and geom_point()

## Locale and formatters

Locale-aware number, currency, percentage, and date formatters, plus a
session-scoped locale switch.

- [`ct_locale()`](https://viniciusoike.github.io/ggconsulting/reference/ct_locale.md)
  : Set the active ggconsulting locale
- [`fmt_number()`](https://viniciusoike.github.io/ggconsulting/reference/ct_formatters.md)
  [`fmt_brl()`](https://viniciusoike.github.io/ggconsulting/reference/ct_formatters.md)
  [`fmt_currency()`](https://viniciusoike.github.io/ggconsulting/reference/ct_formatters.md)
  [`fmt_pct()`](https://viniciusoike.github.io/ggconsulting/reference/ct_formatters.md)
  [`fmt_delta()`](https://viniciusoike.github.io/ggconsulting/reference/ct_formatters.md)
  [`fmt_month()`](https://viniciusoike.github.io/ggconsulting/reference/ct_formatters.md)
  : Locale-aware label formatters

## Defaults

Aesthetic defaults applied on library attach via
[`ggplot2::update_geom_defaults()`](https://ggplot2.tidyverse.org/reference/update_defaults.html),
with an opt-out path.

- [`ct_set_defaults()`](https://viniciusoike.github.io/ggconsulting/reference/ct_defaults.md)
  [`ct_unset_defaults()`](https://viniciusoike.github.io/ggconsulting/reference/ct_defaults.md)
  : Set or restore ggconsulting aesthetic defaults
