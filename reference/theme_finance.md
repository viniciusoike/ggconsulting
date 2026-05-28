# Finance archetype theme

Preset path through
[`ct_theme()`](https://viniciusoike.github.io/ggconsulting/reference/ct_theme.md)
tuned for finance reports and pitch books: serif typography
(`"Source Serif 4"` with a Georgia / Times / serif fallback chain),
regular-weight title (restrained — finance reports avoid bold), a
lighter major gridline than the strategy archetype, and denser defaults
(`density = "tight"`, `context = "report"`) so plots read closer to a
printed page than a slide.

## Usage

``` r
theme_finance(main_color = NULL, density = "tight", context = "report", ...)
```

## Arguments

- main_color:

  Routed into the theme `geom` `ink` slot for
  [`from_theme()`](https://ggplot2.tidyverse.org/reference/aes_eval.html)
  linkage. `NULL` (default) falls back to `finance_classic[1]`. Title
  colour is a fixed neutral near-black.

- density:

  Passed to
  [`ct_theme()`](https://viniciusoike.github.io/ggconsulting/reference/ct_theme.md).
  Defaults to `"tight"` — finance reports favour denser layouts than
  presentation slides.

- context:

  Passed to
  [`ct_theme()`](https://viniciusoike.github.io/ggconsulting/reference/ct_theme.md).
  Defaults to `"report"` — drives a smaller `base_size` and tighter
  `plot.margin`.

- ...:

  Forwarded to
  [`ct_theme()`](https://viniciusoike.github.io/ggconsulting/reference/ct_theme.md)
  — e.g. `base_size`, or an explicit `palette` override.

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
