# Strategy archetype theme

Preset path through
[`ct_theme()`](https://viniciusoike.github.io/ggconsulting/reference/ct_theme.md)
tuned for a minimal, generous-whitespace, navy-default look inspired by
top-tier global strategy consultancies.

## Usage

``` r
theme_strategy(main_color = NULL, ...)
```

## Arguments

- main_color:

  Routed into the theme `geom` `ink` slot so unmapped geoms pick it up
  via
  [`from_theme()`](https://ggplot2.tidyverse.org/reference/aes_eval.html).
  Defaults to `strategy_navy[1]`. Pass any value
  [`grDevices::col2rgb()`](https://rdrr.io/r/grDevices/col2rgb.html)
  accepts to override. Does not affect title colour (a fixed neutral
  near-black).

- ...:

  Forwarded to
  [`ct_theme()`](https://viniciusoike.github.io/ggconsulting/reference/ct_theme.md)
  — e.g. `density`, `context`, `base_size`.

## Value

A
[`ggplot2::theme()`](https://ggplot2.tidyverse.org/reference/theme.html)
object.

## Examples

``` r
library(ggplot2)
p <- ggplot(mtcars, aes(wt, mpg)) +
  geom_point() +
  theme_strategy()
```
