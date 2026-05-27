# Build ggconsulting v0.1 — Prompt 01: Foundation

## Context

You are building `ggconsulting`, an opinionated ggplot2 extension for executive-grade consulting output. It ships archetype themes, palettes, scale helpers, locale-aware label helpers, and a data-aware polish layer. The full design — including every locked decision — lives in `consultr_plan_v2.html` at the repo root.

The package scaffold already exists at `/Users/viniciusreginatto/GitHub/consultr/ggconsulting/`. `usethis::create_package()` and `usethis::use_mit_license()` have already been run; DESCRIPTION has placeholder fields that need filling in.

## Required reading before writing code

1. `/Users/viniciusreginatto/GitHub/consultr/consultr_plan_v2.html` — the design source of truth. Read the **ggconsulting**, **Cross-cutting**, and **Decisions log** sections at minimum.
2. `/Users/viniciusreginatto/GitHub/consultr/ggconsulting/DESCRIPTION` — see what the scaffold gave you.

## Scope of this prompt

Phase 0 (finish package metadata) + a thin slice of Phase 1: the `ct_theme()` builder, `theme_strategy()` archetype, the public mechanical wrappers (`ct_col`, `ct_line`), narrowed autoload defaults (true aesthetics only via `update_geom_defaults()`), basic font utility, and smoke tests.

This prompt deliberately stops short of the full Phase 1. We want a runnable foundation we can dogfood on a single archetype before scaling to three.

## ⚠ Important shift since first scoping

The original plan called for setting `geom_col` width and `geom_line` linewidth via global mutation at `library()` time. **That approach is now forbidden** — see `consultr_plan_v2.html` "Geom defaults — three buckets, CRAN-safe" section. Specifically:

- **DO NOT** use `assignInNamespace()` on any ggplot2 object. CRAN policy prohibits modifying other packages' namespaces.
- **DO NOT** mutate `formals(ggplot2::geom_col)` or any similar. Same reason.
- **DO NOT** pass literal `linewidth` overrides to `update_geom_defaults("line", ...)` — in ggplot2 4.x the default is `~from_theme(linewidth)` and overriding it severs theme linkage.

The new pattern, in three buckets:

1. **Theme element**: linewidth is set inside `ct_theme()` via `theme(line = element_line(linewidth = 0.8))`. `geom_line()` picks it up through `from_theme()` automatically. No autoload, no mutation.
2. **`update_geom_defaults()`**: use this only for true aesthetics (e.g., `geom_point` size, alpha). `ct_set_defaults()` / `ct_unset_defaults()` operate via this API only.
3. **Public wrappers**: ship `ct_col()` (width override) and `ct_line()` (literal linewidth override for users who want it independent of theme). Three-line pass-throughs, exported.

## Deliverables

### Package metadata
1. **DESCRIPTION** — fill in Title, Description, Authors@R (Vinicius Reginatto, viniciusoike@gmail.com, role aut+cre), URL/BugReports placeholders (`https://github.com/viniciusoike/ggconsulting`), Encoding UTF-8, Roxygen list with `markdown = TRUE`, RoxygenNote (current). Imports: `ggplot2`, `scales`, `systemfonts`, `cli`, `rlang`. Suggests: `testthat (>= 3.0.0)`, `vdiffr`, `lifecycle`. Config/testthat/edition: 3.
2. **R/ggconsulting-package.R** — package-level documentation file via `usethis::use_package_doc()` convention (`@keywords internal`, `"_PACKAGE"` sentinel).
3. **NEWS.md** — start one with a `# ggconsulting (development version)` heading.

### Core code (in this order)
4. **R/utils-font.R** — `has_font(name)`: returns `TRUE` if `name` appears in `systemfonts::system_fonts()$family`. Used to skip font-dependent tests. Not exported initially; mark `@noRd`.
5. **R/palettes.R** — define one starter palette as an internal list: `strategy_navy` with 6 colors that read as a corporate navy family (you choose hex values; check with `ct_palette_show()` if you build it, otherwise just pick reasonable values and ask before locking).
6. **R/ct-theme.R** — `ct_theme()` builder, signature:
   ```r
   ct_theme(
     palette = "strategy_navy",
     font = "Inter",
     density = c("normal", "tight", "loose"),
     context = c("presentation", "report", "screen"),
     base_size = NULL,        # defaults derived from context if NULL
     main_color = NULL        # optional palette override
   )
   ```
   Returns a `ggplot2::theme` object built on `theme_minimal()` with consulting-grade overrides: no minor gridlines, subtle major gridlines, left-aligned plot.title, plot.title.position = "plot", and font family applied via the resolved fallback chain. **Set `line = element_line(linewidth = 0.8)` and `rect = element_rect(linewidth = 0.5)` so `geom_line()` and friends pick up theme linewidth via `from_theme()` in ggplot2 4.x — do not override linewidth via `update_geom_defaults()`.** `context` controls `base_size` defaults (presentation 14, report 10, screen 11) and `plot.margin`. `density` controls `panel.spacing` and `axis.text` margins. Font fallback chain: `c(font, "Helvetica Neue", "Arial", "sans")` — resolve to first available via `has_font()`.
