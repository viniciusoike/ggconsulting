# ct_finish bar gallery ----
#
# Data-aware polish: value labels, sorting, highlighting, and label
# formatters. The final waterfall example uses a hand-rolled geom_rect
# layout — ct_finish() does not yet know about cumulative deltas.

library(ggplot2)
library(dplyr)
library(ggconsulting)

# Value labels with brl format ----

bu_totals <- bu_quarterly |>
  group_by(business_unit) |>
  summarise(revenue_brl = sum(revenue_brl), .groups = "drop")

p_col_values <- ggplot(bu_totals, aes(business_unit, revenue_brl)) +
  ct_col() +
  ct_finish(values = TRUE, label_fmt = "brl") +
  labs(
    title    = "Total revenue with value labels",
    subtitle = "ct_finish(values = TRUE, label_fmt = \"brl\")",
    x = NULL, y = NULL
  ) +
  theme_strategy() +
  theme(
    axis.text.y        = element_blank(),
    axis.ticks.y       = element_blank(),
    panel.grid.major.y = element_blank()
  )
p_col_values

# Sorted + highlighted + labeled in one ct_finish call ----

p_col_full_finish <- ggplot(bu_totals, aes(business_unit, revenue_brl)) +
  ct_col() +
  ct_finish(
    values    = TRUE,
    sort      = "desc",
    label_fmt = "brl",
    highlight = "Industrial"
  ) +
  labs(
    title    = "Industrial leads conglomerate revenue",
    subtitle = "Sorted, highlighted, labeled — one ct_finish call",
    x = NULL, y = NULL
  ) +
  theme_strategy() +
  theme(
    axis.text.y        = element_blank(),
    axis.ticks.y       = element_blank(),
    panel.grid.major.y = element_blank()
  )
p_col_full_finish

# Percentage bars with fmt_pct ----

share_2024 <- market_share |>
  filter(year == 2024)

p_col_pct <- ggplot(share_2024, aes(company, share)) +
  ct_col() +
  ct_finish(
    values    = TRUE,
    sort      = "desc",
    label_fmt = "pct",
    highlight = "Player B"
  ) +
  scale_y_continuous(labels = fmt_pct(decimals = 0)) +
  labs(
    title    = "2024 market share — challenger emerges",
    x = NULL, y = NULL
  ) +
  theme_strategy()
p_col_pct

# EBITDA waterfall — manual fill scale + cumulative positioning ----

n         <- nrow(ebitda_bridge)
running   <- cumsum(ebitda_bridge$value_brl[seq_len(n - 1L)])
bar_top   <- c(running, ebitda_bridge$value_brl[n])
bar_base  <- c(0, utils::head(running, -1L), 0)

ebitda_w <- ebitda_bridge |>
  mutate(idx = row_number(), bar_base = bar_base, bar_top = bar_top)

bridge_fill <- c(total = "#1F4E79", increase = "#3DA876", decrease = "#B22234")

p_col_waterfall <- ggplot(ebitda_w) +
  geom_rect(
    aes(xmin = idx - 0.35, xmax = idx + 0.35,
        ymin = bar_base, ymax = bar_top, fill = type)
  ) +
  geom_text(
    aes(x = idx, y = pmax(bar_base, bar_top),
        label = fmt_brl(decimals = 0)(value_brl)),
    vjust = -0.4, size = 3
  ) +
  scale_x_continuous(breaks = ebitda_w$idx, labels = ebitda_w$component) +
  scale_fill_manual(values = bridge_fill, guide = "none") +
  scale_y_continuous(labels = fmt_brl(decimals = 0)) +
  labs(
    title    = "EBITDA bridge: FY23 to FY24",
    subtitle = "Endpoints are absolute levels; intermediate bars are cumulative deltas",
    x = NULL, y = NULL
  ) +
  theme_finance() +
  theme(axis.text.x = element_text(angle = 30, hjust = 1))
p_col_waterfall
