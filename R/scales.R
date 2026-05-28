# Discrete + continuous scales ----

#' Consulting colour and fill scales
#'
#' @description
#' `r lifecycle::badge("experimental")`
#'
#' Discrete and continuous scales backed by ggconsulting palettes. Discrete
#' variants interpolate (with a warning) when the data has more levels than
#' the palette can hold. Continuous variants gradient across all palette
#' colours via [ggplot2::scale_color_gradientn()] /
#' [ggplot2::scale_fill_gradientn()].
#'
#' British spellings (`scale_colour_ct()`, `scale_colour_ct_c()`) are
#' provided as aliases.
#'
#' @param palette Palette name (e.g. `"strategy_navy"`) or character vector
#'   of colours.
#' @param reverse Reverse palette order before mapping. Defaults to `FALSE`.
#' @param direction `1` (default) or `-1` to reverse the continuous gradient.
#' @param ... Forwarded to the underlying ggplot2 scale constructor.
#'
#' @return A ggplot2 scale.
#' @name ct_scales
#' @examples
#' library(ggplot2)
#' p_d <- ggplot(mtcars, aes(wt, mpg, colour = factor(cyl))) +
#'   geom_point() +
#'   scale_color_ct("strategy_azure")
#' p_c <- ggplot(faithfuld, aes(waiting, eruptions, fill = density)) +
#'   geom_raster() +
#'   scale_fill_ct_c("strategy_emerald")
NULL

#' @rdname ct_scales
#' @export
scale_color_ct <- function(palette = "strategy_navy", reverse = FALSE, ...) {
  ggplot2::discrete_scale(
    aesthetics = "colour",
    palette    = .ct_discrete_palette(palette, reverse),
    ...
  )
}

#' @rdname ct_scales
#' @export
scale_colour_ct <- scale_color_ct

#' @rdname ct_scales
#' @export
scale_fill_ct <- function(palette = "strategy_navy", reverse = FALSE, ...) {
  ggplot2::discrete_scale(
    aesthetics = "fill",
    palette    = .ct_discrete_palette(palette, reverse),
    ...
  )
}

#' @rdname ct_scales
#' @export
scale_color_ct_c <- function(palette = "strategy_navy", direction = 1, ...) {
  cols <- .resolve_palette(palette)
  if (identical(direction, -1)) cols <- rev(cols)
  ggplot2::scale_color_gradientn(colours = cols, ...)
}

#' @rdname ct_scales
#' @export
scale_colour_ct_c <- scale_color_ct_c

#' @rdname ct_scales
#' @export
scale_fill_ct_c <- function(palette = "strategy_navy", direction = 1, ...) {
  cols <- .resolve_palette(palette)
  if (identical(direction, -1)) cols <- rev(cols)
  ggplot2::scale_fill_gradientn(colours = cols, ...)
}

# Internal palette closure ----

.ct_discrete_palette <- function(palette, reverse = FALSE) {
  pal <- .resolve_palette(palette)
  if (reverse) pal <- rev(pal)
  n_pal <- length(pal)

  function(n) {
    if (n <= n_pal) {
      return(pal[seq_len(n)])
    }
    cli::cli_warn(c(
      "Requested {n} colours from a palette of {n_pal}; interpolating.",
      "i" = "Consider a larger palette or a continuous scale via {.fn scale_color_ct_c}."
    ))
    grDevices::colorRampPalette(pal)(n)
  }
}
