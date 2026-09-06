# ggconsulting

Executive-grade ggplot2 extension for consulting output. R package, v0.1.0 (experimental).

Requires ggplot2 >= 4.0.0 and R >= 4.1. The theme layer is built on ggplot2 4.x API and does not work on 3.x.

## Architecture

- **Theme builder**: `ct_theme()` (R/ct-theme.R) composes `theme_minimal()` + `theme_sub_*()` helpers + `element_geom(ink = ...)` for `from_theme()` linkage. Three archetype presets: `theme_strategy()`, `theme_finance()`, `theme_editorial()`.
- **Geom defaults**: `ct_set_defaults()` / `ct_unset_defaults()` (R/ct-defaults.R) use `update_geom_defaults()` only. Originals captured once in `.ct_env`. Auto-applied on attach via `.onAttach()` in R/zzz.R.
- **Geom wrappers**: `ct_col()`, `ct_line()`, `ct_point()` (R/ct-wrappers.R) — thin pass-throughs with consulting defaults baked in as formals.
- **Palettes**: 11 named palettes in `.ct_palettes` (R/palettes.R). Palette families: strategy (5), finance (3), editorial (3). Each palette is 6 hex colours; index 1 = main colour. `ct_palette()` is the accessor (no args = list names); `ct_palette_show()` (R/ct-palette-show.R) renders swatches.
- **Scales**: Discrete + continuous colour/fill scales (R/scales.R). Discrete interpolates with a warning when data > palette size.
- **Formatters**: Factory functions returning `function(x) character` (R/format-helpers.R). `fmt_number()`, `fmt_brl()`, `fmt_currency()`, `fmt_pct()`, `fmt_delta()`, `fmt_month()`. All locale-aware via `ct_locale()`.
- **Locale**: Two built-in locales: `"pt-BR"` (default), `"en-US"` (R/locale.R). Ships own month tables — does not touch `Sys.setlocale()`.
- **Polish layer**: `ct_finish()` (R/ct-finish.R) — S3 `ggplot_add()` dispatch. Data-aware: value labels, sort, highlight, end labels, scale expansion.
- **Fonts**: `has_font()` and `install_consulting_fonts()` (R/utils-font.R). `has_font()` checks both `systemfonts::system_fonts()` and `registry_fonts()`, so session-registered client fonts count. The installer downloads from Google Fonts and gates writes to the home directory behind consent.
- **Datasets**: 6 bundled datasets (R/data.R, data-raw/): `bu_quarterly`, `market_share`, `client_nps`, `ebitda_bridge`, `ibov_sectors`, `br_macro`.

## Package options

- `ggconsulting.autoload` (default `TRUE`) — apply `ct_set_defaults()` on attach.
- `ggconsulting.locale` (default `"pt-BR"`) — read by every `fmt_*()` helper when its `locale` argument is `NULL`. Set via `ct_locale()`.
- `ggconsulting.font_consent` (default `FALSE`) — allow `install_consulting_fonts()` to write to the default font directory unattended.

## ggplot2 4.x conventions

- Use `theme_sub_*()` helpers (`theme_sub_panel()`, `theme_sub_plot()`, `theme_sub_axis_x()`, etc.) instead of a single monolithic `theme()` call.
- Linewidth flows through `element_geom(ink = ..., linewidth = ...)` + `from_theme()` — never mutate geom formals or use `assignInNamespace()`.
- Three legitimate ways to set geom defaults: (1) theme `geom` element for `from_theme()`-aware aesthetics, (2) `update_geom_defaults()` for package-wide overrides, (3) public wrapper functions with explicit formals.

## Gotchas

- `ct_theme()` stashes `ct_palette` and `ct_main_color` as attributes on the returned theme. `+ theme()` preserves them, so the archetype presets keep them after their follow-on `theme()` call.
- `ct_finish(highlight = ...)` reads `attr(plot$theme, "ct_main_color")` at `ggplot_add()` time, so it is order-dependent: add the theme *before* `ct_finish()`, or highlights fall back to the hardcoded `#1F4E79`.
- `ct_col()`'s `width` is in x-axis units. On a Date axis that is 0.8 days — convert x to a factor or index for bar charts.

## Development

```sh
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

Tests use testthat 3 edition; `tests/testthat/setup.R` exists but is empty. Test files mirror source files: `test-ct-theme.R`, `test-archetypes.R`, `test-defaults.R`, `test-wrappers.R`, `test-scales.R`, `test-palettes.R`, `test-locale.R`, `test-ct-finish.R`, `test-fonts.R`.

`test-vdiffr.R` holds visual regression tests in two tiers. Layout baselines call `ct_theme(font = "sans")` and run everywhere; font baselines are `skip_if_not(has_font(...))`-gated on Inter or Source Serif 4. Every case is `skip_on_cran()`. Baselines live in `tests/testthat/_snaps/vdiffr/`.

## Design references

`data-raw/references/` is the design ground truth for the archetypes: `catalog.csv` (one row per reference chart) and `briefs/*.md` (per-publisher syntheses of palette, typography, grid, and annotation conventions). The PNGs themselves are gitignored — they are copyrighted works, so only the text observations are tracked. Publisher → archetype mapping and the open backlog items live in `data-raw/references/README.md` and the briefs.

## Code style

- RStudio-style section headers: `# Section ----`, `## Subsection ----` with trailing dashes to ~76 chars. No box-style `====` borders.
- Prefix internal helpers with `.` (e.g. `.resolve_palette()`, `.ct_env`).
- User-facing messages via `cli::cli_abort()` / `cli::cli_warn()` / `cli::cli_inform()`.
- roxygen2 with markdown enabled (`Roxygen: list(markdown = TRUE)`).
- Lifecycle badges on experimental functions.

## Key files

- `R/zzz.R` — `.onLoad()` / `.onAttach()`, package-private environment `.ct_env`
- `R/palettes.R` — `.ct_palettes` list, `.resolve_palette()`, `ct_palette()`
- `R/ct-theme.R` — `ct_theme()` builder + internal helpers
- `R/ct-finish.R` — `ct_finish()` + `ggplot_add.ct_finish()` dispatch
- `R/utils-font.R` — font availability, Google Fonts catalog, install consent gate
- `_pkgdown.yml` — pkgdown site config with grouped reference sections
- `inst/gallery/` — standalone gallery scripts for visual demos
- `data-raw/references/` — design reference catalog and publisher briefs
