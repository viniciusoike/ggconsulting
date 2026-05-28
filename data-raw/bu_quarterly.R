# Simulated quarterly P&L for a fictional Brazilian mid-cap conglomerate.
# Five business units across 16 quarters (2021-Q1 through 2024-Q4).
# Used to demo theme_strategy(), stacked-bar ct_finish() labels, fmt_brl().

library(dplyr)
library(tidyr)

set.seed(2024)

# Params ----------------------------------------------------------------------

bu_params <- tibble::tibble(
  business_unit = c("Industrial", "Consumer", "Health", "Logistics", "Digital"),
  rev_fy24_brl  = c(480, 320, 210, 180, 95),   # R$ MM, FY2024 annual revenue
  cagr          = c(0.04, 0.02, 0.08, 0.06, 0.25),
  ebitda_margin = c(0.18, 0.12, 0.22, 0.14, -0.05),
  cogs_ratio    = c(0.62, 0.55, 0.50, 0.70, 0.45),
  rev_per_head  = c(250, 250, 260, 250, 300)   # R$ k / FTE / year
)

# Q1..Q4 multipliers (average to 1 within each BU)
seasonality <- tibble::tibble(
  business_unit = rep(bu_params$business_unit, each = 4),
  q_idx         = rep(1:4, times = 5),
  season_mult   = c(
    0.95, 1.00, 1.00, 1.05,   # Industrial
    0.85, 0.95, 1.00, 1.20,   # Consumer  (Q4 retail spike)
    1.00, 1.00, 1.00, 1.00,   # Health
    0.90, 0.95, 1.00, 1.15,   # Logistics (Q4 freight)
    1.00, 1.00, 1.00, 1.00    # Digital
  )
)

# Build -----------------------------------------------------------------------

quarters <- seq(as.Date("2021-01-01"), as.Date("2024-10-01"), by = "3 months")

bu_quarterly <- expand_grid(
  quarter       = quarters,
  business_unit = bu_params$business_unit
) |>
  mutate(
    year_offset = as.integer(format(quarter, "%Y")) - 2024,
    q_idx       = (as.integer(format(quarter, "%m")) - 1) %/% 3 + 1
  ) |>
  left_join(bu_params,   by = "business_unit") |>
  left_join(seasonality, by = c("business_unit", "q_idx")) |>
  mutate(
    annual_rev  = rev_fy24_brl * (1 + cagr) ^ year_offset,
    revenue_brl = annual_rev / 4 * season_mult *
                    (1 + rnorm(n(), 0, 0.02)),
    cogs_brl    = revenue_brl * cogs_ratio *
                    (1 + rnorm(n(), 0, 0.015)),
    ebitda_brl  = revenue_brl * ebitda_margin +
                    rnorm(n(), 0, abs(revenue_brl) * 0.015),
    headcount   = as.integer(round(annual_rev * 1000 / rev_per_head *
                                     (1 - 0.015 * abs(year_offset))))
  ) |>
  transmute(
    quarter,
    business_unit = factor(business_unit, levels = bu_params$business_unit),
    revenue_brl   = round(revenue_brl, 1),
    cogs_brl      = round(cogs_brl, 1),
    ebitda_brl    = round(ebitda_brl, 1),
    headcount
  ) |>
  arrange(quarter, business_unit)

usethis::use_data(bu_quarterly, overwrite = TRUE)
