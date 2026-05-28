# Strategy archetype ----

#' Strategy archetype theme
#'
#' Preset path through [ct_theme()] tuned for a minimal,
#' generous-whitespace, navy-default look inspired by top-tier global
#' strategy consultancies.
#'
#' @param main_color Routed into the theme `geom` `ink` slot so unmapped
#'   geoms pick it up via `from_theme()`. Defaults to `strategy_navy[1]`.
#'   Pass any value `grDevices::col2rgb()` accepts to override. Does not
#'   affect title colour (a fixed neutral near-black).
#' @param ... Forwarded to [ct_theme()] — e.g. `density`, `context`,
#'   `base_size`.
#'
#' @return A [ggplot2::theme()] object.
#' @export
#' @examples
#' library(ggplot2)
#' p <- ggplot(mtcars, aes(wt, mpg)) +
#'   geom_point() +
#'   theme_strategy()
theme_strategy <- function(main_color = NULL, ...) {
  ct_theme(
    palette    = "strategy_navy",
    font       = "Inter",
    main_color = main_color,
    ...
  )
}
