# Palette preview ----

#' Preview ggconsulting palettes as a swatch
#'
#' Returns a ggplot showing palettes as colour tiles with the hex value
#' overlaid in monospace. With `palette = NULL`, every palette shipped
#' in [`.ct_palettes`][ct_palette_show] is shown faceted.
#'
#' @param palette Palette name (e.g. `"strategy_emerald"`), character
#'   vector of colours, or `NULL` (default) to show every shipped palette.
#'
#' @return A ggplot object.
#' @export
#' @examples
#' p_all  <- ct_palette_show()
#' p_one  <- ct_palette_show("strategy_emerald")
#' p_vec  <- ct_palette_show(c("#0F4D38", "#177B57", "#3DA876"))
ct_palette_show <- function(palette = NULL) {
  rows <- if (is.null(palette)) {
    Map(.palette_row, names(.ct_palettes), .ct_palettes)
  } else if (is.character(palette) && length(palette) == 1L &&
             palette %in% names(.ct_palettes)) {
    list(.palette_row(palette, .ct_palettes[[palette]]))
  } else {
    list(.palette_row("custom", .resolve_palette(palette)))
  }

  df <- do.call(rbind, rows)
  df$palette <- factor(df$palette, levels = rev(unique(df$palette)))

  ggplot2::ggplot(df, ggplot2::aes(x = .data$idx, y = .data$palette, fill = .data$hex)) +
    ggplot2::geom_tile(width = 0.95, height = 0.85) +
    ggplot2::geom_text(
      ggplot2::aes(label = .data$hex),
      colour = "white", size = 3, family = "mono", fontface = "bold"
    ) +
    ggplot2::scale_fill_identity() +
    ggplot2::scale_x_continuous(breaks = seq_len(max(df$idx)), expand = c(0, 0)) +
    ggplot2::labs(
      title = "ggconsulting palettes",
      x = NULL, y = NULL
    ) +
    ggplot2::theme_minimal(base_size = 12) +
    ggplot2::theme(
      panel.grid          = ggplot2::element_blank(),
      axis.text.y         = ggplot2::element_text(family = "mono", hjust = 1),
      axis.ticks          = ggplot2::element_blank(),
      plot.title.position = "plot"
    )
}

.palette_row <- function(name, hexes) {
  data.frame(
    palette = name,
    idx     = seq_along(hexes),
    hex     = hexes,
    stringsAsFactors = FALSE
  )
}
