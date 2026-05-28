# Consulting colour and fill scales

**\[experimental\]**

Discrete and continuous scales backed by ggconsulting palettes. Discrete
variants interpolate (with a warning) when the data has more levels than
the palette can hold. Continuous variants gradient across all palette
colours via
[`ggplot2::scale_color_gradientn()`](https://ggplot2.tidyverse.org/reference/scale_gradient.html)
/
[`ggplot2::scale_fill_gradientn()`](https://ggplot2.tidyverse.org/reference/scale_gradient.html).

British spellings (`scale_colour_ct()`, `scale_colour_ct_c()`) are
provided as aliases.

## Usage

``` r
scale_color_ct(palette = "strategy_navy", reverse = FALSE, ...)

scale_colour_ct(palette = "strategy_navy", reverse = FALSE, ...)

scale_fill_ct(palette = "strategy_navy", reverse = FALSE, ...)

scale_color_ct_c(palette = "strategy_navy", direction = 1, ...)

scale_colour_ct_c(palette = "strategy_navy", direction = 1, ...)

scale_fill_ct_c(palette = "strategy_navy", direction = 1, ...)
```

## Arguments

- palette:

  Palette name (e.g. `"strategy_navy"`) or character vector of colours.

- reverse:

  Reverse palette order before mapping. Defaults to `FALSE`.

- ...:

  Forwarded to the underlying ggplot2 scale constructor.

- direction:

  `1` (default) or `-1` to reverse the continuous gradient.

## Value

A ggplot2 scale.

## Examples

``` r
library(ggplot2)
p_d <- ggplot(mtcars, aes(wt, mpg, colour = factor(cyl))) +
  geom_point() +
  scale_color_ct("strategy_azure")
p_c <- ggplot(faithfuld, aes(waiting, eruptions, fill = density)) +
  geom_raster() +
  scale_fill_ct_c("strategy_emerald")
```
