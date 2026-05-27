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

  Colour used for the plot title. Defaults to the `strategy_navy`
  palette's primary so the title matches downstream data marks. Pass any
  value
  [`grDevices::col2rgb()`](https://rdrr.io/r/grDevices/col2rgb.html)
  accepts to override.

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
