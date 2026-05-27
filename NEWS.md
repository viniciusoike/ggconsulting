# ggconsulting (development version)

* Foundation slice (v0.1 scope):
  - `ct_theme()` builder composed via `theme_sub_*()` helpers and routed
    through `element_geom()` so `from_theme()`-aware geoms inherit the
    palette's main colour (`ink`) and a default linewidth.
  - `theme_strategy()` archetype as a preset path.
  - Five starter palettes: `strategy_navy`, `strategy_emerald`,
    `strategy_crimson`, `strategy_azure`, `strategy_slate`.
  - `ct_col()` / `ct_line()` / `ct_point()` mechanical wrappers for
    explicit-override use at the call site.
  - `ct_set_defaults()` / `ct_unset_defaults()` for true aesthetic
    defaults (currently `geom_point` `size = 2.5`), autoloaded on
    library attach with an opt-out option.
  - `has_font()` internal helper.
