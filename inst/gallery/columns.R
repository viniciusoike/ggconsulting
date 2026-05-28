# Column plot gallery ----
#
# Bars use an ordered-factor x. A raw Date axis renders bars as slivers
# because ct_col()'s default width is 0.8 *x-axis units* — i.e. 0.8 days
# on a Date axis. See ?ct_col.

library(ggplot2)
library(dplyr)
library(ggconsulting)

# Helper: build "21Q1" style ordered factor from Date column ----

quarter_label <- function(d) {
  y <- format(d, "%y")
  q <- (as.integer(format(d, "%m")) - 1L) %/% 3L + 1L
  lbl <- paste0(y, "Q", q)
  factor(lbl, levels = unique(lbl[order(d)]))
}

# Aggregated bar by business unit ----

bu_totals <- bu_quarterly |>
  group_by(business_unit) |>
  summarise(revenue_brl = sum(revenue_brl), .groups = "drop")

p_col_simple <- ggplot(bu_totals, aes(business_unit, revenue_brl)) +
  ct_col() +
  scale_y_continuous(labels = fmt_brl(decimals = 0)) +
  labs(
    title    = "Total revenue by business unit",
    subtitle = "2021Q1 – 2024Q4, R$ MM",
    x = NULL, y = NULL
  ) +
  theme_strategy()
p_col_simple

# Quarterly bar with ordered factor x ----

quarter_totals <- bu_quarterly |>
  group_by(quarter) |>
  summarise(revenue_brl = sum(revenue_brl), .groups = "drop") |>
  arrange(quarter) |>
  mutate(quarter_lbl = quarter_label(quarter))

p_col_quarter <- ggplot(quarter_totals, aes(quarter_lbl, revenue_brl)) +
  ct_col() +
  scale_y_continuous(labels = fmt_brl(decimals = 0)) +
  labs(
    title    = "Quarterly revenue",
    subtitle = "Conglomerate consolidated, R$ MM",
    x = NULL, y = NULL
  ) +
  theme_strategy() +
  theme(axis.text.x = element_text(angle = 45, hjust = 1))
p_col_quarter

# Stacked bar by BU across years ----

bu_year <- bu_quarterly |>
  mutate(year = format(quarter, "%Y")) |>
  group_by(year, business_unit) |>
  summarise(revenue_brl = sum(revenue_brl), .groups = "drop")

p_col_stacked <- ggplot(bu_year, aes(year, revenue_brl, fill = business_unit)) +
  geom_col(width = 0.7) +
  scale_fill_ct("strategy_navy") +
  scale_y_continuous(labels = fmt_brl(decimals = 0)) +
  labs(
    title    = "Annual revenue stacked by business unit",
    subtitle = "R$ MM",
    x = NULL, y = NULL, fill = NULL
  ) +
  theme_strategy()
p_col_stacked

# Dodged bar for 2024 ----

bu_2024 <- bu_quarterly |>
  filter(format(quarter, "%Y") == "2024") |>
  mutate(quarter_lbl = quarter_label(quarter))

p_col_dodged <- ggplot(bu_2024, aes(quarter_lbl, revenue_brl, fill = business_unit)) +
  geom_col(width = 0.8, position = position_dodge2(preserve = "single")) +
  scale_fill_ct("strategy_navy") +
  scale_y_continuous(labels = fmt_brl(decimals = 0)) +
  labs(
    title    = "2024 quarterly revenue by BU",
    x = NULL, y = NULL, fill = NULL
  ) +
  theme_strategy()
p_col_dodged
