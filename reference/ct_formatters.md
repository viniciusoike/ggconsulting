# Locale-aware label formatters

Factory functions: each returns a function compatible with
`scales::label_*` (callable on a numeric vector). Marks (thousands,
decimals) and currency symbols come from the active ggconsulting locale,
set via
[`ct_locale()`](https://viniciusoike.github.io/ggconsulting/reference/ct_locale.md).

- `fmt_number()` — plain numbers with locale separators.

- `fmt_brl()` — Brazilian Real. Always renders as `R$` regardless of
  active locale; the `locale` argument lets you override marks.

- `fmt_currency()` — uses the active locale's currency symbol.

- `fmt_pct()` — percentages, interpreting input as a fraction (`0.5` →
  `"50%"`).

- `fmt_delta()` — percentage-point-style signed deltas (`+1,2pp` /
  `-0,3pp` / `0,0pp`).

- `fmt_month()` — Date / POSIXct → localised month string.

Negatives default to a minus prefix; currency helpers also support
`style = "accounting"`, which wraps negatives in parentheses. Currency
rendering uses a non-breaking space (`U+00A0`) between symbol and number
so the pair never wraps across lines.

## Usage

``` r
fmt_number(decimals = 0, locale = NULL)

fmt_brl(decimals = 2, style = c("minus", "accounting"), locale = NULL)

fmt_currency(decimals = 2, style = c("minus", "accounting"), locale = NULL)

fmt_pct(decimals = 1, locale = NULL, accuracy = NULL)

fmt_delta(decimals = 1, suffix = "pp", locale = NULL)

fmt_month(format = c("abbr", "full"), locale = NULL)
```

## Arguments

- decimals:

  Number of decimal places.

- locale:

  Optional locale name. Defaults to the active locale.

- style:

  `"minus"` (default) or `"accounting"` for currency.

- accuracy:

  Optional explicit accuracy passed to
  [`scales::percent()`](https://scales.r-lib.org/reference/percent_format.html);
  overrides `decimals` if set.

- suffix:

  Suffix for `fmt_delta()`. Defaults to `"pp"`.

- format:

  `"abbr"` (default) or `"full"` for `fmt_month()`.

## Value

A formatter function: `function(x) character`.

## Examples

``` r
fmt_number(decimals = 1)(1234.5)
#> [1] "1.234,5"
fmt_brl()(c(1000, -500))
#> [1] "R$ 1.000,00" "-R$ 500,00" 
fmt_pct(decimals = 0)(0.5)
#> [1] "50%"
fmt_delta()(c(1.2, -0.3, 0))
#> [1] "+1,2pp" "-0,3pp" "0,0pp" 
fmt_month()(as.Date("2026-08-15"))
#> [1] "ago"
```
