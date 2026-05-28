# Set the active ggconsulting locale

Stores the choice in `options(ggconsulting.locale = ...)`. The active
locale is read by the formatter helpers
([`fmt_number()`](https://viniciusoike.github.io/ggconsulting/reference/ct_formatters.md),
[`fmt_currency()`](https://viniciusoike.github.io/ggconsulting/reference/ct_formatters.md),
[`fmt_month()`](https://viniciusoike.github.io/ggconsulting/reference/ct_formatters.md),
etc.) when their `locale` argument is `NULL`. Defaults to `"pt-BR"`;
`"en-US"` is always available.

## Usage

``` r
ct_locale(locale = c("pt-BR", "en-US"))
```

## Arguments

- locale:

  One of `"pt-BR"` or `"en-US"`.

## Value

The previous locale, invisibly. Use it to round-trip:
`old <- ct_locale("en-US"); ...; ct_locale(old)`.

## Details

Does *not* touch
[`Sys.setlocale()`](https://rdrr.io/r/base/locales.html) — that's
OS-dependent and breaks on Windows CI. ggconsulting ships its own month
tables and formatting marks instead.

## Examples

``` r
old <- ct_locale("en-US")
ct_locale(old)
```
