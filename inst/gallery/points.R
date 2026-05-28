# Scatter / point plot gallery ----

library(ggplot2)
library(dplyr)
library(ggconsulting)

# Selic vs IPCA scatter ----

p_point_simple <- ggplot(br_macro, aes(selic, ipca_12m)) +
  ct_point() +
  labs(
    title    = "Selic rate vs IPCA, 12-month",
    subtitle = "Monthly observations, 2012 – 2024",
    x = "Selic, % a.a.",
    y = "IPCA 12m, %"
  ) +
  theme_strategy()
p_point_simple

# Coloured by decade ----

br_macro_dec <- br_macro |>
  mutate(decade = if_else(date < as.Date("2020-01-01"), "2010s", "2020s"))

p_point_color <- ggplot(br_macro_dec, aes(selic, ipca_12m, colour = decade)) +
  ct_point() +
  scale_color_ct("strategy_navy") +
  labs(
    title    = "Selic vs IPCA by decade",
    x = "Selic, % a.a.", y = "IPCA 12m, %", colour = NULL
  ) +
  theme_strategy()
p_point_color

# Continuous gradient color ----

p_point_grad <- ggplot(br_macro, aes(selic, ipca_12m, colour = usd_brl)) +
  ct_point() +
  scale_color_ct_c("strategy_emerald") +
  labs(
    title    = "Selic vs IPCA coloured by USD/BRL",
    subtitle = "scale_color_ct_c(\"strategy_emerald\")",
    x = "Selic, % a.a.", y = "IPCA 12m, %", colour = "BRL/USD"
  ) +
  theme_strategy()
p_point_grad

# Scatter with loess smoother ----

p_point_smooth <- ggplot(br_macro, aes(unemployment, ipca_12m)) +
  ct_point() +
  geom_smooth(method = "loess", formula = y ~ x, se = TRUE,
              colour = "#7A1F2B", linewidth = 0.8) +
  labs(
    title    = "Unemployment vs inflation",
    subtitle = "Phillips-curve sketch with loess smoother",
    x = "PNADC unemployment, %", y = "IPCA 12m, %"
  ) +
  theme_finance()
p_point_smooth
