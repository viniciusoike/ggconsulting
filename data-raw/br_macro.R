# Brazilian macro indicators, monthly, 2012-03 through 2024-12.
# Wide format: one row per month, one column per indicator (154 rows).
# Snapshot frozen at 2024-12-31. Used in editorial-theme and pt-BR locale demos.
#
# Source: Banco Central do Brasil (BCB), Sistema Gerenciador de Series
# Temporais (SGS), series 4189, 13522, 24364, 3696, and 24369. The source
# identified by BCB for series 24369 is IBGE (PNADC). Data are retrieved with
# `rbcb::get_series()`; `rbcb` is a retrieval tool, not the data producer.
# Official portal: https://www3.bcb.gov.br/sgspub/
#
#   selic         — 4189 (Selic acumulada no mes, anualizada, base 252, % a.a.)
#   ipca_12m      — 13522 (IPCA acumulado em 12 meses, %)
#   ibc_br        — 24364 (IBC-Br com ajuste sazonal, indice)
#   usd_brl       — 3696 (USD/BRL venda, fim de periodo)
#   unemployment  — 24369 (taxa de desocupacao PNADC, %)
#
# The source series are monthly; this script does not aggregate daily data.
# Series start dates: ipca_12m (1980+), selic (1986+), usd_brl (1953+),
# ibc_br (2003+), unemployment / PNADC (2012-03). PNADC defines the
# left edge; the first two months (2012-01, 2012-02) carry NA for
# unemployment, so the snapshot starts at 2012-03.
#
# Disclaimer: this repository stores a rounded, transformed snapshot, not an
# official current BCB or IBGE release. Historical values may be revised, and
# the source organizations do not endorse this package. Check source terms
# before refreshing or redistributing the data.
#
# Re-pull script at the bottom of this file.

library(dplyr)
library(tidyr)

# Read snapshot ---------------------------------------------------------------

raw <- readr::read_csv(
  "data-raw/br_macro_raw.csv",
  show_col_types = FALSE,
  col_types = readr::cols(
    date = readr::col_date(),
    series_name = readr::col_character(),
    value = readr::col_double()
  )
)

# Tidy ------------------------------------------------------------------------

br_macro <- raw |>
  pivot_wider(names_from = series_name, values_from = value) |>
  filter(date >= as.Date("2012-03-01"), date <= as.Date("2024-12-01")) |>
  arrange(date) |>
  transmute(
    date,
    selic = round(selic, 2),
    ipca_12m = round(ipca_12m, 2),
    ibc_br = round(ibc_br, 2),
    usd_brl = round(usd_brl, 4),
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
