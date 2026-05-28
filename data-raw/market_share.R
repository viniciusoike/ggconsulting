# Simulated annual market share for a fictional Brazilian sector.
# Six players (five named + Others) across 10 years (2015-2024).
# Shares sum to 1 each year.
# Story arc: incumbent A erodes; challenger C gains; tail consolidates.

library(dplyr)
library(tidyr)

set.seed(7)

# Params ----------------------------------------------------------------------

anchors <- tibble::tibble(
  company = c("Player A", "Player B", "Player C", "Player D", "Player E", "Others"),
  start   = c(0.32, 0.22, 0.08, 0.10, 0.07, 0.21),   # 2015 share
  end     = c(0.24, 0.22, 0.18, 0.08, 0.05, 0.23)    # 2024 share
)

years <- 2015:2024

# Build -----------------------------------------------------------------------

market_share <- expand_grid(year = years, company = anchors$company) |>
  left_join(anchors, by = "company") |>
  mutate(
    t   = (year - min(years)) / (max(years) - min(years)),
    raw = start + (end - start) * t + rnorm(n(), 0, 0.005)
  ) |>
  group_by(year) |>
  mutate(share = raw / sum(raw)) |>          # renormalise to 1
  ungroup() |>
  transmute(
    year,
    company = factor(company, levels = anchors$company),
    share   = round(share, 4)
  ) |>
  arrange(year, company)

stopifnot(
  all(abs(
    tapply(market_share$share, market_share$year, sum) - 1
  ) < 5e-4)
)

usethis::use_data(market_share, overwrite = TRUE)
