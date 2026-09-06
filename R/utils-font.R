# Font utilities ----

#' Test whether a font family is available
#'
#' Used to gate font-dependent code paths and tests, and by `ct_theme()`
#' to walk its `font_fallback` chain.
#'
#' Checks both font tables systemfonts maintains: families installed on
#' the operating system ([systemfonts::system_fonts()]) *and* families
#' registered for the current session with
#' [systemfonts::register_font()] ([systemfonts::registry_fonts()]).
#' Registered fonts do not appear in the system table, so checking only
#' that one would silently reject a corporate font a user had registered
#' from a file rather than installed.
#'
#' @param name Font family name, as it appears in the `family` column of
#'   `systemfonts::system_fonts()` or `systemfonts::registry_fonts()`.
#' @return `TRUE` if `name` matches an available family, `FALSE`
#'   otherwise. Vectorised over `name`.
#' @export
#' @examples
#' has_font("Arial")
#'
#' # Registered fonts count as available, so a client brand font you
#' # register from a file can be used by name:
#' \dontrun{
#' systemfonts::register_font("ClientSans", plain = "~/fonts/ClientSans.ttf")
#' has_font("ClientSans")
#' ct_theme(font = "ClientSans")
#' }
has_font <- function(name) {
  name %in% .available_font_families()
}

# Both tables: OS-installed families and session-registered ones.
.available_font_families <- function() {
  unique(c(
    systemfonts::system_fonts()$family,
    systemfonts::registry_fonts()$family
  ))
}

# Font URL catalog ----

.font_urls <- function() {
  base <- "https://github.com/google/fonts/raw/main/ofl"
  list(
    "Inter" = c(
      "Inter.ttf"        = paste0(base, "/inter/Inter%5Bopsz,wght%5D.ttf"),
      "Inter-Italic.ttf" = paste0(base, "/inter/Inter-Italic%5Bopsz,wght%5D.ttf")
    ),
    "Source Sans 3" = c(
      "SourceSans3.ttf"        = paste0(base, "/sourcesans3/SourceSans3%5Bwght%5D.ttf"),
      "SourceSans3-Italic.ttf" = paste0(base, "/sourcesans3/SourceSans3-Italic%5Bwght%5D.ttf")
    ),
    "Lato" = c(
      "Lato-Regular.ttf" = paste0(base, "/lato/Lato-Regular.ttf"),
      "Lato-Bold.ttf"    = paste0(base, "/lato/Lato-Bold.ttf"),
      "Lato-Italic.ttf"  = paste0(base, "/lato/Lato-Italic.ttf"),
      "Lato-Light.ttf"   = paste0(base, "/lato/Lato-Light.ttf")
    ),
    "Source Serif 4" = c(
      "SourceSerif4.ttf"        = paste0(base, "/sourceserif4/SourceSerif4%5Bopsz,wght%5D.ttf"),
      "SourceSerif4-Italic.ttf" = paste0(base, "/sourceserif4/SourceSerif4-Italic%5Bopsz,wght%5D.ttf")
    ),
    "IBM Plex Sans" = c(
      "IBMPlexSans.ttf"        = paste0(base, "/ibmplexsans/IBMPlexSans%5Bwdth,wght%5D.ttf"),
      "IBMPlexSans-Italic.ttf" = paste0(base, "/ibmplexsans/IBMPlexSans-Italic%5Bwdth,wght%5D.ttf")
    )
  )
}

# Font installer ----

