# Mechanical wrappers ----

#' Drop-in replacements for geom_col(), geom_line(), and geom_point()
#'
#' @description
#' Three-line pass-throughs that ship consulting-grade defaults for
#' [ggplot2::geom_col()] `width`, [ggplot2::geom_line()] `linewidth`, and
#' [ggplot2::geom_point()] `size`. Use them when you want the defaults
#' baked into the call site; plain `geom_line()` will also pick up
#' linewidth from [ct_theme()] / [theme_strategy()] via `from_theme()`,
#' and `geom_point()` size is autoloaded by [ct_set_defaults()].
#'
#' @param ... Forwarded to the underlying ggplot2 constructor.
#' @param width Column width. Defaults to 0.8 (vs ggplot2's 0.9).
#' @param linewidth Line width. Defaults to 0.7 (vs ggplot2's 0.5).
#' @param size Point size. Defaults to 2.5 (vs ggplot2's 1.5).
#'
#' @return A ggplot2 [ggplot2::layer()] object.
#' @name ct_geoms
#' @examples
#' library(ggplot2)
#' d <- data.frame(g = c("A", "B", "C"), v = c(3, 5, 2))
#' p_col   <- ggplot(d, aes(g, v)) + ct_col()
#' p_line  <- ggplot(economics, aes(date, unemploy)) + ct_line()
#' p_point <- ggplot(mtcars, aes(wt, mpg)) + ct_point()
NULL

#' @rdname ct_geoms
#' @export
ct_col <- function(..., width = 0.8) {
  ggplot2::geom_col(..., width = width)
}

#' @rdname ct_geoms
#' @export
ct_line <- function(..., linewidth = 0.7) {
  ggplot2::geom_line(..., linewidth = linewidth)
}

#' @rdname ct_geoms
#' @export
ct_point <- function(..., size = 2.5) {
  ggplot2::geom_point(..., size = size)
}
