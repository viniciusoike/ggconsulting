# Brazilian macroeconomic indicators (monthly)

Monthly observations of five headline Brazilian macro series from
2012-03 through 2024-12. Wide format: one row per month, one column per
indicator. Snapshot frozen at 2024-12-31. Suitable for
[`theme_editorial()`](https://viniciusoike.github.io/ggconsulting/reference/theme_editorial.md)
demos and `ct_locale("pt-BR")` formatting.

## Usage

``` r
br_macro
```

## Format

A data frame with 154 rows and 6 columns:

- date:

  First day of the month (Date).

- selic:

  Meta Selic, % a.a., end-of-month (numeric).

- ipca_12m:

  IPCA accumulated over the trailing 12 months, % (numeric).

- ibc_br:

  IBC-Br activity index, seasonally adjusted, 2002=100 (numeric).

- usd_brl:

  USD/BRL exchange rate (compra), BRL per USD, end-of-month (numeric).

- unemployment:

  PNADC unemployment rate, % (numeric).

## Source

Banco Central do Brasil SGS, series 432, 13522, 24364, 1, and 24369.
Unemployment originates with IBGE PNADC and is redistributed through
SGS. Fetched via the `rbcb` package. Snapshot date: 2024-12-31. See
`data-raw/br_macro.R`.

## Details

Indicators are reported in their native units; daily series (`selic`,
`usd_brl`) are sampled at the end of each month.

## Examples

``` r
head(br_macro)
#> # A tibble: 6 × 6
#>   date       selic ipca_12m ibc_br usd_brl unemployment
#>   <date>     <dbl>    <dbl>  <dbl>   <dbl>        <dbl>
#> 1 2012-03-01  9.82     5.24   98.0    1.82          8  
#> 2 2012-04-01  9.35     5.1    98.4    1.89          7.8
#> 3 2012-05-01  8.87     4.99   99.6    2.02          7.7
#> 4 2012-06-01  8.39     4.92  100.     2.02          7.6
#> 5 2012-07-01  8.07     5.2   101.     2.05          7.5
#> 6 2012-08-01  7.85     5.24  101.     2.04          7.3
```
