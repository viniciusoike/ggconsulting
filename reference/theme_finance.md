# Finance archetype theme

Preset path through
[`ct_theme()`](https://viniciusoike.github.io/ggconsulting/reference/ct_theme.md)
tuned for finance reports and pitch books: serif typography
(`"Source Serif 4"` with a Georgia / Times / serif fallback chain),
regular-weight title (restrained — finance reports avoid bold), and a
lighter major gridline than the strategy archetype.

## Usage

``` r
theme_finance(main_color = NULL, ...)
```

## Arguments

- main_color:

  Colour for the title and the theme `geom` `ink` slot. `NULL` (default)
  falls back to `finance_classic[1]`.

- ...:

  Forwarded to
  [`ct_theme()`](https://viniciusoike.github.io/ggconsulting/reference/ct_theme.md)
  — e.g. `density`, `context`, `base_size`, or an explicit `palette`
  override.

## Value

A
[`ggplot2::theme()`](https://ggplot2.tidyverse.org/reference/theme.html)
object.

## Examples

``` r
library(ggplot2)
p <- ggplot(economics, aes(date, unemploy)) +
  geom_line() +
  theme_finance()
```
