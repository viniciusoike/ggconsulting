# Package index

## Themes

Composable theme builder and archetype presets.

- [`ct_theme()`](https://viniciusoike.github.io/ggconsulting/reference/ct_theme.md)
  **\[experimental\]** : Build a consulting-grade ggplot2 theme
- [`theme_strategy()`](https://viniciusoike.github.io/ggconsulting/reference/theme_strategy.md)
  : Strategy archetype theme

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

## Defaults

Aesthetic defaults applied on library attach via
[`ggplot2::update_geom_defaults()`](https://ggplot2.tidyverse.org/reference/update_defaults.html),
with an opt-out path.

- [`ct_set_defaults()`](https://viniciusoike.github.io/ggconsulting/reference/ct_defaults.md)
  [`ct_unset_defaults()`](https://viniciusoike.github.io/ggconsulting/reference/ct_defaults.md)
  : Set or restore ggconsulting aesthetic defaults
