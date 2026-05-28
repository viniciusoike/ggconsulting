# Format helper factories ----

#' Locale-aware label formatters
#'
#' @description
#' Factory functions: each returns a function compatible with
#' `scales::label_*` (callable on a numeric vector). Marks (thousands,
#' decimals) and currency symbols come from the active ggconsulting
#' locale, set via [ct_locale()].
#'
#' - `fmt_number()` — plain numbers with locale separators.
#' - `fmt_brl()` — Brazilian Real. Always renders as `R$` regardless of
#'   active locale; the `locale` argument lets you override marks.
#' - `fmt_currency()` — uses the active locale's currency symbol.
#' - `fmt_pct()` — percentages. By default interprets input as a
#'   fraction (`0.5` → `"50%"`); pass `scale = 1` when the input is
#'   already in percent units (`50` → `"50%"`).
#' - `fmt_delta()` — percentage-point-style signed deltas
#'   (`+1,2pp` / `-0,3pp` / `0,0pp`).
#' - `fmt_month()` — Date / POSIXct → localised month string.
#'
#' Negatives default to a minus prefix; currency helpers also support
#' `style = "accounting"`, which wraps negatives in parentheses. Currency
#' rendering uses a non-breaking space (`U+00A0`) between symbol and
#' number so the pair never wraps across lines.
#'
#' @param decimals Number of decimal places.
#' @param style `"minus"` (default) or `"accounting"` for currency.
#' @param suffix Suffix for `fmt_delta()`. Defaults to `"pp"`.
#' @param accuracy Optional explicit accuracy passed to
#'   [scales::percent()]; overrides `decimals` if set.
#' @param scale Multiplier applied to the input before rendering, for
#'   `fmt_pct()` only. Defaults to `100` (input is a fraction). Use
#'   `scale = 1` when the input is already in percent units.
#' @param format `"abbr"` (default) or `"full"` for `fmt_month()`.
#' @param locale Optional locale name. Defaults to the active locale.
#'
#' @return A formatter function: `function(x) character`.
#' @name ct_formatters
#' @examples
#' fmt_number(decimals = 1)(1234.5)
#' fmt_brl()(c(1000, -500))
#' fmt_pct(decimals = 0)(0.5)
#' fmt_pct(decimals = 1, scale = 1)(50)
#' fmt_delta()(c(1.2, -0.3, 0))
#' fmt_month()(as.Date("2026-08-15"))
NULL

#' @rdname ct_formatters
#' @export
fmt_number <- function(decimals = 0, locale = NULL) {
  function(x) {
    loc <- .locale_data(locale)
    scales::number(
      x,
      accuracy     = .accuracy_from_decimals(decimals),
      big.mark     = loc$big_mark,
      decimal.mark = loc$decimal_mark
    )
  }
}

#' @rdname ct_formatters
#' @export
fmt_brl <- function(decimals = 2,
                    style = c("minus", "accounting"),
                    locale = NULL) {
  style <- match.arg(style)
  loc <- .locale_data(if (is.null(locale)) "pt-BR" else locale)
  function(x) {
    .format_currency(x, "R$", space = TRUE, decimals = decimals,
                     loc = loc, style = style)
  }
}

#' @rdname ct_formatters
#' @export
fmt_currency <- function(decimals = 2,
                         style = c("minus", "accounting"),
                         locale = NULL) {
  style <- match.arg(style)
  loc <- .locale_data(locale)
  function(x) {
    .format_currency(x, loc$currency_symbol, space = isTRUE(loc$currency_space),
                     decimals = decimals, loc = loc, style = style)
  }
}

#' @rdname ct_formatters
#' @export
fmt_pct <- function(decimals = 1, scale = 100, locale = NULL,
                    accuracy = NULL) {
  function(x) {
    loc <- .locale_data(locale)
    scales::percent(
      x,
      scale        = scale,
      accuracy     = if (is.null(accuracy)) .accuracy_from_decimals(decimals) else accuracy,
      big.mark     = loc$big_mark,
      decimal.mark = loc$decimal_mark
    )
  }
}

#' @rdname ct_formatters
#' @export
fmt_delta <- function(decimals = 1, suffix = "pp", locale = NULL) {
  function(x) {
    loc <- .locale_data(locale)
    abs_x <- abs(x)
    formatted <- scales::number(
      abs_x,
      accuracy     = .accuracy_from_decimals(decimals),
      big.mark     = loc$big_mark,
      decimal.mark = loc$decimal_mark
    )
    sign <- ifelse(is.na(x), "",
                   ifelse(x < 0, "-",
                          ifelse(x > 0, "+", "")))
    paste0(sign, formatted, suffix)
  }
}

#' @rdname ct_formatters
#' @export
fmt_month <- function(format = c("abbr", "full"), locale = NULL) {
  format <- match.arg(format)
  function(x) {
    loc <- .locale_data(locale)
    months <- if (format == "abbr") loc$month_abbr else loc$month_full
    months[as.integer(base::format(x, "%m"))]
  }
}

# Internal helpers ----

.accuracy_from_decimals <- function(decimals) {
  if (is.null(decimals) || decimals == 0) 1 else 10^(-decimals)
}

# Currency rendering shared by fmt_brl() and fmt_currency(). `space`
# controls whether a non-breaking space (U+00A0) sits between symbol and
# number — written as the \u00a0 escape so the source is encoding-safe
# regardless of the editor's default codepage.
.format_currency <- function(x, symbol, space, decimals, loc, style) {
  abs_x <- abs(x)
  formatted <- scales::number(
    abs_x,
    accuracy     = .accuracy_from_decimals(decimals),
    big.mark     = loc$big_mark,
    decimal.mark = loc$decimal_mark
  )
  gap <- if (isTRUE(space)) "\u00a0" else ""
  out <- paste0(symbol, gap, formatted)
  is_neg <- !is.na(x) & x < 0
  if (any(is_neg)) {
    out[is_neg] <- if (style == "accounting") {
      paste0("(", out[is_neg], ")")
    } else {
      paste0("-", out[is_neg])
    }
  }
  out
}
