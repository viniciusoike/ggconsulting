# Data-aware polish ----

#' Apply data-aware finishing touches to a plot
#'
#' @description
#' `r lifecycle::badge("experimental")`
#'
#' Companion to [ct_theme()] that runs *after* the geom layer is built,
#' so it can inspect the data + active geom to inject value labels,
#' sorting, highlighting, end labels, and scale expansion. Compose with
#' `+`, after the geoms.
#'
#' @param values `TRUE` adds value labels above bars / next to points.
#'   `"auto"` adds them only when the first geom is a column or bar.
#' @param sort One of `"asc"`, `"desc"`, or `NULL`. When set, reorders
#'   the factor levels of the x aesthetic by the y aesthetic.
#' @param label_fmt Either a formatter function (anything that maps a
#'   numeric vector to a character vector), or one of the shortcut names
#'   `"brl"`, `"number"`, `"pct"`, `"delta"` resolved to the matching
#'   `fmt_*()` helper.
#' @param highlight Value(s) of the x aesthetic to emphasise. Matching
#'   bars use the active palette's main colour; non-matching bars use
#'   `muted_color`. Inserted as a `scale_*_manual()`.
#' @param end_labels For line plots: when `TRUE`, label the last point of
#'   each series with the group identifier.
#' @param expand `"auto"` picks geom-aware scale expansion
#'   (room above column tops, right-side room for line end labels);
#'   `FALSE` disables.
#' @param muted_color Fill / colour used for non-highlighted categories.
#'
#' @return A `ct_finish` object, added to a plot via `+`. The
#'   `ggplot_add()` method composes the requested layers and scales.
#' @export
#' @examples
#' library(ggplot2)
#' d <- data.frame(g = LETTERS[1:5], v = c(3, 8, 5, 12, 7))
#' p <- ggplot(d, aes(g, v)) +
#'   geom_col() +
#'   ct_finish(values = TRUE, sort = "desc", label_fmt = "brl", highlight = "D") +
#'   theme_strategy()
ct_finish <- function(values     = FALSE,
                      sort       = NULL,
                      label_fmt  = NULL,
                      highlight  = NULL,
                      end_labels = FALSE,
                      expand     = "auto",
                      muted_color = "#A8A4A0") {
  if (!is.null(sort) && !sort %in% c("asc", "desc")) {
    cli::cli_abort(
      "{.arg sort} must be {.val NULL}, {.val asc}, or {.val desc}; got {.val {sort}}."
    )
  }

  structure(
    list(
      values      = values,
      sort        = sort,
      label_fmt   = .resolve_label_fmt(label_fmt),
      highlight   = highlight,
      end_labels  = isTRUE(end_labels),
      expand      = expand,
      muted_color = muted_color
    ),
    class = "ct_finish"
  )
}

# ggplot_add dispatch ----

#' @exportS3Method ggplot2::ggplot_add
ggplot_add.ct_finish <- function(object, plot, object_name, ...) {
  geom_info <- .detect_first_geom(plot)

  if (!is.null(object$sort)) {
    plot <- .ct_apply_sort(plot, geom_info, object$sort)
  }

  if (!is.null(object$highlight)) {
    plot <- .ct_apply_highlight(plot, geom_info, object$highlight, object$muted_color)
  }

  if (isTRUE(object$values) ||
      (identical(object$values, "auto") &&
       geom_info$type %in% c("GeomCol", "GeomBar"))) {
    plot <- .ct_add_value_labels(plot, geom_info, object$label_fmt)
  }

  if (isTRUE(object$end_labels) &&
      geom_info$type %in% c("GeomLine", "GeomPath")) {
    plot <- .ct_add_end_labels(plot, geom_info)
  }

  if (!identical(object$expand, FALSE)) {
    plot <- .ct_apply_expansion(plot, geom_info, object$expand)
  }

  plot
}

# Internal helpers ----

.resolve_label_fmt <- function(fmt) {
  if (is.null(fmt)) {
    return(function(x) format(x))
  }
  if (is.function(fmt)) {
    return(fmt)
  }
  if (is.character(fmt) && length(fmt) == 1L) {
    known <- c("brl", "number", "pct", "delta")
    if (!fmt %in% known) {
      cli::cli_abort(c(
        "Unknown {.arg label_fmt} {.val {fmt}}.",
        "i" = "Use one of {.val {known}} or pass a function."
      ))
    }
    return(switch(fmt,
      brl    = fmt_brl(),
      number = fmt_number(),
      pct    = fmt_pct(),
      delta  = fmt_delta()
    ))
  }
  cli::cli_abort("{.arg label_fmt} must be {.val NULL}, a known shortcut, or a function.")
}

