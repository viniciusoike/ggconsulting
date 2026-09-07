# Finance archetype theme

Preset path through
[`ct_theme()`](https://viniciusoike.github.io/ggconsulting/reference/ct_theme.md)
tuned for finance reports and pitch books: humanist sans typography
(`"Source Sans 3"` with an Inter / Helvetica Neue / Arial fallback
chain), no gridlines, y-axis ticks to read levels against, and denser
defaults (`density = "tight"`, `context = "report"`) so plots read
closer to a printed page than a slide.

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

## Details

Sans rather than serif follows the institutional chart packs the
archetype is drawn from, which set their exhibits in a humanist sans and
reserve serif for body text. Pair the bare axis with
`ct_finish(mirror_y = TRUE)` to repeat the ticks on the right edge,
which is how those references let the eye track a level across a wide
panel without gridlines.

## Examples

``` r
library(ggplot2)
p <- ggplot(economics, aes(date, unemploy)) +
  geom_line() +
  theme_finance()
```
