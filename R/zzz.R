# Package state ----

.ct_env <- new.env(parent = emptyenv())

# Load hooks ----

.onLoad <- function(libname, pkgname) {
  .ct_env$captured <- FALSE
  .ct_env$originals <- list()
}

.onAttach <- function(libname, pkgname) {
  if (isFALSE(getOption("ggconsulting.autoload", TRUE))) {
    return(invisible(NULL))
  }
  ct_set_defaults()
  packageStartupMessage(cli::format_message(c(
    "v" = "ggconsulting set ggplot2 aesthetic defaults",
    "i" = "Opt out: {.code ct_unset_defaults()} or {.code options(ggconsulting.autoload = FALSE)}",
    "i" = "Column width / linewidth: use {.code ct_col()} / {.code ct_line()}, or apply a {.code theme_*()} archetype for linewidth via {.code from_theme()}"
  )))
}
