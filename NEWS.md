# ggconsulting 0.1.1

This patch release follows the bundled reference corpus into
`theme_finance()`, teaches `ct_finish()` to mirror axes and defer to
caller-supplied scales, records dataset provenance, and starts organised
documentation: a gallery article, provenance notes with source credits,
and an R-universe distribution.

## Data-aware polish

* `ct_finish(mirror_y = TRUE)` repeats the y-axis ticks on the opposite
  edge of the panel, without labels, so the eye can track a level across
  a wide panel in the absence of gridlines. It pairs with the bare axis
  of `theme_finance()`.
* Auto expansion in `ct_finish()` now defers to any positional scale
  supplied by the caller, so `scale_y_continuous(labels = ...)` keeps
  its labels instead of being silently replaced. Set the expansion in
  the same call when you need both labels and headroom.

## Themes

* `theme_finance()` follows the institutional finance chart packs the
  archetype is drawn from: humanist sans typography (`Source Sans 3`
  with an Inter / Helvetica Neue / Arial fallback chain) instead of
  serif, no gridlines, and y-axis ticks to read levels against. Pair
  with `ct_finish(mirror_y = TRUE)` to repeat the ticks on the right
  edge of wide panels.

## Fonts

* `install_consulting_fonts()` now installs to the per-user Windows
  Fonts directory by default and registers the installed fonts for the
  active R session.

## Distribution and documentation

* The package is available from R-universe, with source and binary
  builds for supported platforms.
* The README is rewritten against the current API, with a quick start
  that demos `ct_finish()` end labels and a Why ggconsulting? summary.
  The Codecov badge is replaced by the R-universe version badge.
* New article "Themes and palettes": a gallery with one plot per
  archetype preset plus the discrete and continuous scales, indexed
  under a pkgdown Articles navbar entry. The site gains a Datasets
  reference section.
* Dataset provenance is recorded in `data-raw/README.md` and mirrored
  into the dataset help pages. Beyond new disclaimers, this corrects
  the `br_macro` description (BCB SGS series 4189 and 3696; sale-rate
  USD/BRL; monthly source series rather than aggregated dailies) and
  credits B3 for `ibov_sectors`. Bundled snapshots note that BCB, IBGE,
  and B3 do not endorse the package.
* The package has a hex logo, regenerable with
  `data-raw/create_hexlogo.R`, shown on the package help page.

## Development

* `data-raw/references/` catalogues 22 institutional finance
  references, with McKinsey- and IMF-style briefs to guide future theme
  work.
* Local agent and editor files (`.Rprofile`, `CLAUDE.md`, `AGENTS.md`,
  Playwright MCP session output, `README.html`) are no longer tracked.

# ggconsulting 0.1.0

First public release. ggconsulting is an opinionated ggplot2 extension for
executive-grade consulting output: archetype themes, palettes, scales,
locale-aware label helpers, and a data-aware polish layer.

The package is experimental. The public API is being shaped against real
consulting decks, so expect breaking changes through the `0.x` series.

## Requirements

* Requires ggplot2 >= 4.0.0 and R >= 4.1. The themes are built on ggplot2
  4.x API — `theme_sub_*()` helpers, `element_geom()`, and `from_theme()`
  linkage — and will not work on ggplot2 3.x.

## Themes

* `ct_theme()` composes a theme from `palette`, `font`, `font_fallback`,
  `density`, and `context` arguments. The palette's main colour is routed
  through `element_geom(ink = ...)`, so `from_theme()`-aware geoms pick it
  up without an explicit `scale_color_*()` call.
* `theme_strategy()` — minimal, generous whitespace, navy default.
* `theme_finance()` — serif preset (Source Serif 4 → Georgia → Times New
  Roman → serif) with a regular-weight title, lighter major gridlines, and
  denser defaults (`density = "tight"`, `context = "report"`) tuned for
  printed pages rather than slides. Defaults to `finance_classic`.
* `theme_editorial()` — serif preset with an italic subtitle and a larger,
  tighter-leaded title. Defaults to `editorial_warm`.
* `ct_theme(paper = ...)` sets the figure ground. Pass `"cream"`
  (Financial Times), `"warm_grey"` (The Economist), `"white"`, or any colour
  R recognises. Because `theme_minimal()` leaves the panel background blank,
  filling the plot background alone gives a uniform ground with no
  panel-versus-plot seam. Setting `paper` also warms the major gridline to
  match. The archetypes forward it, so `theme_editorial(paper = "cream")`
  works; cream is opt-in rather than the editorial default.

## Palettes and scales

