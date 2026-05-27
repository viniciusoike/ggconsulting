# Geom defaults ----

#' Set or restore ggconsulting aesthetic defaults
#'
#' @description
#' `ct_set_defaults()` overrides ggplot2 *aesthetic* defaults via
#' [ggplot2::update_geom_defaults()]. v0.1 sets a single override:
#' `geom_point` `size = 2.5`. `ct_unset_defaults()` restores whatever
#' values were active the first time `ct_set_defaults()` ran — *not*
#' ggplot2's untouched baseline.
#'
#' Originals are captured once into a package-private environment, so
#' repeated `ct_set_defaults()` calls are idempotent. Column width and
#' linewidth are handled elsewhere — see [ct_col()] / [ct_line()] for
#' explicit formal overrides, or apply [ct_theme()] / [theme_strategy()]
#' for linewidth via `from_theme()`.
#'
#' @return Both functions return `invisible(NULL)`.
#' @name ct_defaults
#' @examples
#' ct_set_defaults()
#' ct_unset_defaults()
NULL

#' @rdname ct_defaults
#' @export
ct_set_defaults <- function() {
  .ensure_originals_captured()
  ggplot2::update_geom_defaults("point", list(size = 2.5))
  invisible(NULL)
}

#' @rdname ct_defaults
#' @export
ct_unset_defaults <- function() {
  if (!isTRUE(.ct_env$captured)) {
    return(invisible(NULL))
  }
  ggplot2::update_geom_defaults(
    "point",
    list(size = .ct_env$originals$geom_point_size)
  )
  invisible(NULL)
}

# Capture helper ----

# ggplot2 4.x stores default_aes entries as from_theme() formulas; we
# snapshot the raw value and hand it back on revert rather than evaluating it.
.ensure_originals_captured <- function() {
  if (isTRUE(.ct_env$captured)) {
    return(invisible(NULL))
  }
  .ct_env$originals <- list(
    geom_point_size =
      utils::getFromNamespace("GeomPoint", "ggplot2")$default_aes$size
  )
  .ct_env$captured <- TRUE
  invisible(NULL)
}
