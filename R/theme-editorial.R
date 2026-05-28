# Editorial archetype ----

#' Editorial archetype theme
#'
#' Preset path through [ct_theme()] tuned for analyst notes and market
#' commentary: serif typography (`"Source Serif 4"` with a Georgia /
#' Times / serif fallback chain), a slightly larger title with tighter
#' leading, and italic subtitles for typographic personality.
#'
#' @param main_color Routed into the theme `geom` `ink` slot for
#'   `from_theme()` linkage. `NULL` (default) falls back to
#'   `editorial_warm[1]`. Title colour is a fixed neutral near-black.
#' @param ... Forwarded to [ct_theme()] — e.g. `density`, `context`,
#'   `base_size`, or an explicit `palette` override.
#'
#' @return A [ggplot2::theme()] object.
#' @export
#' @examples
#' library(ggplot2)
#' p <- ggplot(economics, aes(date, unemploy)) +
#'   geom_line() +
#'   theme_editorial()
theme_editorial <- function(main_color = NULL, ...) {
  th <- ct_theme(
    palette       = "editorial_warm",
    font          = "Source Serif 4",
    font_fallback = c("Georgia", "Times New Roman", "serif"),
    main_color    = main_color,
    ...
  )

  th + ggplot2::theme(
    plot.title    = ggplot2::element_text(size = ggplot2::rel(1.15), lineheight = 1),
    plot.subtitle = ggplot2::element_text(face = "italic")
  )
}
