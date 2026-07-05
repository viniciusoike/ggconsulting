# ggconsulting

Executive-grade ggplot2 extension for consulting output. R package, v0.0.0.9000 (experimental).

## Architecture

- **Theme builder**: `ct_theme()` (R/ct-theme.R) composes `theme_minimal()` + `theme_sub_*()` helpers + `element_geom(ink = ...)` for `from_theme()` linkage. Three archetype presets: `theme_strategy()`, `theme_finance()`, `theme_editorial()`.
- **Geom defaults**: `ct_set_defaults()` / `ct_unset_defaults()` (R/ct-defaults.R) use `update_geom_defaults()` only. Originals captured once in `.ct_env`. Auto-applied on attach via `.onAttach()` in R/zzz.R.
- **Geom wrappers**: `ct_col()`, `ct_line()`, `ct_point()` (R/ct-wrappers.R) — thin pass-throughs with consulting defaults baked in as formals.
- **Palettes**: 11 named palettes in `.ct_palettes` (R/palettes.R). Palette families: strategy (5), finance (3), editorial (3). Each palette is 6 hex colours; index 1 = main colour.
- **Scales**: Discrete + continuous colour/fill scales (R/scales.R). Discrete interpolates with a warning when data > palette size.
- **Formatters**: Factory functions returning `function(x) character` (R/format-helpers.R). `fmt_number()`, `fmt_brl()`, `fmt_currency()`, `fmt_pct()`, `fmt_delta()`, `fmt_month()`. All locale-aware via `ct_locale()`.
- **Locale**: Two built-in locales: `"pt-BR"` (default), `"en-US"` (R/locale.R). Ships own month tables — does not touch `Sys.setlocale()`.
- **Polish layer**: `ct_finish()` (R/ct-finish.R) — S3 `ggplot_add()` dispatch. Data-aware: value labels, sort, highlight, end labels, scale expansion.
- **Datasets**: 6 bundled datasets (R/data.R, data-raw/): `bu_quarterly`, `market_share`, `client_nps`, `ebitda_bridge`, `ibov_sectors`, `br_macro`.

## ggplot2 4.x conventions

This package targets ggplot2 >= 4.0. Key conventions:

- Use `theme_sub_*()` helpers (`theme_sub_panel()`, `theme_sub_plot()`, `theme_sub_axis_x()`, etc.) instead of a single monolithic `theme()` call.
- Linewidth flows through `element_geom(ink = ..., linewidth = ...)` + `from_theme()` — never mutate geom formals or use `assignInNamespace()`.
- Three legitimate ways to set geom defaults: (1) theme `geom` element for `from_theme()`-aware aesthetics, (2) `update_geom_defaults()` for package-wide overrides, (3) public wrapper functions with explicit formals.

## Development

```sh
# Check
Rscript -e 'devtools::check()'

# Test
Rscript -e 'devtools::test()'

# Single test file
Rscript -e 'testthat::test_file("tests/testthat/test-ct-theme.R")'

# Document
Rscript -e 'devtools::document()'

# pkgdown site
Rscript -e 'pkgdown::build_site()'
```

## Test structure

Tests use testthat 3 edition. Visual regression tests use vdiffr. Test files mirror source files: `test-ct-theme.R`, `test-defaults.R`, `test-wrappers.R`, `test-scales.R`, `test-locale.R`, `test-ct-finish.R`, `test-archetypes.R`. Setup in `tests/testthat/setup.R`.

## Code style

- RStudio-style section headers: `# Section ----`, `## Subsection ----` with trailing dashes to ~76 chars. No box-style `====` borders.
- Prefix internal helpers with `.` (e.g. `.resolve_palette()`, `.ct_env`).
- User-facing messages via `cli::cli_abort()` / `cli::cli_warn()` / `cli::cli_inform()`.
- roxygen2 with markdown enabled (`Roxygen: list(markdown = TRUE)`).
- Lifecycle badges on experimental functions.

## Key files

- `R/zzz.R` — `.onLoad()` / `.onAttach()`, package-private environment `.ct_env`
- `R/palettes.R` — `.ct_palettes` list, `.resolve_palette()`
- `R/ct-theme.R` — `ct_theme()` builder + internal helpers
- `R/ct-finish.R` — `ct_finish()` + `ggplot_add.ct_finish()` dispatch
- `_pkgdown.yml` — pkgdown site config with grouped reference sections
- `inst/gallery/` — standalone gallery scripts for visual demos
