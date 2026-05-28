# Locale data ----

# Internal locale table. Each entry holds formatting marks, currency
# rendering, and Portuguese / English month strings. We ship our own
# month tables instead of relying on Sys.setlocale() (OS-dependent;
# breaks on Windows CI).
.ct_locales <- list(
  "pt-BR" = list(
    big_mark        = ".",
    decimal_mark    = ",",
    currency_symbol = "R$",
    currency_space  = TRUE,
    negative_style  = "minus",
    month_abbr = c("jan", "fev", "mar", "abr", "mai", "jun",
                   "jul", "ago", "set", "out", "nov", "dez"),
    month_full = c("janeiro", "fevereiro", "mar\u00e7o", "abril", "maio", "junho",
                   "julho", "agosto", "setembro", "outubro", "novembro", "dezembro")
  ),
  "en-US" = list(
    big_mark        = ",",
    decimal_mark    = ".",
    currency_symbol = "$",
    currency_space  = FALSE,
    negative_style  = "minus",
    month_abbr = c("Jan", "Feb", "Mar", "Apr", "May", "Jun",
                   "Jul", "Aug", "Sep", "Oct", "Nov", "Dec"),
    month_full = c("January", "February", "March", "April", "May", "June",
                   "July", "August", "September", "October", "November", "December")
  )
)

# Locale switch ----

#' Set the active ggconsulting locale
#'
#' Stores the choice in `options(ggconsulting.locale = ...)`. The active
#' locale is read by the formatter helpers (`fmt_number()`,
#' `fmt_currency()`, `fmt_month()`, etc.) when their `locale` argument
#' is `NULL`. Defaults to `"pt-BR"`; `"en-US"` is always available.
#'
#' Does *not* touch `Sys.setlocale()` — that's OS-dependent and breaks
#' on Windows CI. ggconsulting ships its own month tables and formatting
#' marks instead.
#'
#' @param locale One of `"pt-BR"` or `"en-US"`.
#'
#' @return The previous locale, invisibly. Use it to round-trip:
#'   `old <- ct_locale("en-US"); ...; ct_locale(old)`.
#' @export
#' @examples
#' old <- ct_locale("en-US")
#' ct_locale(old)
ct_locale <- function(locale = c("pt-BR", "en-US")) {
  locale <- match.arg(locale)
  old <- getOption("ggconsulting.locale", "pt-BR")
  options(ggconsulting.locale = locale)
  invisible(old)
}

# Internal accessors ----

.current_locale <- function() {
  getOption("ggconsulting.locale", "pt-BR")
}

.locale_data <- function(locale = NULL) {
  if (is.null(locale)) {
    locale <- .current_locale()
  }
  if (!locale %in% names(.ct_locales)) {
    cli::cli_abort(c(
      "Unknown locale {.val {locale}}.",
      "i" = "Available: {.val {names(.ct_locales)}}."
    ))
  }
  .ct_locales[[locale]]
}
