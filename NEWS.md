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

## Finance and editorial archetypes (prompt 04)

* `theme_finance()` — serif preset (Source Serif 4 → Georgia →
  Times New Roman → serif) with regular-weight title and a lighter
  major gridline. Defaults to the `finance_classic` palette.
* `theme_editorial()` — serif preset with an italic subtitle and
  slightly larger, tighter-leaded title. Defaults to the
  `editorial_warm` palette.
* `ct_theme()` gained a `font_fallback` argument; `.resolve_font()`
  now recognises `"sans"`, `"serif"`, and `"mono"` as guaranteed
  terminal fallbacks.
* Six new palettes: `finance_classic`, `finance_steel`,
  `finance_burgundy`, `editorial_warm`, `editorial_clay`,
  `editorial_oxide`. The catalog is now 11 palettes (5 strategy + 3
  finance + 3 editorial).
