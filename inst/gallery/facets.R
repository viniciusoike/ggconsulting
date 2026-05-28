# Faceted (small multiples) gallery ----

library(ggplot2)
library(dplyr)
library(tidyr)
library(ggconsulting)

# Macro indicators, facet_wrap free_y ----

macro_long <- br_macro |>
  pivot_longer(cols = -date, names_to = "series", values_to = "value")

p_facet_macro <- ggplot(macro_long, aes(date, value)) +
  ct_line() +
  facet_wrap(vars(series), scales = "free_y") +
  labs(
    title    = "Brazilian macro snapshot",
    subtitle = "Five headline indicators, free y per panel",
    x = NULL, y = NULL
  ) +
  theme_strategy(base_size = 10)
p_facet_macro

# B3 sector indices, facet_wrap free_y, finance ----

p_facet_sectors <- ggplot(ibov_sectors, aes(date, close)) +
  ct_line() +
  facet_wrap(vars(sector_index), scales = "free_y") +
  labs(
    title    = "B3 sector indices",
    subtitle = "Monthly close; free y per panel",
    x = NULL, y = NULL
  ) +
  theme_finance()
p_facet_sectors

# bu_quarterly, facet_grid metric × business unit ----

bu_long <- bu_quarterly |>
  pivot_longer(
    cols = c(revenue_brl, ebitda_brl),
    names_to  = "metric",
    values_to = "value"
  )

p_facet_grid <- ggplot(bu_long, aes(quarter, value)) +
  ct_line() +
  facet_grid(metric ~ business_unit, scales = "free_y") +
  scale_y_continuous(labels = fmt_brl(decimals = 0)) +
  labs(
    title    = "Quarterly revenue and EBITDA by business unit",
    subtitle = "facet_grid(metric ~ business_unit, scales = \"free_y\")",
    x = NULL, y = NULL
  ) +
  theme_strategy(base_size = 9, density = "tight")
p_facet_grid

# Tight density facet, finance archetype ----

p_facet_finance_tight <- ggplot(macro_long, aes(date, value)) +
  ct_line() +
  facet_wrap(vars(series), scales = "free_y", ncol = 3) +
  labs(
    title    = "Macro panel — finance, tight density",
    subtitle = "theme_finance() defaults: density = tight, context = report",
    x = NULL, y = NULL
  ) +
  theme_finance()
p_facet_finance_tight
