# Changelog

## ggconsulting (development version)

- Foundation slice (v0.1 scope):
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
