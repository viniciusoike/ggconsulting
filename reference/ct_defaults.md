# Set or restore ggconsulting aesthetic defaults

`ct_set_defaults()` overrides ggplot2 *aesthetic* defaults via
[`ggplot2::update_geom_defaults()`](https://ggplot2.tidyverse.org/reference/update_defaults.html).
v0.1 sets a single override: `geom_point` `size = 2.5`.
`ct_unset_defaults()` restores whatever values were active the first
time `ct_set_defaults()` ran — *not* ggplot2's untouched baseline.

Originals are captured once into a package-private environment, so
repeated `ct_set_defaults()` calls are idempotent. Column width and
linewidth are handled elsewhere — see
[`ct_col()`](https://viniciusoike.github.io/ggconsulting/reference/ct_geoms.md)
/
[`ct_line()`](https://viniciusoike.github.io/ggconsulting/reference/ct_geoms.md)
for explicit formal overrides, or apply
[`ct_theme()`](https://viniciusoike.github.io/ggconsulting/reference/ct_theme.md)
/
[`theme_strategy()`](https://viniciusoike.github.io/ggconsulting/reference/theme_strategy.md)
for linewidth via
[`from_theme()`](https://ggplot2.tidyverse.org/reference/aes_eval.html).

## Usage

``` r
ct_set_defaults()

ct_unset_defaults()
```

## Value

Both functions return `invisible(NULL)`.

## Examples

``` r
ct_set_defaults()
ct_unset_defaults()
```
