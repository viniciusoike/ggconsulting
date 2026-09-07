# Apply data-aware finishing touches to a plot

**\[experimental\]**

Companion to
[`ct_theme()`](https://viniciusoike.github.io/ggconsulting/reference/ct_theme.md)
that runs *after* the geom layer is built, so it can inspect the data +
active geom to inject value labels, sorting, highlighting, end labels,
and scale expansion. Compose with `+`, after the geoms.

## Usage

``` r
ct_finish(
  values = FALSE,
  sort = NULL,
  label_fmt = NULL,
  highlight = NULL,
  end_labels = FALSE,
  end_points = FALSE,
  axis_y = NULL,
  mirror_y = FALSE,
  expand = "auto",
  muted_color = "#A8A4A0"
)
```

## Arguments

- values:

  `TRUE` adds value labels above bars / next to points. `"auto"` adds
  them only when the first geom is a column or bar.

- sort:

  One of `"asc"`, `"desc"`, or `NULL`. When set, reorders the factor
  levels of the x aesthetic by the y aesthetic.

- label_fmt:

  Either a formatter function (anything that maps a numeric vector to a
  character vector), or one of the shortcut names `"brl"`, `"number"`,
  `"pct"`, `"delta"` resolved to the matching `fmt_*()` helper.

- highlight:

  Value(s) of the x aesthetic to emphasise. Matching bars use the active
  palette's main colour; non-matching bars use `muted_color`. Inserted
  as a `scale_*_manual()`.

- end_labels:

  For line plots: `TRUE` labels the last point of each series with the
  group identifier. `"first_facet"` draws those labels only in the first
  panel, which replaces a legend across small multiples; on an unfaceted
  plot it behaves like `TRUE`. The x aesthetic may be numeric, `Date`,
  or `POSIXct`.

- end_points:

  For line plots: when `TRUE`, draw a filled point at each series' last
  observation, under the end label.

- axis_y:

  Moves the y axis. `"right"` or `"left"`; `NULL` (default) leaves it
  where the scale puts it. Applied through
  [`ggplot2::guide_axis()`](https://ggplot2.tidyverse.org/reference/guide_axis.html),
  so it does not disturb a `scale_y_*()` call of your own.

- mirror_y:

  When `TRUE`, repeats the y-axis ticks on the opposite edge without
  labels, so the eye can track a level across a wide panel. Pairs with a
  gridline-free theme such as
  [`theme_finance()`](https://viniciusoike.github.io/ggconsulting/reference/theme_finance.md).
  Applied through
  [`ggplot2::guides()`](https://ggplot2.tidyverse.org/reference/guides.html),
  so it leaves a `scale_y_*()` call of your own alone.

- expand:

  `"auto"` picks geom-aware scale expansion (room above column tops,
  right-side room for line end labels); `FALSE` disables. Auto expansion
  defers to a positional scale you supplied yourself, so a
  `scale_y_continuous(labels = )` keeps its labels; set the expansion in
  that call when you need both.

- muted_color:

  Fill / colour used for non-highlighted categories.

## Value

A `ct_finish` object, added to a plot via `+`. The
[`ggplot_add()`](https://ggplot2.tidyverse.org/reference/update_ggplot.html)
method composes the requested layers and scales.

## Examples

``` r
library(ggplot2)
d <- data.frame(g = LETTERS[1:5], v = c(3, 8, 5, 12, 7))
p <- ggplot(d, aes(g, v)) +
  geom_col() +
  ct_finish(values = TRUE, sort = "desc", label_fmt = "brl", highlight = "D") +
  theme_strategy()
```
