library(ggplot2)
library(treemapify)
library(hexSticker)
library(showtext)

import::from(ggconsulting, ct_palette)

colors <- c(
  ct_palette("strategy_navy", 5)[2],
  ct_palette("strategy_emerald", 5)[3],
  ct_palette("strategy_slate", 5)[2],
  ct_palette("strategy_navy", 6)[5],
  ct_palette("strategy_navy", 6)[6],
  ct_palette("finance_classic", 6)[5]
)

# Setup fonts for high-quality rendering. Avenir is a system font on macOS;
# adjust the path if registering it fails on your platform.
# Lato is the EKIO body font; the wordmark itself draws in Avenir.
# font_add("IBM Plex Sans", regular = "/System/Library/Fonts/Avenir.ttc")
sysfonts::font_add_google("IBM Plex Sans", "IBM Plex Sans")
showtext_opts(dpi = 400)
showtext_auto()

# ---- Color Showcase ----
# Pull colors from across the EKIO palette families to highlight the range:
# the core brand blue, contrasting accents, and a teal/orange pairing.

# ---- Treemap Data ----
# Fibonacci-based areas give visually pleasing relative block sizes.
mod_fib <- c(1, 1, 2, 3, 5, 8, 13, 21)
mod_fib <- 1 / mod_fib
mod_fib <- mod_fib[-1]
mod_fib <- mod_fib + 0.15

treemap_data <- data.frame(
  area = mod_fib[seq_along(colors)],
  color_id = factor(seq_along(colors)),
  fill_color = colors
)

# ---- Treemap Subplot ----
# White borders separate the color blocks for clarity.
subplot <- ggplot(treemap_data, aes(area = area, fill = color_id)) +
  geom_treemap(color = "#FFFFFC", size = 1, start = "bottomright") +
  scale_fill_manual(values = colors) +
  theme_void() +
  theme(
    legend.position = "none",
    plot.background = element_rect(fill = "transparent", color = NA),
    panel.background = element_rect(fill = "transparent", color = NA),
    plot.margin = margin(0, 0, 0, 0)
  )

sticker(
  subplot = subplot,
  s_x = 1,
  s_y = 1,
  s_width = 1.5,
  s_height = 1.75,
  package = "ggconsulting",
  p_x = 0.72,
  p_y = 1.33,
  p_color = "#FFFFFF",
  p_family = "IBM Plex Sans",
  p_size = 4,
  h_fill = "#FFFFFF",
  h_color = "#000000",
  h_size = 1.2,
  filename = "man/figures/logo.png",
  dpi = 400,
  spotlight = FALSE,
  white_around_sticker = TRUE
)