* Eleven palettes of six colours each, in three families: five strategy
  (`strategy_navy`, `strategy_emerald`, `strategy_crimson`,
  `strategy_azure`, `strategy_slate`), three finance (`finance_classic`,
  `finance_steel`, `finance_burgundy`), and three editorial
  (`editorial_warm`, `editorial_clay`, `editorial_oxide`).
* `ct_palette()` returns a palette's colours, subsets to `n`, or —
  called with no arguments — lists every available palette name.
* `scale_color_ct()` / `scale_fill_ct()` — discrete scales. When the data
  needs more levels than the palette holds, colours are interpolated and a
  warning points at the continuous scales instead.
* `scale_color_ct_c()` / `scale_fill_ct_c()` — continuous variants, with
  `direction = -1` to reverse.
* British-spelling aliases: `scale_colour_ct()`, `scale_colour_ct_c()`.
* `ct_palette_show()` — swatch preview for one palette, a custom hex
  vector, or every shipped palette faceted.

## Locale and formatters

* `ct_locale("pt-BR" | "en-US")` — session-scoped locale switch stored in
  `options(ggconsulting.locale)`. It does *not* touch `Sys.setlocale()`;
  the package ships its own month tables and formatting marks, so output
  is identical across Windows, Linux, and macOS.
* `fmt_number()` — locale-aware numbers (`1.234,5` / `1,234.5`).
* `fmt_brl()` — Brazilian Real, always `R$` with a non-breaking space
  regardless of the active locale. `style = "accounting"` wraps negatives
  in parentheses.
* `fmt_currency()` — uses the active locale's currency symbol.
* `fmt_pct()` — fraction to percent (`0.5` → `"50%"`).
* `fmt_delta()` — always-signed percentage-point deltas (`+1,2pp`).
* `fmt_month()` — `Date` / `POSIXct` to a localised month string.

## Data-aware polish

* `ct_finish()` runs after the geom layer is built, via a `ggplot_add()`
  S3 method, and inspects the plot to apply:
  - value labels above bars or beside points (`values = TRUE`)
  - reordering of a categorical x by y (`sort = "asc" | "desc"`)
  - label formatting by shortcut (`label_fmt = "brl" | "number" | "pct" |
    "delta"`) or a user-supplied function
  - highlighting of specific x values in the theme's main colour, muting
    the rest with `muted_color` (default `#A8A4A0`, a warm-leaning neutral
    that reads against both cool and warm palettes)
  - end labels on the last point of each line series (`end_labels = TRUE`),
    or only in the first panel of a faceted plot
    (`end_labels = "first_facet"`), which replaces a legend across small
    multiples
  - a filled point at each series' last observation (`end_points = TRUE`)
  - a right-hand y axis (`axis_y = "right"`), applied through
    `guide_axis()` so it leaves a `scale_y_*()` call of your own alone
  - geom-aware scale expansion (`expand = "auto"`) — headroom above
    columns, right-side room for line endpoints

  `end_labels` now accepts `Date` and `POSIXct` x aesthetics, which it
  previously rejected. Auto expansion no longer adds a second x scale over
  the one end labels set, and neither replaces an x scale supplied by the
  caller.

## Geom wrappers and defaults

* `ct_col()`, `ct_line()`, `ct_point()` — thin wrappers over the
  corresponding ggplot2 geoms with consulting defaults as formals, for
  overriding at the call site.
* `ct_set_defaults()` / `ct_unset_defaults()` apply and cleanly revert
  package-wide aesthetic defaults via `update_geom_defaults()`. Applied on
  attach; opt out with `options(ggconsulting.autoload = FALSE)`.

## Fonts

* `install_consulting_fonts()` downloads the five archetype font families
  from Google Fonts (Inter, Source Sans 3, Lato, Source Serif 4, IBM Plex
  Sans — all OFL or Apache-2.0) and installs them into a
  platform-appropriate user font directory.

  Because that writes outside the R session, it asks for confirmation
  first when run interactively and refuses to run otherwise. Pass an
  explicit `dest`, or set `options(ggconsulting.font_consent = TRUE)`, to
  install unattended.
* `has_font()` reports whether a family is available, checking both fonts
  installed on the operating system and fonts registered for the session
  with `systemfonts::register_font()`. This matters for client brand
  fonts, which are commonly registered from a file rather than installed:
  `ct_theme(font = "ClientSans")` now honours a registered `ClientSans`
  instead of falling through to the `font_fallback` chain.

## Data

* Six bundled datasets for examples and tests: `bu_quarterly`,
  `market_share`, `client_nps`, `ebitda_bridge`, `ibov_sectors`, and
  `br_macro`.

## Development

* `inst/gallery/` ships example scripts for visual QA of themes, palettes,
  geoms, and formatters. Available post-install via
  `system.file("gallery", package = "ggconsulting")`.