7. **R/theme-strategy.R** — `theme_strategy(main_color = "navy", ...)`: thin wrapper that calls `ct_theme(palette = "strategy_navy", font = "Inter", ...)`. Pass `...` through. Export. roxygen2 docs with one `@examples` block using `mtcars` and `ggplot()`.
8. **R/ct-col-line.R** — public mechanical wrappers, exported:
   ```r
   #' @export
   ct_col <- function(..., width = 0.7) {
     ggplot2::geom_col(..., width = width)
   }

   #' @export
   ct_line <- function(..., linewidth = 0.8) {
     ggplot2::geom_line(..., linewidth = linewidth)
   }
   ```
   Document briefly: "drop-in replacements for `geom_col()` and `geom_line()` with consulting-grade defaults. Use these when you want the defaults explicitly; plain `geom_line()` will also pick up linewidth from `ct_theme()` via `from_theme()`."
9. **R/ct-defaults.R** — `ct_set_defaults()` and `ct_unset_defaults()`. Use `update_geom_defaults()` **only** (no `assignInNamespace`, no formals mutation). Use a package-level environment (created in zzz) to store originals at first call. **For v0.1 foundation: just set `geom_point` `size = 2.5`** as a small, true-aesthetic example to validate the round-trip mechanism. Other true-aesthetic defaults can be added later. Honest revert: `ct_unset_defaults()` restores whatever was there before `ct_set_defaults()` first ran, not ggplot2 baseline.
10. **R/zzz.R** — `.onAttach()` hook:
    - Honor `options("ggconsulting.autoload")` — default TRUE
    - If TRUE: call `ct_set_defaults()` and print a `cli::cli_inform()` message (exact wording TBD — ask before locking):
      ```
      v ggconsulting set ggplot2 aesthetic defaults
      i Opt out: ct_unset_defaults() or options(ggconsulting.autoload = FALSE)
      i Column width and linewidth: use ct_col() / ct_line(), or apply ct_theme()/theme_strategy() for linewidth via from_theme()
      ```
    - Create the package-level environment for storing defaults

### Tests
11. **tests/testthat/setup.R** — empty for now.
12. **tests/testthat/test-ct-theme.R** — smoke tests:
    - `ct_theme()` returns an object inheriting from `"theme"` and `"gg"`
    - `theme_strategy()` returns an object inheriting from `"theme"` and `"gg"`
    - `ct_theme(base_size = 20)` produces a theme with `text$size == 20`
    - `ct_theme()` sets `line` element with linewidth ≈ 0.8
    - Skip font-dependent assertions if `!has_font("Inter")`
13. **tests/testthat/test-wrappers.R** — smoke tests for `ct_col` / `ct_line`:
    - Both return objects inheriting from `"Layer"`
    - `ct_col()` produces a layer whose stat has `width = 0.7` by default
    - User can override: `ct_col(width = 0.9)` carries through
14. **tests/testthat/test-defaults.R** — smoke tests for `ct_set_defaults` / `ct_unset_defaults`:
    - `ct_set_defaults()` then `ct_unset_defaults()` returns `geom_point`'s default `size` to the pre-set value
    - Round-trip doesn't error
    - **Do not** add tests that depend on `assignInNamespace` or formals mutation — those patterns are forbidden

### Verification
15. After implementation, run from the ggconsulting/ directory:
    - `devtools::document()` — should produce clean Rd files
    - `devtools::load_all()` — should print the autoload message
    - `devtools::test()` — should pass
    - Render two sample plots manually to eyeball:
      - `ggplot(mtcars, aes(wt, mpg)) + geom_point() + theme_strategy()` — confirm the theme visibly differs from `theme_grey()`
      - `ggplot(economics, aes(date, unemploy)) + geom_line() + theme_strategy()` — confirm the line is thicker than default ggplot (proves `from_theme(linewidth)` linkage works)
    - `R CMD check --as-cran` should not flag any namespace-modification or non-API usage

