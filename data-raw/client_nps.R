# Simulated quarterly NPS by client segment.
# Three segments × 12 quarters (2022-Q1 through 2024-Q4).
# Used to demo line charts with last-point labels, fmt_delta(), fmt_pct().

library(dplyr)
library(tidyr)

set.seed(11)

# Params ----------------------------------------------------------------------

segment_params <- tibble::tibble(
  segment    = c("Enterprise", "Mid-Market", "SMB"),
  nps_start  = c(65, 45, 30),
  nps_end    = c(68, 55, 35),
  noise_sd   = c(3, 4, 6),
  resp_base  = c(95, 250, 1000)
)

quarters <- seq(as.Date("2022-01-01"), as.Date("2024-10-01"), by = "3 months")

# Build -----------------------------------------------------------------------

client_nps <- expand_grid(quarter = quarters, segment = segment_params$segment) |>
  left_join(segment_params, by = "segment") |>
  group_by(segment) |>
  mutate(
    t   = (row_number() - 1) / (n() - 1),
    nps = as.integer(round(nps_start + (nps_end - nps_start) * t +
                             rnorm(n(), 0, noise_sd))),
    responses = as.integer(round(resp_base * (1 + rnorm(n(), 0, 0.10))))
  ) |>
  ungroup() |>
  transmute(
    quarter,
    segment = factor(segment, levels = segment_params$segment),
    nps,
    responses
  ) |>
  arrange(quarter, segment)

usethis::use_data(client_nps, overwrite = TRUE)
