# Editorial archetype theme

Preset path through
[`ct_theme()`](https://viniciusoike.github.io/ggconsulting/reference/ct_theme.md)
tuned for analyst notes and market commentary: serif typography
(`"Source Serif 4"` with a Georgia / Times / serif fallback chain), a
slightly larger title with tighter leading, and italic subtitles for
typographic personality.

## Usage

``` r
theme_editorial(main_color = NULL, ...)
```

## Arguments

- main_color:

  Colour for the title and the theme `geom` `ink` slot. `NULL` (default)
  falls back to `editorial_warm[1]`.

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
  theme_editorial()
```
