# Drop-in replacements for geom_col(), geom_line(), and geom_point()

Three-line pass-throughs that ship consulting-grade defaults for
[`ggplot2::geom_col()`](https://ggplot2.tidyverse.org/reference/geom_bar.html)
`width`,
[`ggplot2::geom_line()`](https://ggplot2.tidyverse.org/reference/geom_path.html)
`linewidth`, and
[`ggplot2::geom_point()`](https://ggplot2.tidyverse.org/reference/geom_point.html)
`size`. Use them when you want the defaults baked into the call site;
plain
[`geom_line()`](https://ggplot2.tidyverse.org/reference/geom_path.html)
will also pick up linewidth from
[`ct_theme()`](https://viniciusoike.github.io/ggconsulting/reference/ct_theme.md)
/
[`theme_strategy()`](https://viniciusoike.github.io/ggconsulting/reference/theme_strategy.md)
via
[`from_theme()`](https://ggplot2.tidyverse.org/reference/aes_eval.html),
and
[`geom_point()`](https://ggplot2.tidyverse.org/reference/geom_point.html)
size is autoloaded by
[`ct_set_defaults()`](https://viniciusoike.github.io/ggconsulting/reference/ct_defaults.md).

## Usage

``` r
ct_col(..., width = 0.8)

ct_line(..., linewidth = 0.7)

ct_point(..., size = 2.5)
```

## Arguments

- ...:

  Forwarded to the underlying ggplot2 constructor.

- width:

  Column width. Defaults to 0.8 (vs ggplot2's 0.9).

- linewidth:

  Line width. Defaults to 0.7 (vs ggplot2's 0.5).

- size:

  Point size. Defaults to 2.5 (vs ggplot2's 1.5).

## Value

A ggplot2
[`ggplot2::layer()`](https://ggplot2.tidyverse.org/reference/layer.html)
object.

## Examples

``` r
library(ggplot2)
d <- data.frame(g = c("A", "B", "C"), v = c(3, 5, 2))
p_col   <- ggplot(d, aes(g, v)) + ct_col()
p_line  <- ggplot(economics, aes(date, unemploy)) + ct_line()
p_point <- ggplot(mtcars, aes(wt, mpg)) + ct_point()
```