#' Install consulting fonts from Google Fonts
#'
#' Downloads and installs the font families used by the three archetype
#' themes ([theme_strategy()], [theme_finance()], [theme_editorial()]).
#' All fonts are OFL or Apache-2.0 licensed.
#'
#' Variable-weight families (Inter, Source Sans 3, Source Serif 4,
#' IBM Plex Sans) are downloaded as variable `.ttf` files containing all
#' weights (Light through Bold and beyond). Lato is downloaded as four
#' static `.ttf` files (Regular, Bold, Italic, Light).
#'
#' @param fonts Character vector of family names to install, or `NULL`
#'   (default) for the full set: Inter, Source Sans 3, Lato,
#'   Source Serif 4, IBM Plex Sans. Validated against the known catalog.
#' @param dest Destination directory. `NULL` (default) uses a
#'   platform-appropriate user font directory: `~/Library/Fonts` on
#'   macOS, `~/.local/share/fonts` on Linux, or a session tempdir on
#'   Windows (with [systemfonts::register_font()] for the active session).
#' @param quiet Suppress informational messages. Errors are always
#'   emitted. Defaults to `FALSE`.
#'
#' @section Consent:
#' Installing to the default destination writes font files into your home
#' directory and downloads roughly 9 MB from the network. Because that is
#' outside the R session, this function never does it silently: in an
#' interactive session it asks for confirmation first, and in a
#' non-interactive one it aborts. To install unattended, either pass an
#' explicit `dest` or set `options(ggconsulting.font_consent = TRUE)`.
#' No confirmation is asked when `dest` is supplied, since the caller has
#' then named the directory themselves.
#'
#' @return Invisibly, a character vector of installed file paths.
#' @export
#' @examples
#' \dontrun{
#' install_consulting_fonts()
#' install_consulting_fonts("Inter")
#'
#' # Unattended, into a directory you choose:
#' install_consulting_fonts("Inter", dest = tempdir())
#' }
install_consulting_fonts <- function(fonts = NULL, dest = NULL, quiet = FALSE) {
  catalog <- .font_urls()

  if (is.null(fonts)) {
    fonts <- names(catalog)
  }

  unknown <- setdiff(fonts, names(catalog))
  if (length(unknown) > 0L) {
    cli::cli_abort(c(
      "Unknown font famil{?y/ies}: {.val {unknown}}.",
      "i" = "Available: {.val {names(catalog)}}."
    ))
  }

  if (is.null(dest)) {
    dest <- .default_font_dir()
    .confirm_font_install(dest, fonts)
  }

  if (!dir.exists(dest)) {
    dir.create(dest, recursive = TRUE)
  }

  is_windows <- .Platform$OS.type == "windows"
  installed <- character()
  skipped <- character()

  for (family in fonts) {
    urls <- catalog[[family]]
    for (i in seq_along(urls)) {
      local_file <- names(urls)[i]
      dest_path <- file.path(dest, local_file)

      if (file.exists(dest_path)) {
        skipped <- c(skipped, local_file)
        next
      }

      tryCatch(
        utils::download.file(urls[i], dest_path, mode = "wb", quiet = TRUE),
        error = function(e) {
          cli::cli_abort(
            "Failed to download {.file {local_file}}: {conditionMessage(e)}"
          )
        }
      )
      installed <- c(installed, dest_path)
    }

    if (is_windows) {
      plain <- file.path(dest, names(urls)[1])
      if (file.exists(plain)) {
        systemfonts::register_font(name = family, plain = plain)
      }
    }
  }

  if (length(installed) > 0L) {
    systemfonts::reset_font_cache()
  }

  if (!isTRUE(quiet)) {
    if (length(installed) > 0L) {
      cli::cli_inform(c(
        "v" = "Installed {length(installed)} font file{?s} to {.path {dest}}.",
        " " = "Families: {.val {fonts}}."
      ))
    }
    if (length(skipped) > 0L) {
      cli::cli_inform(c(
        "i" = "Skipped {length(skipped)} file{?s} already present: {.file {skipped}}."
      ))
    }
    if (is_windows) {
      cli::cli_inform(c(
        "!" = "Windows: fonts registered for this R session only.",
        "i" = "To install permanently, copy files from {.path {dest}} to your system Fonts folder."
      ))
    }
  }

  invisible(installed)
}

# Platform font directory ----
.default_font_dir <- function() {
  sys <- Sys.info()[["sysname"]]
  switch(sys,
    Darwin  = path.expand("~/Library/Fonts"),
    Linux   = path.expand("~/.local/share/fonts"),
    Windows = tempdir(),
    tempdir()
  )
}

# Install consent ----

# Gate writes to the user's home directory behind explicit consent. Only
# reached when `dest` was left NULL; a caller-supplied `dest` is consent
# in itself. Session-scoped tempdirs need no gate.
.confirm_font_install <- function(dest, fonts) {
  if (.is_temp_path(dest)) {
    return(invisible(TRUE))
  }

  if (isTRUE(getOption("ggconsulting.font_consent", FALSE))) {
    return(invisible(TRUE))
  }

  if (!interactive()) {
    cli::cli_abort(c(
      "{.fn install_consulting_fonts} would write to {.path {dest}}.",
      "x" = "Refusing to modify your home directory in a non-interactive session.",
      "i" = "Pass an explicit {.arg dest}, or set {.code options(ggconsulting.font_consent = TRUE)}."
    ))
  }

  cli::cli_inform(c(
    "!" = "About to download {length(fonts)} font famil{?y/ies} from Google Fonts",
    " " = "and install {?it/them} into {.path {dest}}.",
    "i" = "Families: {.val {fonts}}."
  ))
  answer <- utils::menu(c("Yes", "No"), title = "Proceed?")

  if (!identical(answer, 1L)) {
    cli::cli_abort("Font installation cancelled.")
  }

  invisible(TRUE)
}

.is_temp_path <- function(path) {
  # normalizePath() only resolves symlinks for paths that exist, so a
  # not-yet-created child of tempdir() keeps the unresolved prefix
  # (/var/... on macOS) while tempdir() itself resolves (/private/var/...).
  # Compare against both spellings.
  temps <- unique(c(tempdir(), normalizePath(tempdir(), mustWork = FALSE)))
  path <- .clean_path(normalizePath(path, mustWork = FALSE))

  for (temp in .clean_path(temps)) {
    if (identical(path, temp) || startsWith(path, paste0(temp, "/"))) {
      return(TRUE)
    }
  }
  FALSE
}

.clean_path <- function(path) {
  path <- gsub("\\\\", "/", path)
  path <- gsub("/+", "/", path)
  sub("/$", "", path)
}
