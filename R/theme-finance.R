# Finance archetype ----

#' Finance archetype theme
#'
#' Preset path through [ct_theme()] tuned for finance reports and pitch
#' books: serif typography (`"Source Serif 4"` with a Georgia / Times /
#' serif fallback chain), regular-weight title (restrained — finance
#' reports avoid bold), and a lighter major gridline than the strategy
#' archetype.
#'
#' @param main_color Colour for the title and the theme `geom` `ink` slot.
#'   `NULL` (default) falls back to `finance_classic[1]`.
#' @param ... Forwarded to [ct_theme()] — e.g. `density`, `context`,
#'   `base_size`, or an explicit `palette` override.
#'
#' @return A [ggplot2::theme()] object.
#' @export
#' @examples
#' library(ggplot2)
#' p <- ggplot(economics, aes(date, unemploy)) +
#'   geom_line() +
#'   theme_finance()
theme_finance <- function(main_color = NULL, ...) {
  th <- ct_theme(
    palette       = "finance_classic",
    font          = "Source Serif 4",
    font_fallback = c("Georgia", "Times New Roman", "serif"),
    main_color    = main_color,
    ...
  )

  th + ggplot2::theme(
    plot.title       = ggplot2::element_text(face = "plain"),
    panel.grid.major = ggplot2::element_line(colour = "#EEEEEE", linewidth = 0.25)
  )
}
