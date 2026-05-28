# ggconsulting (development version)

## Foundation (prompt 01)

* `ct_theme()` builder composed via `theme_sub_*()` helpers and routed
  through `element_geom()` so `from_theme()`-aware geoms inherit the
  palette's main colour (`ink`) and a default linewidth.
* `theme_strategy()` archetype as a preset path.
* Five starter palettes: `strategy_navy`, `strategy_emerald`,
  `strategy_crimson`, `strategy_azure`, `strategy_slate`.
* `ct_col()` / `ct_line()` / `ct_point()` mechanical wrappers for
  explicit-override use at the call site.
* `ct_set_defaults()` / `ct_unset_defaults()` for true aesthetic
  defaults (currently `geom_point` `size = 2.5`), autoloaded on
  library attach with an opt-out option.
* `has_font()` internal helper.

## CI (prompt 02)

* `R-CMD-check` workflow across macOS, Windows, Ubuntu (R release) and
  Ubuntu (R devel).
* `test-coverage` workflow via covr + Codecov v4.
* README badges: R-CMD-check status, Codecov coverage, License: MIT.

## Scales and palette preview (prompt 03)

* `scale_color_ct()` / `scale_fill_ct()` — discrete scales backed by
  ggconsulting palettes; interpolate and emit a `cli::cli_warn()` when
  `n` exceeds the palette size.
* `scale_color_ct_c()` / `scale_fill_ct_c()` — continuous variants via
  `ggplot2::scale_color_gradientn()` / `scale_fill_gradientn()`.
* British-spelling aliases: `scale_colour_ct()`, `scale_colour_ct_c()`.
* `ct_palette_show()` — swatch preview for a single palette, a custom
  hex vector, or every shipped palette faceted.
