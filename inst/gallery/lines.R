# Line plot gallery ----
#
# Source the whole file or run one section at a time. Each section
# builds a `p_*` object and prints it for visual inspection.

library(ggplot2)
library(dplyr)
library(ggconsulting)

# Single line, finance theme ----

p_line_finance <- ggplot(br_macro, aes(date, ipca_12m)) +
  ct_line() +
  labs(
    title    = "IPCA, 12-month accumulated",
    subtitle = "Headline inflation, Brazil",
    x = NULL, y = "%",
    caption = "Source: BCB SGS 13522"
  ) +
  theme_finance()
p_line_finance

# Multi-series, discrete color, strategy ----

p_line_sectors <- ggplot(ibov_sectors, aes(date, close, colour = sector_index)) +
  ct_line() +
  scale_color_ct("strategy_navy") +
  labs(
    title    = "B3 sector indices",
    subtitle = "Monthly close, 2020-01 to 2024-12",
    x = NULL, y = "Index level", colour = NULL
  ) +
  theme_strategy()
p_line_sectors

# Multi-series with ct_finish end labels (numeric x) ----

ibov_subset <- ibov_sectors |>
  filter(sector_index %in% c("IBOV", "IFNC", "ICON", "IMOB")) |>
  mutate(date_num = as.numeric(date))

p_line_ends <- ggplot(ibov_subset, aes(date_num, close, colour = sector_index)) +
  ct_line() +
  scale_color_ct("strategy_navy") +
  ct_finish(end_labels = TRUE) +
  labs(
    title    = "Sector indices with end-of-series labels",
    subtitle = "ct_finish(end_labels = TRUE) requires numeric x",
    x = NULL, y = "Index level"
  ) +
  theme_strategy() +
  theme(legend.position = "none")
p_line_ends

# Line + point overlay, editorial ----

p_line_point <- ggplot(client_nps, aes(quarter, nps, colour = segment)) +
  ct_line() +
  ct_point() +
  scale_color_ct("editorial_warm") +
  labs(
    title    = "Net Promoter Score by client segment",
    subtitle = "Quarterly survey, 2022 – 2024",
    x = NULL, y = "NPS", colour = NULL
  ) +
  theme_editorial()
p_line_point
