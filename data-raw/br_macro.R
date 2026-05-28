# Brazilian macro indicators, monthly, 2012-01 through 2024-12.
# Wide format: one row per month, one column per indicator (156 rows).
# Snapshot frozen at 2024-12-31. Used in editorial-theme and pt-BR locale demos.
#
# Sources (all aggregated to end-of-month):
#   selic         — BCB SGS series 432   (Meta Selic, % a.a.)
#   ipca_12m      — BCB SGS series 13522 (IPCA acumulado 12m, %)
#   ibc_br        — BCB SGS series 24364 (IBC-Br SA, index 2002=100)
#   usd_brl       — BCB SGS series 1     (USD/BRL compra)
#   unemployment  — BCB SGS series 24369 (PNADC desocupacao, %)
#
# usd_brl and selic are daily natively; both are aggregated to month-end.
# Series start dates: ipca_12m (1980+), selic (1986+), usd_brl (1984+),
# ibc_br (2003+), unemployment / PNADC (2012-03). PNADC defines the
# left edge; the first two months (2012-01, 2012-02) carry NA for
# unemployment, so the snapshot starts at 2012-03.
#
# Re-pull script at the bottom of this file.

library(dplyr)
library(tidyr)

# Read snapshot ---------------------------------------------------------------

raw <- readr::read_csv(
  "data-raw/br_macro_raw.csv",
  show_col_types = FALSE,
  col_types = readr::cols(
    date        = readr::col_date(),
    series_name = readr::col_character(),
    value       = readr::col_double()
  )
)

# Tidy ------------------------------------------------------------------------

br_macro <- raw |>
  pivot_wider(names_from = series_name, values_from = value) |>
  filter(date >= as.Date("2012-03-01"), date <= as.Date("2024-12-01")) |>
  arrange(date) |>
  transmute(
    date,
    selic        = round(selic, 2),
    ipca_12m     = round(ipca_12m, 2),
    ibc_br       = round(ibc_br, 2),
    usd_brl      = round(usd_brl, 4),
    unemployment = round(unemployment, 2)
  )

stopifnot(!anyNA(br_macro))

usethis::use_data(br_macro, overwrite = TRUE)


# Re-pull script (run interactively to refresh the CSV) -----------------------

library(rbcb)
library(dplyr)
library(tidyr)
library(lubridate)
library(purrr)

series <- c(
  selic = 4189,
  ipca_12m = 13522,
  ibc_br = 24364,
  usd_brl = 3696,
  unemployment = 24369
)

raw_list <- rbcb::get_series(
  series,
  start_date = "2012-01-01",
  end_date = "2024-12-31"
)

wide <- reduce(raw_list, full_join, by = "date")

long_dat <- wide |>
  pivot_longer(cols = -"date", names_to = "series_name") |>
  arrange(date)

readr::write_csv(long_dat, "data-raw/br_macro_raw.csv")
