# Strategy archetype ----

#' Strategy archetype theme
#'
#' Preset path through [ct_theme()] tuned for a minimal,
#' generous-whitespace, navy-default look inspired by top-tier global
#' strategy consultancies.
#'
#' @param main_color Colour used for the plot title. Defaults to the
#'   `strategy_navy` palette's primary so the title matches downstream
#'   data marks. Pass any value `grDevices::col2rgb()` accepts to override.
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
