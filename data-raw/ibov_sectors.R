# Monthly close and total monthly return for B3 sector indices and the Ibovespa.
# Long format: one row per (sector_index, month). Snapshot frozen at 2024-12-31.
# Covers 2020-01 through 2024-12 (~60 months × 7 indices = ~420 rows).
#
# Source: B3 historical index series. Re-pulled via the `rb3` package (or
# B3's daily index downloads); see the re-pull script at the bottom.
#
# Indices included:
#   IBOV  Ibovespa (benchmark)
#   IFNC  Financial
#   INDX  Industrial
#   IMAT  Basic materials
#   IEEX  Electric utilities
#   ICON  Consumption
#   IMOB  Real estate

library(dplyr)

# Read snapshot ---------------------------------------------------------------

raw <- readr::read_csv(
  "data-raw/ibov_sectors_raw.csv",
  show_col_types = FALSE,
  col_types = readr::cols(
    date = readr::col_date(),
    sector_index = readr::col_character(),
    close = readr::col_double()
  )
)

# Tidy ------------------------------------------------------------------------

ibov_sectors <- raw |>
  filter(date <= as.Date("2024-12-31")) |>
  arrange(sector_index, date) |>
  mutate(return_m = close / lag(close) - 1, .by = "sector_index") |>
  mutate(
    date,
    sector_index = factor(
      sector_index,
      levels = c("IBOV", "IFNC", "INDX", "IMAT", "IEEX", "ICON", "IMOB")
    ),
    close = round(close, 2),
    return_m = round(return_m, 4),
    .keep = "none"
  ) |>
  arrange(sector_index, date)

stopifnot(!is.na(ibov_sectors$close))

usethis::use_data(ibov_sectors, overwrite = TRUE)


# Re-pull script (run interactively to refresh the CSV) -----------------------
#
# Tested against rb3 0.1.0 (2025-07-07). The current API exposes a two-step
# arrow-backed workflow: `fetch_marketdata()` populates a local cache, and
# `indexes_historical_data_get()` returns a lazy query with columns
# `symbol`, `refdate`, `value`.

library(rb3)
library(dplyr)
library(lubridate)

indices <- c("IBOV", "IFNC", "INDX", "IMAT", "IEEX", "ICON", "IMOB")
years <- 2019:2024

options(rb3.cachedir = "~/rb3-cache")
rb3_bootstrap()

fetch_marketdata(
  "b3-indexes-historical-data",
  throttle = TRUE,
  index = indices,
  year = years
)

monthly <- indexes_historical_data_get() |>
  filter(
    symbol %in% indices,
    refdate >= as.Date("2019-12-01"),
    refdate <= as.Date("2024-12-31")
  ) |>
  collect() |>
  mutate(ym = floor_date(refdate, "month")) |>
  group_by(symbol, ym) |>
  slice_max(refdate, n = 1, with_ties = FALSE) |>
  ungroup() |>
  transmute(date = ym, sector_index = symbol, close = value) |>
  arrange(sector_index, date)

readr::write_csv(monthly, "data-raw/ibov_sectors_raw.csv")