## Locked decisions to honor

These are decided in `consultr_plan_v2.html`. Do not re-litigate them; if you find yourself wanting to, raise it as a question instead.

- **License**: MIT (already set up)
- **Imports**: ruthlessly minimal — `ggplot2`, `scales`, `systemfonts`, `cli`, `rlang` only. No `dplyr`, `purrr`, or `tidyselect`.
- **Font tooling**: `systemfonts` (ragg-aligned), not `showtext` or `extrafont`
- **Geom defaults — three buckets, no namespace mutation**:
  - Theme element (linewidth, rect borders) → inside `ct_theme()` via `theme(line = ...)`
  - `update_geom_defaults()` → true aesthetics only (size, alpha) — autoload via `ct_set_defaults()` + opt-out
  - Public wrappers `ct_col()` / `ct_line()` → formal-argument overrides (width, literal linewidth)
- **Forbidden**: `assignInNamespace()` on ggplot2 objects; mutating `formals(ggplot2::geom_*)`; literal-value overrides for `linewidth` via `update_geom_defaults("line", ...)` in ggplot2 4.x (severs `from_theme()` linkage)
- **Theme API**: `ct_theme()` is the builder; archetypes (`theme_strategy`, etc.) are preset paths
- **Context arg**: single theme with `context = c("presentation", "report", "screen")` — not separate theme functions per output medium
- **Naming**: generic function names, never firm-named (`theme_strategy` not `theme_bcg`)
- **Lifecycle**: `ct_theme()` marked `@lifecycle experimental` via roxygen

## Style conventions

- **Section headers in R files**: use RStudio-style — `# Section ----`, `## Subsection ----`, with trailing dashes filling to ~76 chars. Never `===` box-style comments.
- **roxygen2**: keep docstrings tight. Title (one line), one-paragraph description, `@param` for each arg, one `@examples` block. Use markdown formatting (`markdown = TRUE` in DESCRIPTION).
- **No defensive comments**: only write a comment when the WHY is non-obvious. Don't narrate what the code does.
- **User messages**: `cli::cli_inform()` / `cli::cli_warn()` / `cli::cli_abort()` — never bare `message()` / `warning()` / `stop()`
- **Function naming**: `ct_*` for utilities (`ct_theme`, `ct_set_defaults`), `theme_*` for themes, `.ct_*` or simply unexported for internal helpers
- **Tests**: testthat 3 conventions — `expect_*` only inside `test_that()`, self-sufficient tests, use `skip_if_not()` liberally for font-dependent checks

## When to ask vs proceed

**Proceed without asking** for implementation details that follow from the design doc or standard R package conventions.

**Ask before**:
- Picking the 6 hex values for the `strategy_navy` palette
- Wording of the autoload message (cli format and exact phrasing)
- Any deviation from the `ct_theme()` signature above
- Any deviation from the `ct_col` / `ct_line` wrapper signatures
- Adding any `update_geom_defaults()` call beyond `geom_point` `size = 2.5` (the foundation example)

## Acceptance criteria

1. `devtools::document()` produces no warnings
2. `devtools::load_all()` prints the autoload message
3. `devtools::test()` passes (all tests, font-dependent ones may skip)
4. `devtools::check()` passes with at most NOTEs for things outside this prompt's scope (e.g., missing README.md from README.Rmd not yet rendered)
5. A manual eyeball test: `ggplot(mtcars, aes(wt, mpg)) + geom_point() + theme_strategy()` looks visibly more polished than the default

## Out of scope (handled in later prompts)

- `theme_finance()`, `theme_editorial()`, additional palettes
- `scale_color_ct()`, `scale_fill_ct()`
- `ct_finish()` polish layer
- Locale helpers (`ct_locale`, `fmt_brl`, Portuguese month tables)
- `install_consulting_fonts()`
- vdiffr snapshot suite
- Vignettes
- pkgdown site setup
- README polish (gallery, examples)
- Reference catalog in `data-raw/references/`

## Final note

If anything in the design doc seems ambiguous, prefer asking over guessing — these early API shapes are load-bearing for everything that follows.
