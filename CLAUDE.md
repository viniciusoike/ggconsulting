# ggconsulting

Executive-grade ggplot2 extension for consulting output. R package,
v0.1.0 (experimental).

Requires ggplot2 \>= 4.0.0 and R \>= 4.1. The theme layer is built on
ggplot2 4.x API and does not work on 3.x.

## Architecture

- **Theme builder**:
  [`ct_theme()`](https://viniciusoike.github.io/ggconsulting/reference/ct_theme.md)
  (R/ct-theme.R) composes `theme_minimal()` + `theme_sub_*()` helpers +
  `element_geom(ink = ...)` for `from_theme()` linkage. Three archetype
  presets:
  [`theme_strategy()`](https://viniciusoike.github.io/ggconsulting/reference/theme_strategy.md),
  [`theme_finance()`](https://viniciusoike.github.io/ggconsulting/reference/theme_finance.md),
  [`theme_editorial()`](https://viniciusoike.github.io/ggconsulting/reference/theme_editorial.md).
  `paper` sets the figure ground (`"cream"`, `"warm_grey"`, `"white"`,
  or any colour) and derives a matching gridline; the archetypes forward
  it through `...`.
- **Geom defaults**:
  [`ct_set_defaults()`](https://viniciusoike.github.io/ggconsulting/reference/ct_defaults.md)
  /
  [`ct_unset_defaults()`](https://viniciusoike.github.io/ggconsulting/reference/ct_defaults.md)
  (R/ct-defaults.R) use `update_geom_defaults()` only. Originals
  captured once in `.ct_env`. Auto-applied on attach via `.onAttach()`
  in R/zzz.R.
- **Geom wrappers**:
  [`ct_col()`](https://viniciusoike.github.io/ggconsulting/reference/ct_geoms.md),
  [`ct_line()`](https://viniciusoike.github.io/ggconsulting/reference/ct_geoms.md),
  [`ct_point()`](https://viniciusoike.github.io/ggconsulting/reference/ct_geoms.md)
  (R/ct-wrappers.R) — thin pass-throughs with consulting defaults baked
  in as formals.
- **Palettes**: 11 named palettes in `.ct_palettes` (R/palettes.R).
  Palette families: strategy (5), finance (3), editorial (3). Each
  palette is 6 hex colours; index 1 = main colour.
  [`ct_palette()`](https://viniciusoike.github.io/ggconsulting/reference/ct_palette.md)
  is the accessor (no args = list names);
  [`ct_palette_show()`](https://viniciusoike.github.io/ggconsulting/reference/ct_palette_show.md)
  (R/ct-palette-show.R) renders swatches.
- **Scales**: Discrete + continuous colour/fill scales (R/scales.R).
  Discrete interpolates with a warning when data \> palette size.
- **Formatters**: Factory functions returning `function(x) character`
  (R/format-helpers.R).
  [`fmt_number()`](https://viniciusoike.github.io/ggconsulting/reference/ct_formatters.md),
  [`fmt_brl()`](https://viniciusoike.github.io/ggconsulting/reference/ct_formatters.md),
  [`fmt_currency()`](https://viniciusoike.github.io/ggconsulting/reference/ct_formatters.md),
  [`fmt_pct()`](https://viniciusoike.github.io/ggconsulting/reference/ct_formatters.md),
  [`fmt_delta()`](https://viniciusoike.github.io/ggconsulting/reference/ct_formatters.md),
  [`fmt_month()`](https://viniciusoike.github.io/ggconsulting/reference/ct_formatters.md).
  All locale-aware via
  [`ct_locale()`](https://viniciusoike.github.io/ggconsulting/reference/ct_locale.md).
- **Locale**: Two built-in locales: `"pt-BR"` (default), `"en-US"`
  (R/locale.R). Ships own month tables — does not touch
  [`Sys.setlocale()`](https://rdrr.io/r/base/locales.html).
- **Polish layer**:
  [`ct_finish()`](https://viniciusoike.github.io/ggconsulting/reference/ct_finish.md)
  (R/ct-finish.R) — S3 `ggplot_add()` dispatch. Data-aware: value
  labels, sort, highlight, end labels (`TRUE` or `"first_facet"`), end
  points, y-axis position, mirrored y ticks, scale expansion.
- **Fonts**:
  [`has_font()`](https://viniciusoike.github.io/ggconsulting/reference/has_font.md)
  and
  [`install_consulting_fonts()`](https://viniciusoike.github.io/ggconsulting/reference/install_consulting_fonts.md)
  (R/utils-font.R).
  [`has_font()`](https://viniciusoike.github.io/ggconsulting/reference/has_font.md)
  checks both
  [`systemfonts::system_fonts()`](https://systemfonts.r-lib.org/reference/system_fonts.html)
  and `registry_fonts()`, so session-registered client fonts count. The
  installer downloads from Google Fonts and gates writes to the home
  directory behind consent.
- **Datasets**: 6 bundled datasets (R/data.R, data-raw/):
  `bu_quarterly`, `market_share`, `client_nps`, `ebitda_bridge`,
  `ibov_sectors`, `br_macro`.

## Package options

- `ggconsulting.autoload` (default `TRUE`) — apply
  [`ct_set_defaults()`](https://viniciusoike.github.io/ggconsulting/reference/ct_defaults.md)
  on attach.
- `ggconsulting.locale` (default `"pt-BR"`) — read by every `fmt_*()`
  helper when its `locale` argument is `NULL`. Set via
  [`ct_locale()`](https://viniciusoike.github.io/ggconsulting/reference/ct_locale.md).
- `ggconsulting.font_consent` (default `FALSE`) — allow
  [`install_consulting_fonts()`](https://viniciusoike.github.io/ggconsulting/reference/install_consulting_fonts.md)
  to write to the default font directory unattended.

## ggplot2 4.x conventions

- Use `theme_sub_*()` helpers (`theme_sub_panel()`, `theme_sub_plot()`,
  `theme_sub_axis_x()`, etc.) instead of a single monolithic `theme()`
  call.
- Linewidth flows through `element_geom(ink = ..., linewidth = ...)` +
  `from_theme()` — never mutate geom formals or use
  [`assignInNamespace()`](https://rdrr.io/r/utils/getFromNamespace.html).
- Three legitimate ways to set geom defaults: (1) theme `geom` element
  for `from_theme()`-aware aesthetics, (2) `update_geom_defaults()` for
  package-wide overrides, (3) public wrapper functions with explicit
  formals.

## Gotchas

- [`ct_theme()`](https://viniciusoike.github.io/ggconsulting/reference/ct_theme.md)
  stashes `ct_palette` and `ct_main_color` as attributes on the returned
  theme. `+ theme()` preserves them, so the archetype presets keep them
  after their follow-on `theme()` call.
- `ct_finish(highlight = ...)` reads `attr(plot$theme, "ct_main_color")`
  at `ggplot_add()` time, so it is order-dependent: add the theme
  *before*
  [`ct_finish()`](https://viniciusoike.github.io/ggconsulting/reference/ct_finish.md),
  or highlights fall back to the hardcoded `#1F4E79`.
- [`ct_col()`](https://viniciusoike.github.io/ggconsulting/reference/ct_geoms.md)’s
  `width` is in x-axis units. On a Date axis that is 0.8 days — convert
  x to a factor or index for bar charts.
- Axis position is a scale/guide property in ggplot2, not a theme one,
  so `axis_y` lives on
  [`ct_finish()`](https://viniciusoike.github.io/ggconsulting/reference/ct_finish.md)
  (via `guide_axis()`), not
  [`ct_theme()`](https://viniciusoike.github.io/ggconsulting/reference/ct_theme.md).
  Unlike `highlight`, it does not care whether the theme is added first.
- [`ct_finish()`](https://viniciusoike.github.io/ggconsulting/reference/ct_finish.md)
  adds an x scale for `end_labels` and another for `expand = "auto"`.
  Both defer to an x scale the caller supplied, and to each other —
  handing a Date axis to `scale_x_continuous()` builds without complaint
  but renders raw day numbers instead of dates, so
  `.x_expansion_scale()` picks the constructor by x type.
- `end_labels = "first_facet"` reads facet levels from the full plot
  data, not from the computed end rows. Series commonly all terminate in
  the same panel, which would otherwise pin the labels to that panel
  rather than the first.
- Direct end labels do not suppress the legend; add
  `theme(legend.position = "none")` when using them as a legend
  replacement.

## Development

``` sh
# Check
Rscript -e 'devtools::check()'

# Test
Rscript -e 'devtools::test()'

# Single test file
Rscript -e 'testthat::test_file("tests/testthat/test-ct-theme.R")'

# Coverage
Rscript -e 'covr::report(covr::package_coverage())'

# Document
Rscript -e 'devtools::document()'

# README (regenerate README.md from README.Rmd)
Rscript -e 'devtools::build_readme()'

# pkgdown site
Rscript -e 'pkgdown::build_site()'
```

## Test structure

Tests use testthat 3 edition; `tests/testthat/setup.R` exists but is
empty. Test files mirror source files: `test-ct-theme.R`,
`test-archetypes.R`, `test-defaults.R`, `test-wrappers.R`,
`test-scales.R`, `test-palettes.R`, `test-locale.R`, `test-ct-finish.R`,
`test-fonts.R`.

`test-vdiffr.R` holds visual regression tests in two tiers. Layout
baselines call `ct_theme(font = "sans")` and run everywhere; font
baselines are `skip_if_not(has_font(...))`-gated on Inter or Source
Serif 4. Every case is `skip_on_cran()`. Baselines live in
`tests/testthat/_snaps/vdiffr/`.

## Design references

`data-raw/references/` is the design ground truth for the archetypes:
`catalog.csv` (one row per reference chart) and `briefs/*.md`
(per-publisher syntheses of palette, typography, grid, and annotation
conventions). The PNGs themselves are gitignored — they are copyrighted
works, so only the text observations are tracked. Publisher → archetype
mapping and the open backlog items live in
`data-raw/references/README.md` and the briefs.

## Code style

- RStudio-style section headers: `# Section ----`, `## Subsection ----`
  with trailing dashes to ~76 chars. No box-style `====` borders.
- Prefix internal helpers with `.` (e.g. `.resolve_palette()`,
  `.ct_env`).
- User-facing messages via
  [`cli::cli_abort()`](https://cli.r-lib.org/reference/cli_abort.html) /
  [`cli::cli_warn()`](https://cli.r-lib.org/reference/cli_abort.html) /
  [`cli::cli_inform()`](https://cli.r-lib.org/reference/cli_abort.html).
- roxygen2 with markdown enabled (`Roxygen: list(markdown = TRUE)`).
- Lifecycle badges on experimental functions.

## Key files

- `R/zzz.R` — `.onLoad()` / `.onAttach()`, package-private environment
  `.ct_env`
- `R/palettes.R` — `.ct_palettes` list, `.resolve_palette()`,
  [`ct_palette()`](https://viniciusoike.github.io/ggconsulting/reference/ct_palette.md)
- `R/ct-theme.R` —
  [`ct_theme()`](https://viniciusoike.github.io/ggconsulting/reference/ct_theme.md)
  builder + internal helpers
- `R/ct-finish.R` —
  [`ct_finish()`](https://viniciusoike.github.io/ggconsulting/reference/ct_finish.md) +
  `ggplot_add.ct_finish()` dispatch
- `R/utils-font.R` — font availability, Google Fonts catalog, install
  consent gate
- `_pkgdown.yml` — pkgdown site config with grouped reference sections
- `inst/gallery/` — standalone gallery scripts for visual demos
- `data-raw/references/` — design reference catalog and publisher briefs
