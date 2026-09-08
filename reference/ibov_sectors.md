# Monthly B3 sector indices

Monthly closing values and total monthly return for the Ibovespa (IBOV)
and six B3 sector indices, covering 2020-01 through 2024-12. Snapshot
frozen at 2024-12-31. Long format: one row per (`sector_index`, month).
Suitable for
[`theme_finance()`](https://viniciusoike.github.io/ggconsulting/reference/theme_finance.md)
demos and small-multiples.

## Usage

``` r
ibov_sectors
```

## Format

A data frame with ~420 rows and 4 columns:

- date:

  First day of the month (Date).

- sector_index:

  Factor with 7 levels: IBOV, IFNC, INDX, IMAT, IEEX, ICON, IMOB.

- close:

  End-of-month index level (numeric).

- return_m:

  Monthly arithmetic return, fraction (numeric); `NA` for the first
  month of each series.

## Source

B3 S.A. – Brasil, Bolsa, Balcão, historical index series for the
Ibovespa and B3 sector indices, fetched via the `rb3` package. The
snapshot ends on 2024-12-31; `close` and `return_m` are transformed or
derived in this repository. B3 does not endorse this package. See
`data-raw/ibov_sectors.R` and
<https://www.b3.com.br/pt_br/market-data-e-indices/indices/indices-de-segmentos-e-setoriais/>.

## Examples

``` r
head(ibov_sectors)
#> # A tibble: 6 × 4
#>   date       sector_index   close return_m
#>   <date>     <fct>          <dbl>    <dbl>
#> 1 2019-12-01 IBOV         115645.  NA     
#> 2 2020-01-01 IBOV         113761.  -0.0163
#> 3 2020-02-01 IBOV         104172.  -0.0843
#> 4 2020-03-01 IBOV          73020.  -0.299 
#> 5 2020-04-01 IBOV          80506.   0.102 
#> 6 2020-05-01 IBOV          87403.   0.0857
```
