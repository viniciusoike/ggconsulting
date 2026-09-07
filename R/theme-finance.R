# Finance archetype ----

#' Finance archetype theme
#'
#' Preset path through [ct_theme()] tuned for finance reports and pitch
#' books: humanist sans typography (`"Source Sans 3"` with an Inter /
#' Helvetica Neue / Arial fallback chain), no gridlines, y-axis ticks to
#' read levels against, and denser defaults (`density = "tight"`,
#' `context = "report"`) so plots read closer to a printed page than a
#' slide.
#'
#' Sans rather than serif follows the institutional chart packs the
#' archetype is drawn from, which set their exhibits in a humanist sans
#' and reserve serif for body text. Pair the bare axis with
#' `ct_finish(mirror_y = TRUE)` to repeat the ticks on the right edge,
#' which is how those references let the eye track a level across a wide
#' panel without gridlines.
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
    font          = "Source Sans 3",
    font_fallback = c("Inter", "Helvetica Neue", "Arial", "sans"),
    density       = density,
    context       = context,
    main_color    = main_color,
    ...
  )

  th +
    ggplot2::theme_sub_panel(
      grid.major.y = ggplot2::element_blank(),
      grid.major.x = ggplot2::element_blank()
    ) +
    ggplot2::theme_sub_axis_y(
      ticks = ggplot2::element_line(colour = "#1A1A1A", linewidth = 0.4),
      ticks.length = ggplot2::unit(3, "pt")
    )
}
