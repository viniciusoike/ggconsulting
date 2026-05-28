# FY23 → FY24 EBITDA bridge for the fictional conglomerate behind
# bu_quarterly. Eight ordered rows: two endpoint levels plus six deltas.
# Used for waterfall plots (future ctplot::ct_waterfall()).

library(dplyr)

# Build -----------------------------------------------------------------------

ebitda_bridge <- tibble::tribble(
  ~component,         ~value_brl, ~type,
  "FY23 EBITDA",        540,      "total",
  "Volume",              85,      "increase",
  "Price",              120,      "increase",
  "Cost inflation",     -95,      "decrease",
  "Mix",                 25,      "increase",
  "FX",                 -30,      "decrease",
  "One-offs",           -45,      "decrease",
  "FY24 EBITDA",        600,      "total"
) |>
  mutate(
    component = factor(component, levels = component, ordered = TRUE),
    type      = factor(type, levels = c("total", "increase", "decrease"))
  )

# Sanity: deltas reconcile endpoints
delta_sum <- sum(ebitda_bridge$value_brl[ebitda_bridge$type != "total"])
end_diff  <- diff(ebitda_bridge$value_brl[ebitda_bridge$type == "total"])
stopifnot(delta_sum == end_diff)

usethis::use_data(ebitda_bridge, overwrite = TRUE)
