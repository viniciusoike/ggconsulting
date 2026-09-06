# Theme builder ----

#' Build a consulting-grade ggplot2 theme
#'
#' @description
#' `r lifecycle::badge("experimental")`
#'
#' Flexible builder behind the archetype presets ([theme_strategy()] and
#' friends). Composes [ggplot2::theme_minimal()] with executive-output
#' overrides via `theme_sub_*()` helpers, sets the theme `geom` element
#' so `from_theme()`-aware layers (e.g. [ggplot2::geom_line()]) inherit
#' the resolved linewidth and main colour, and applies the resolved
#' font with a fallback chain.
#'
#' @param palette Palette name (e.g. `"strategy_navy"`) or character
#'   vector of colours.
#' @param font Preferred font family.
#' @param font_fallback Character vector of fallback families to try if
#'   `font` is unavailable. The generic R families `"sans"`, `"serif"`,
#'   and `"mono"` are always recognised as terminal fallbacks.
#' @param density One of `"normal"`, `"tight"`, `"loose"`. Controls
#'   `panel.spacing` and axis-text margins.
#' @param context One of `"presentation"`, `"report"`, `"screen"`. Drives
#'   default `base_size` and `plot.margin`.
#' @param base_size Base font size. If `NULL`, derived from `context`.
#' @param main_color Routed into the theme `geom` element's `ink` slot,
#'   so unmapped geoms pick it up via `from_theme()`. `NULL` falls back
#'   to the palette's first colour. Title colour is a fixed neutral
#'   near-black (`#1A1A1A`); override with a follow-on `theme()` call
#'   if you want it palette-tinted.
#' @param paper Figure ground colour. `NULL` (default) leaves
#'   [ggplot2::theme_minimal()]'s white background untouched. Otherwise one
#'   of the shortcuts `"cream"`, `"warm_grey"`, `"white"`, or any colour
#'   [grDevices::col2rgb()] accepts. Because `theme_minimal()` leaves the
#'   panel background blank, filling the plot background alone gives a
#'   uniform ground with no panel-versus-plot seam. Setting `paper` also
#'   warms the major gridline to match it.
#'
#' @return A [ggplot2::theme()] object.
#' @export
#' @examples
#' library(ggplot2)
#' p <- ggplot(mtcars, aes(wt, mpg)) +
#'   geom_point() +
#'   ct_theme()
ct_theme <- function(
  palette = "strategy_navy",
  font = "Inter",
  font_fallback = c("Helvetica Neue", "Arial", "sans"),
  density = c("normal", "tight", "loose"),
  context = c("presentation", "report", "screen"),
  base_size = NULL,
  main_color = NULL,
  paper = NULL
) {
  density <- match.arg(density)
  context <- match.arg(context)

  pal_vec <- .resolve_palette(palette)
  resolved_font <- .resolve_font(font, font_fallback)
  resolved_main <- if (is.null(main_color)) pal_vec[1] else main_color
  resolved_paper <- .resolve_paper(paper)
  size <- if (is.null(base_size)) .context_base_size(context) else base_size
  margins <- .context_margins(context)
  density_bits <- .density_bits(density)

  built <-
    ggplot2::theme_minimal(base_size = size, base_family = resolved_font) +
    ggplot2::theme(
      geom = ggplot2::element_geom(
        ink = resolved_main,
        linewidth = 0.8
      ),
      line = ggplot2::element_line(linewidth = 0.4),
      rect = ggplot2::element_rect(linewidth = 0.5)
    ) +
    ggplot2::theme_sub_panel(
      grid.minor = ggplot2::element_blank(),
      grid.major.y = ggplot2::element_line(
        colour = .grid_color(resolved_paper),
        linewidth = 0.3
      ),
      grid.major.x = ggplot2::element_blank(),
      spacing = density_bits$panel_spacing
    ) +
    ggplot2::theme_sub_plot(
      title = ggplot2::element_text(
        face = "bold",
        hjust = 0,
        colour = "#1A1A1A",
        margin = ggplot2::margin(b = size * 0.4)
      ),
      title.position = "plot",
      subtitle = ggplot2::element_text(
        hjust = 0,
        colour = "#555555",
        margin = ggplot2::margin(b = size * 0.6)
      ),
      caption = ggplot2::element_text(
        hjust = 0,
        colour = "#888888",
        size = ggplot2::rel(0.85)
      ),
      caption.position = "plot",
      margin = margins
    ) +
    ggplot2::theme_sub_axis_x(
      title = ggplot2::element_text(margin = ggplot2::margin(t = size * 0.4)),
      text = ggplot2::element_text(margin = density_bits$axis_text_x),
      line = ggplot2::element_line(colour = "#1A1A1A", linewidth = 0.4),
      ticks = ggplot2::element_line(colour = "#1A1A1A", linewidth = 0.4),
      ticks.length = ggplot2::unit(3, "pt")
    ) +
    ggplot2::theme_sub_axis_y(
      title = ggplot2::element_text(margin = ggplot2::margin(r = size * 0.4)),
      text = ggplot2::element_text(margin = density_bits$axis_text_y)
    ) +
    ggplot2::theme_sub_legend(
      position = "top",
      justification = "left"
    )

  if (!is.null(resolved_paper)) {
    built <- built +
      ggplot2::theme_sub_plot(
        background = ggplot2::element_rect(fill = resolved_paper, colour = NA)
      )
  }

  attr(built, "ct_palette") <- pal_vec
  attr(built, "ct_main_color") <- resolved_main
  built
}

