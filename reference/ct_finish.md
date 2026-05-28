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

  For line plots: when `TRUE`, label the last point of each series with
  the group identifier.

- expand:

  `"auto"` picks geom-aware scale expansion (room above column tops,
  right-side room for line end labels); `FALSE` disables.

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
