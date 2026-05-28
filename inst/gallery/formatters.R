# Formatter gallery ----
#
# fmt_*() factories return locale-aware label functions. Use them in
# scale_*_continuous(labels = ...) or via ct_finish(label_fmt = ...).
# Each formatter accepts an explicit `locale` argument; when NULL it
# reads from options(ggconsulting.locale).

library(ggplot2)
library(dplyr)
library(ggconsulting)

# fmt_brl on y-axis ----

bu_totals <- bu_quarterly |>
  group_by(business_unit) |>
  summarise(revenue_brl = sum(revenue_brl), .groups = "drop")

p_fmt_brl <- ggplot(bu_totals, aes(business_unit, revenue_brl)) +
  ct_col() +
  scale_y_continuous(labels = fmt_brl(decimals = 0)) +
  labs(
    title    = "fmt_brl() axis labels",
    subtitle = "pt-BR marks: comma decimal, period thousands",
    x = NULL, y = NULL
  ) +
  theme_strategy()
p_fmt_brl

# fmt_pct on share data ----

share_evol <- market_share |>
  filter(company %in% c("Player A", "Player B"))

p_fmt_pct <- ggplot(share_evol, aes(year, share, colour = company)) +
  ct_line() +
  ct_point() +
  scale_color_ct("strategy_navy") +
  scale_y_continuous(labels = fmt_pct(decimals = 0)) +
  labs(
    title    = "Player A vs Player B market share",
    subtitle = "fmt_pct() converts fraction → \"40%\"",
    x = NULL, y = NULL, colour = NULL
  ) +
  theme_strategy()
p_fmt_pct

# fmt_delta value labels on quarterly NPS deltas ----

nps_delta <- client_nps |>
  arrange(segment, quarter) |>
  group_by(segment) |>
  mutate(delta = nps - lag(nps)) |>
  ungroup() |>
  filter(!is.na(delta))

p_fmt_delta <- ggplot(nps_delta, aes(quarter, delta, colour = segment)) +
  ct_line() +
  ct_point() +
  scale_color_ct("editorial_warm") +
  scale_y_continuous(labels = fmt_delta(decimals = 0, suffix = "")) +
  geom_hline(yintercept = 0, linewidth = 0.3, colour = "#888888") +
  labs(
    title    = "Quarterly NPS change by segment",
    subtitle = "fmt_delta() prefixes signed values (suffix disabled here)",
    x = NULL, y = "Δ NPS", colour = NULL
  ) +
  theme_editorial()
p_fmt_delta

# fmt_month on a Date axis (pt-BR) ----

ibov_2024 <- ibov_sectors |>
  filter(sector_index == "IBOV", format(date, "%Y") == "2024")

p_fmt_month_pt <- ggplot(ibov_2024, aes(date, close)) +
  ct_line() +
  scale_x_date(breaks = ibov_2024$date, labels = fmt_month(locale = "pt-BR")) +
  labs(
    title    = "IBOV monthly close, 2024",
    subtitle = "fmt_month(locale = \"pt-BR\"): jan, fev, mar…",
    x = NULL, y = "Index level"
  ) +
  theme_finance()
p_fmt_month_pt

# fmt_currency with explicit locale ----
# Passing locale = "en-US" keeps the script side-effect free (no global
# options() mutation). Use ct_locale("en-US") if you want it sticky.

p_fmt_locale_en <- ggplot(bu_totals, aes(business_unit, revenue_brl)) +
  ct_col() +
  scale_y_continuous(labels = fmt_currency(decimals = 0, locale = "en-US")) +
  labs(
    title    = "fmt_currency() in en-US locale",
    subtitle = "$ + period decimal + comma thousands",
    x = NULL, y = NULL
  ) +
  theme_strategy()
p_fmt_locale_en

p_fmt_locale_pt <- ggplot(bu_totals, aes(business_unit, revenue_brl)) +
  ct_col() +
  scale_y_continuous(labels = fmt_currency(decimals = 0, locale = "pt-BR")) +
  labs(
    title    = "fmt_currency() in pt-BR locale",
    subtitle = "R$ + comma decimal + period thousands",
    x = NULL, y = NULL
  ) +
  theme_strategy()
p_fmt_locale_pt