# Ground colour ----

# Named grounds sampled from the reference briefs: cream is the FT page
# ground, warm_grey the Economist figure ground.
.ct_papers <- c(
  cream     = "#FFF1E5",
  warm_grey = "#F0EFEB",
  white     = "#FFFFFF"
)

.resolve_paper <- function(paper, call = rlang::caller_env()) {
  if (is.null(paper)) {
    return(NULL)
  }
  if (!is.character(paper) || length(paper) != 1L) {
    cli::cli_abort(
      "{.arg paper} must be a single colour or shortcut name, not {.obj_type_friendly {paper}}.",
      call = call
    )
  }
  if (paper %in% names(.ct_papers)) {
    return(unname(.ct_papers[[paper]]))
  }
  ok <- tryCatch(
    {
      grDevices::col2rgb(paper)
      TRUE
    },
    error = function(e) FALSE
  )
  if (!ok) {
    cli::cli_abort(c(
      "{.arg paper} {.val {paper}} is not a colour R recognises.",
      "i" = "Use a hex string, an {.fn colors} name, or one of {.val {names(.ct_papers)}}."
    ), call = call)
  }
  paper
}

# Gridlines are derived from the ground so a warm paper gets a warm
# hairline. The 0.12 blend puts cream in the range sampled from FT charts;
# on white it lands within a shade of the untinted default.
.grid_color <- function(paper) {
  if (is.null(paper)) {
    return("#E5E5E5")
  }
  grDevices::rgb(
    grDevices::colorRamp(c(paper, "#1A1A1A"))(0.12),
    maxColorValue = 255
  )
}

# Internal helpers ----

.resolve_font <- function(
  primary,
  fallback = c("Helvetica Neue", "Arial", "sans")
) {
  generic <- c("sans", "serif", "mono")
  for (f in c(primary, fallback)) {
    if (f %in% generic || has_font(f)) {
      return(f)
    }
  }
  utils::tail(fallback, 1L)
}

.context_base_size <- function(context) {
  switch(context, presentation = 14, report = 10, screen = 11)
}

.context_margins <- function(context) {
  switch(
    context,
    presentation = ggplot2::margin(t = 20, r = 24, b = 16, l = 16),
    report = ggplot2::margin(t = 8, r = 12, b = 8, l = 12),
    screen = ggplot2::margin(t = 12, r = 16, b = 12, l = 16)
  )
}

.density_bits <- function(density) {
  pad <- switch(density, tight = 2, normal = 4, loose = 8)
  list(
    panel_spacing = ggplot2::unit(
      switch(density, tight = 4, normal = 8, loose = 16),
      "pt"
    ),
    axis_text_x = ggplot2::margin(t = pad),
    axis_text_y = ggplot2::margin(r = pad)
  )
}
