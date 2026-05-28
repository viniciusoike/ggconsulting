# Prompt 04: Locale and number formatters

## Context

Brazilian formatting is the default; US fallback always available. Must NOT rely on `Sys.setlocale()` — it's OS-dependent and breaks on Windows CI. Internal Portuguese month tables instead.

Design doc: `consultr_plan_v2.html` — "Locale" under ggconsulting.

## Deliverables

1. **R/locale.R**:
   - `.ct_locales` — internal list with `"pt-BR"` and `"en-US"` entries. Each has: `big_mark`, `decimal_mark`, `currency_symbol`, `currency_space` (TRUE/FALSE), `negative_style` (default `"minus"`), `month_abbr` (12-element character vector), `month_full` (12-element).
   - `ct_locale(locale = c("pt-BR", "en-US"))` — sets `options(ggconsulting.locale = locale)`. Returns the previous locale invisibly.
   - `.current_locale()` — internal getter that reads the option and falls back to `"pt-BR"`.
2. **R/format-helpers.R**:
   - `fmt_number(decimals = 0, locale = NULL)` — returns a formatter function compatible with `scales::label_*` (i.e., callable with a numeric vector). Uses the locale's `big_mark` and `decimal_mark`.
   - `fmt_brl(decimals = 2, style = c("minus", "accounting"), locale = NULL)` — currency formatter. `"accounting"` style wraps negatives in parens. Always uses BRL formatting regardless of active locale; locale arg lets you override formatting marks if needed.
   - `fmt_currency(decimals = 2, style = c("minus", "accounting"), locale = NULL)` — uses the active locale's currency symbol.
   - `fmt_pct(decimals = 1, locale = NULL, accuracy = NULL)` — percentage formatter (already-fraction or already-pct, document the behavior).
   - `fmt_delta(decimals = 1, suffix = "pp", locale = NULL)` — "+1.2pp" / "-0.3pp" style for percentage-point deltas. Always prefixed with sign.
   - `fmt_month(format = c("abbr", "full"), locale = NULL)` — for date axes. Returns a function that takes Date or POSIXct and formats month as "ago" or "agosto" depending on locale + format.
3. **Update NAMESPACE / pkgdown** — export `ct_locale`, `fmt_number`, `fmt_brl`, `fmt_currency`, `fmt_pct`, `fmt_delta`, `fmt_month`. Add a "Locale" reference section in `_pkgdown.yml`.
4. **tests/testthat/test-locale.R**:
   - `fmt_number()(1234.5)` returns `"1.234,5"` under `"pt-BR"` and `"1,234.5"` under `"en-US"`.
   - `fmt_brl()(c(1000, -500))` returns `c("R$ 1.000,00", "-R$ 500,00")`.
   - `fmt_brl(style = "accounting")(-500)` returns `"(R$ 500,00)"`.
   - `fmt_month()` on `as.Date("2026-08-15")` returns `"ago"` (pt-BR) or `"Aug"` (en-US).
   - `ct_locale("en-US")` flips the active locale and `ct_locale("pt-BR")` restores it.

## Out of scope

- Spanish, French, or other locales (only pt-BR and en-US for v0.1)
- Currency conversion between BRL and USD (out of scope entirely)
- Date format beyond month abbreviation (e.g., "Q1 2026" formatters) — defer
- Integration with `ct_finish()` (`label_fmt = "brl"` etc.) — handled in prompt 05

## Acceptance check

```r
library(ggplot2)
ct_locale("pt-BR")

ggplot(economics, aes(date, unemploy * 1000)) +
  geom_line() +
  scale_y_continuous(labels = fmt_number()) +
  scale_x_date(labels = fmt_month()) +
  theme_strategy()

# Y axis: 1.234 not 1,234. X axis: "jan", "fev", etc.

ct_locale("en-US")  # flips back to US conventions for the next plot
```

## When to ask vs proceed

**Ask before**: locking the BRL accounting-style exact spacing (`(R$ 500,00)` vs `(R$ 500,00)` — non-breaking space details).

**Proceed**: everything else — these are well-trodden conventions.
