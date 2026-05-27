# Font utilities ----

#' Test whether a font family is installed
#'
#' Wrapper around [systemfonts::system_fonts()] used to gate font-dependent
#' code paths and tests.
#'
#' @param name Font family name as it appears in
#'   `systemfonts::system_fonts()$family`.
#' @return `TRUE` if `name` matches an installed family, `FALSE` otherwise.
#' @noRd
has_font <- function(name) {
  fonts <- systemfonts::system_fonts()
  name %in% fonts$family
}
