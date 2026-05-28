# Finance archetype ----

#' Finance archetype theme
#'
#' Preset path through [ct_theme()] tuned for finance reports and pitch
#' books: serif typography (`"Source Serif 4"` with a Georgia / Times /
#' serif fallback chain), regular-weight title (restrained — finance
#' reports avoid bold), a lighter major gridline than the strategy
#' archetype, and denser defaults (`density = "tight"`,
#' `context = "report"`) so plots read closer to a printed page than a
#' slide.
#'
#' @param main_color Routed into the theme `geom` `ink` slot for
#'   `from_theme()` linkage. `NULL` (default) falls back to
#'   `finance_classic[1]`. Title colour is a fixed neutral near-black.
#' @param density Passed to [ct_theme()]. Defaults to `"tight"` — finance
#'   reports favour denser layouts than presentation slides.
#' @param context Passed to [ct_theme()]. Defaults to `"report"` — drives
#'   a smaller `base_size` and tighter `plot.margin`.
#' @param ... Forwarded to [ct_theme()] — e.g. `base_size`, or an
#'   explicit `palette` override.
#'
#' @return A [ggplot2::theme()] object.
#' @export
#' @examples
#' library(ggplot2)
#' p <- ggplot(economics, aes(date, unemploy)) +
#'   geom_line() +
#'   theme_finance()
theme_finance <- function(main_color = NULL,
                          density = "tight",
                          context = "report",
                          ...) {
  th <- ct_theme(
    palette       = "finance_classic",
    font          = "Source Serif 4",
    font_fallback = c("Georgia", "Times New Roman", "serif"),
    density       = density,
    context       = context,
    main_color    = main_color,
    ...
  )

  th + ggplot2::theme(
    plot.title       = ggplot2::element_text(face = "plain"),
    panel.grid.major = ggplot2::element_line(colour = "#EEEEEE", linewidth = 0.25)
  )
}