.detect_first_geom <- function(plot) {
  layers <- plot$layers
  if (length(layers) == 0L) {
    return(list(type = NA_character_, layer = NULL))
  }
  for (lyr in layers) {
    cls <- class(lyr$geom)[1L]
    if (!cls %in% c("GeomBlank")) {
      return(list(type = cls, layer = lyr))
    }
  }
  list(type = NA_character_, layer = NULL)
}

.aes_var <- function(plot, layer, aes_name) {
  m <- layer$mapping
  if (is.null(m) || !aes_name %in% names(m)) {
    m <- plot$mapping
  }
  if (is.null(m) || !aes_name %in% names(m)) {
    return(NULL)
  }
  rlang::as_name(m[[aes_name]])
}

.ct_apply_sort <- function(plot, geom_info, direction) {
  if (is.null(geom_info$layer)) return(plot)
  x_var <- .aes_var(plot, geom_info$layer, "x")
  y_var <- .aes_var(plot, geom_info$layer, "y")
  d <- plot$data
  if (is.null(x_var) || is.null(y_var) || is.null(d) || nrow(d) == 0L) {
    return(plot)
  }
  if (!is.numeric(d[[y_var]])) return(plot)

  agg <- stats::aggregate(
    d[[y_var]],
    by = list(.x = as.character(d[[x_var]])),
    FUN = sum,
    na.rm = TRUE
  )
  names(agg)[2] <- ".y"
  agg <- agg[order(agg$.y, decreasing = direction == "desc"), ]

  d[[x_var]] <- factor(as.character(d[[x_var]]), levels = agg$.x)
  plot$data <- d
  plot
}

.ct_apply_highlight <- function(plot, geom_info, highlight, muted_color) {
  if (is.null(geom_info$layer)) return(plot)
  x_var <- .aes_var(plot, geom_info$layer, "x")
  d <- plot$data
  if (is.null(x_var) || is.null(d)) return(plot)

  aes_target <- if (geom_info$type %in% c("GeomCol", "GeomBar")) "fill" else "colour"
  main_color <- attr(plot$theme, "ct_main_color")
  if (is.null(main_color)) main_color <- "#1F4E79"

  values <- unique(as.character(d[[x_var]]))
  highlight_chr <- as.character(highlight)
  cols <- stats::setNames(
    ifelse(values %in% highlight_chr, main_color, muted_color),
    values
  )

  plot$mapping[[aes_target]] <- rlang::sym(x_var)

  if (aes_target == "fill") {
    plot <- plot + ggplot2::scale_fill_manual(values = cols, guide = "none")
  } else {
    plot <- plot + ggplot2::scale_color_manual(values = cols, guide = "none")
  }
  plot
}

.ct_add_value_labels <- function(plot, geom_info, label_fmt) {
  if (is.null(geom_info$layer)) return(plot)
  y_var <- .aes_var(plot, geom_info$layer, "y")
  if (is.null(y_var)) return(plot)

  vjust <- if (geom_info$type %in% c("GeomCol", "GeomBar")) -0.4 else -0.8
  fmt <- label_fmt
  plot + ggplot2::geom_text(
    ggplot2::aes(label = fmt(.data[[y_var]])),
    vjust = vjust,
    size  = 3
  )
}

.ct_add_end_labels <- function(plot, geom_info) {
  if (is.null(geom_info$layer)) return(plot)
  x_var <- .aes_var(plot, geom_info$layer, "x")
  group_var <- .aes_var(plot, geom_info$layer, "colour")
  if (is.null(group_var)) group_var <- .aes_var(plot, geom_info$layer, "group")
  if (is.null(x_var) || is.null(group_var)) return(plot)

  d <- plot$data
  ends <- do.call(rbind, lapply(split(d, d[[group_var]]), function(grp) {
    grp[which.max(grp[[x_var]]), , drop = FALSE]
  }))

  plot + ggplot2::geom_text(
    data = ends,
    ggplot2::aes(label = .data[[group_var]]),
    hjust = 0,
    nudge_x = 0,
    size = 3,
    show.legend = FALSE
  )
}

.ct_apply_expansion <- function(plot, geom_info, expand) {
  if (!identical(expand, "auto")) {
    return(plot)
  }
  if (geom_info$type %in% c("GeomCol", "GeomBar")) {
    return(plot + ggplot2::scale_y_continuous(expand = ggplot2::expansion(mult = c(0, 0.15))))
  }
  if (geom_info$type %in% c("GeomLine", "GeomPath") && !is.null(geom_info$layer)) {
    x_var <- .aes_var(plot, geom_info$layer, "x")
    if (!is.null(x_var) && !is.null(plot$data) &&
        inherits(plot$data[[x_var]], c("Date", "POSIXt"))) {
      return(plot + ggplot2::scale_x_date(expand = ggplot2::expansion(mult = c(0, 0.08))))
    }
  }
  plot
}
