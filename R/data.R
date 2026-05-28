#' Quarterly P&L for a fictional Brazilian conglomerate
#'
#' Simulated quarterly revenue, COGS, EBITDA, and headcount for five
#' business units of a mid-cap Brazilian conglomerate, spanning 16
#' quarters (2021-Q1 through 2024-Q4). Suitable for demos of
#' [theme_strategy()], stacked-bar [ct_finish()] value labels, and
#' [fmt_brl()]. All monetary values are in millions of Brazilian Real
#' (R$ MM).
#'
#' @format A data frame with 80 rows and 6 columns:
#' \describe{
#'   \item{quarter}{First day of the calendar quarter (Date).}
#'   \item{business_unit}{Factor with 5 levels: Industrial, Consumer,
#'     Health, Logistics, Digital.}
#'   \item{revenue_brl}{Net revenue, R$ MM (numeric).}
#'   \item{cogs_brl}{Cost of goods sold, R$ MM (numeric).}
#'   \item{ebitda_brl}{EBITDA, R$ MM (numeric); can be negative.}
#'   \item{headcount}{Period-end full-time-equivalent employees (integer).}
#' }
#' @source Simulated. See \code{data-raw/bu_quarterly.R}.
#' @examples
#' head(bu_quarterly)
"bu_quarterly"

#' Annual market share for a fictional sector
#'
#' Simulated annual market share for six players (five named + Others)
#' over ten years (2015 through 2024). Shares sum to 1 within each year.
#' Story arc: incumbent erodes, challenger gains. Designed for slope
#' and bump-chart demos.
#'
#' @format A data frame with 60 rows and 3 columns:
#' \describe{
#'   \item{year}{Calendar year (integer).}
#'   \item{company}{Factor with 6 levels: Player A, Player B, Player C,
#'     Player D, Player E, Others.}
#'   \item{share}{Market share, fraction in \[0, 1\] (numeric).}
#' }
#' @source Simulated. See \code{data-raw/market_share.R}.
#' @examples
#' head(market_share)
"market_share"

#' Quarterly NPS by client segment
#'
#' Simulated quarterly Net Promoter Score for three client segments
#' (Enterprise, Mid-Market, SMB) across 12 quarters (2022-Q1 through
#' 2024-Q4). Suitable for line-chart demos with last-point labels and
#' [fmt_delta()] / [fmt_pct()].
#'
#' @format A data frame with 36 rows and 4 columns:
#' \describe{
#'   \item{quarter}{First day of the calendar quarter (Date).}
#'   \item{segment}{Factor with 3 levels: Enterprise, Mid-Market, SMB.}
#'   \item{nps}{Net Promoter Score, integer in \[-100, 100\].}
#'   \item{responses}{Number of survey responses in the period (integer).}
#' }
#' @source Simulated. See \code{data-raw/client_nps.R}.
#' @examples
#' head(client_nps)
"client_nps"

#' FY23 to FY24 EBITDA bridge
#'
#' Eight-row ordered breakdown decomposing the year-over-year EBITDA
#' change for the fictional conglomerate behind [bu_quarterly] into
#' volume, price, cost, mix, FX, and one-off effects. The first and
#' last rows are absolute levels; the six intermediate rows are signed
#' deltas that reconcile the endpoints. Designed for waterfall charts.
#'
#' @format A data frame with 8 rows and 3 columns:
#' \describe{
#'   \item{component}{Ordered factor naming the bridge step.}
#'   \item{value_brl}{R$ MM (numeric). Absolute level for endpoint rows;
#'     signed delta for intermediate rows.}
#'   \item{type}{Factor with 3 levels: \code{"total"} for endpoint rows,
#'     \code{"increase"} or \code{"decrease"} for deltas.}
#' }
#' @source Simulated. See \code{data-raw/ebitda_bridge.R}.
#' @examples
#' ebitda_bridge
"ebitda_bridge"

#' Monthly B3 sector indices
#'
#' Monthly closing values and total monthly return for the Ibovespa
#' (IBOV) and six B3 sector indices, covering 2020-01 through 2024-12.
#' Snapshot frozen at 2024-12-31. Long format: one row per
#' (\code{sector_index}, month). Suitable for [theme_finance()] demos
#' and small-multiples.
#'
#' @format A data frame with ~420 rows and 4 columns:
#' \describe{
#'   \item{date}{First day of the month (Date).}
#'   \item{sector_index}{Factor with 7 levels: IBOV, IFNC, INDX, IMAT,
#'     IEEX, ICON, IMOB.}
#'   \item{close}{End-of-month index level (numeric).}
#'   \item{return_m}{Monthly arithmetic return, fraction (numeric);
#'     \code{NA} for the first month of each series.}
#' }
#' @source B3 historical index series, fetched via the \code{rb3}
#'   package. Snapshot date: 2024-12-31. See
#'   \code{data-raw/ibov_sectors.R}.
#' @examples
#' head(ibov_sectors)
"ibov_sectors"

#' Brazilian macroeconomic indicators (monthly)
#'
#' Monthly observations of five headline Brazilian macro series from
#' 2012-03 through 2024-12. Wide format: one row per month, one column
#' per indicator. Snapshot frozen at 2024-12-31. Suitable for
#' [theme_editorial()] demos and \code{ct_locale("pt-BR")} formatting.
#'
#' Indicators are reported in their native units; daily series
#' (\code{selic}, \code{usd_brl}) are sampled at the end of each month.
#'
#' @format A data frame with 154 rows and 6 columns:
#' \describe{
#'   \item{date}{First day of the month (Date).}
#'   \item{selic}{Meta Selic, % a.a., end-of-month (numeric).}
#'   \item{ipca_12m}{IPCA accumulated over the trailing 12 months, %
#'     (numeric).}
#'   \item{ibc_br}{IBC-Br activity index, seasonally adjusted, 2002=100
#'     (numeric).}
#'   \item{usd_brl}{USD/BRL exchange rate (compra), BRL per USD,
#'     end-of-month (numeric).}
#'   \item{unemployment}{PNADC unemployment rate, % (numeric).}
#' }
#' @source Banco Central do Brasil SGS, series 432, 13522, 24364, 1,
#'   and 24369. Unemployment originates with IBGE PNADC and is
#'   redistributed through SGS. Fetched via the \code{rbcb} package.
#'   Snapshot date: 2024-12-31. See \code{data-raw/br_macro.R}.
#' @examples
#' head(br_macro)
"br_macro"
