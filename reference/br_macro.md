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

  Selic accumulated in the month, annualized using base 252, % a.a.
  (numeric).

- ipca_12m:

  IPCA accumulated over the trailing 12 months, % (numeric).

- ibc_br:

  IBC-Br activity index, seasonally adjusted, 2002=100 (numeric).

- usd_brl:

  USD/BRL exchange rate (sale), BRL per USD, end-of-month (numeric).

- unemployment:

  PNADC unemployment rate, % (numeric).

## Source

Banco Central do Brasil, Sistema Gerenciador de Séries Temporais (SGS),
series 4189, 13522, 24364, 3696, and 24369. Series 24369 is PNADC data
from IBGE redistributed through SGS. Fetched via the `rbcb` package. The
snapshot ends on 2024-12-31; values are rounded and transformed in this
repository, and this is not an official current BCB or IBGE release. See
`data-raw/br_macro.R` and <https://www3.bcb.gov.br/sgspub/>.

## Details

All source series are monthly. The `usd_brl` series is the BCB sale rate
at the end of the period; dates are normalized to the first day of each
month in this snapshot.

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
