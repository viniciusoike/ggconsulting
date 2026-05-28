# Theme comparison gallery ----
#
# Same chart × theme_strategy / theme_finance / theme_editorial. Source
# the file and print each `p_theme_*` object to compare typography,
# gridlines, palette, and density across archetypes.

library(ggplot2)
library(dplyr)
library(ggconsulting)

# Line: IPCA 12m × 3 themes ----

base_line <- function() {
  ggplot(br_macro, aes(date, ipca_12m)) +
    ct_line() +
    labs(
      title    = "IPCA, 12-month accumulated",
      subtitle = "Same data, different archetype theme",
      x = NULL, y = "%"
    )
}

p_theme_line_strategy  <- base_line() + theme_strategy()
p_theme_line_finance   <- base_line() + theme_finance()
p_theme_line_editorial <- base_line() + theme_editorial()

p_theme_line_strategy
p_theme_line_finance
p_theme_line_editorial

# Bar: BU revenue × 3 themes ----

bu_totals <- bu_quarterly |>
  group_by(business_unit) |>
  summarise(revenue_brl = sum(revenue_brl), .groups = "drop")

base_bar <- function() {
  ggplot(bu_totals, aes(business_unit, revenue_brl)) +
    ct_col() +
    scale_y_continuous(labels = fmt_brl(decimals = 0)) +
    labs(
      title    = "Total revenue by business unit",
      subtitle = "Same data, different archetype theme",
      x = NULL, y = NULL
    )
}

p_theme_bar_strategy  <- base_bar() + theme_strategy()
p_theme_bar_finance   <- base_bar() + theme_finance()
p_theme_bar_editorial <- base_bar() + theme_editorial()

p_theme_bar_strategy
p_theme_bar_finance
p_theme_bar_editorial

# Context × density grid (strategy) ----
# Same chart across context and density settings, to inspect base_size,
# margins, and panel.spacing changes.

base_compact <- function() {
  ggplot(br_macro, aes(date, ipca_12m)) +
    ct_line() +
    labs(title = "IPCA 12m", x = NULL, y = NULL)
}

p_ctx_presentation <- base_compact() + theme_strategy(context = "presentation")
p_ctx_report       <- base_compact() + theme_strategy(context = "report")
p_ctx_screen       <- base_compact() + theme_strategy(context = "screen")

p_density_normal <- base_compact() + theme_strategy(density = "normal")
p_density_tight  <- base_compact() + theme_strategy(density = "tight")
p_density_loose  <- base_compact() + theme_strategy(density = "loose")

p_ctx_presentation
p_ctx_report
p_ctx_screen
p_density_normal
p_density_tight
p_density_loose
