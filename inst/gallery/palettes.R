# Palette gallery ----

library(ggplot2)
library(dplyr)
library(ggconsulting)

# All palette swatches ----

p_palettes_all <- ct_palette_show()
p_palettes_all

# Single palette swatch ----

p_palettes_strategy_navy <- ct_palette_show("strategy_navy")
p_palettes_strategy_navy

# Custom (ad-hoc) palette vector ----

p_palettes_custom <- ct_palette_show(c("#264653", "#2A9D8F", "#E9C46A",
                                       "#F4A261", "#E76F51"))
p_palettes_custom

# Same chart × four discrete palettes ----

ibov_subset <- ibov_sectors |>
  filter(sector_index %in% c("IBOV", "IFNC", "ICON", "IMOB"))

base_sectors <- function() {
  ggplot(ibov_subset, aes(date, close, colour = sector_index)) +
    ct_line() +
    labs(x = NULL, y = "Index level", colour = NULL) +
    theme_strategy()
}

p_pal_navy    <- base_sectors() + scale_color_ct("strategy_navy")    +
  labs(title = "strategy_navy")
p_pal_emerald <- base_sectors() + scale_color_ct("strategy_emerald") +
  labs(title = "strategy_emerald")
p_pal_crimson <- base_sectors() + scale_color_ct("strategy_crimson") +
  labs(title = "strategy_crimson")
p_pal_azure   <- base_sectors() + scale_color_ct("strategy_azure")   +
  labs(title = "strategy_azure")

p_pal_navy
p_pal_emerald
p_pal_crimson
p_pal_azure

# Continuous gradient ----

p_pal_continuous <- ggplot(br_macro, aes(date, ipca_12m, colour = ipca_12m)) +
  geom_line(linewidth = 1) +
  scale_color_ct_c("editorial_oxide") +
  labs(
    title    = "Continuous gradient: editorial_oxide",
    subtitle = "scale_color_ct_c() interpolates across all palette stops",
    x = NULL, y = "%", colour = "IPCA"
  ) +
  theme_strategy()
p_pal_continuous

# Palette exhaustion: 7 sectors > 6-colour palette ----
# Triggers the cli interpolation warning at draw time.

p_pal_exhaust <- ggplot(ibov_sectors, aes(date, close, colour = sector_index)) +
  ct_line() +
  scale_color_ct("strategy_navy") +
  labs(
    title    = "Discrete palette exhaustion",
    subtitle = "7 sectors mapped onto a 6-colour palette — interpolation warning",
    x = NULL, y = "Index level", colour = NULL
  ) +
  theme_strategy()
p_pal_exhaust
