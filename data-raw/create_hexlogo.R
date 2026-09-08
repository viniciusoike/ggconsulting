# ==============================================================================
# Official Hexagon Logo Generator for ggconsulting
# ==============================================================================
#
# This script generates the official package hexagon logo.
# The logo features a treemap visualization showcasing core ggconsulting
# colors arranged using fibonacci proportions, in the same style as the
# benviplot hex logo.
#
# Requirements:
#   - ggplot2: For creating the treemap visualization
#   - treemapify: For geom_treemap functionality
#   - hexSticker: For generating the hexagonal sticker
#   - ggconsulting: The package itself (loaded via pkgload)
#   - showtext: For custom font rendering (Poppins)
#   - magick: For post-processing transparency effects
#
# Output:
#   - man/figures/logo.png (light version)
#   - man/figures/logo_dark.png (dark version)
#   - man/figures/logo_cropped.png (official, transparent background)
#
# ==============================================================================

# Load required packages ----

library(ggplot2)
library(treemapify)
library(hexSticker)
library(magick)
library(showtext)
pkgload::load_all(quiet = TRUE)

# Setup fonts for high-quality rendering
font_add_google("Poppins", "Poppins")
showtext_opts(dpi = 300)
showtext_auto()

# Select colors from ggconsulting palettes ----

colors_showcase <- c(
  ct_palette("strategy_navy")[2],     # main brand color
  ct_palette("strategy_azure")[3],
  ct_palette("editorial_warm")[2],
  ct_palette("strategy_emerald")[3],
  ct_palette("editorial_oxide")[3],
  ct_palette("strategy_navy")[5],
  ct_palette("finance_classic")[1]
)

# Create fibonacci-based proportions for treemap areas
# This creates visually pleasing relative sizes following the golden ratio
fib <- c(1, 1, 2, 3, 5, 8, 13, 21)
fib <- 1 / fib
fib <- fib[-1]

# Prepare treemap data
# Each color gets an area proportional to fibonacci values
treemap_data <- data.frame(
  area = fib[1:length(colors_showcase)],
  color_id = factor(1:length(colors_showcase)),
  fill_color = colors_showcase
)

# Create treemap visualization
# White borders separate color blocks for clarity
subplot <- ggplot(treemap_data, aes(area = area, fill = color_id)) +
  geom_treemap(color = "#FFFFFF", size = 2) +
  scale_fill_manual(values = colors_showcase) +
  theme_void() +
  theme(
    legend.position = "none",
    plot.background = element_rect(fill = "transparent", color = NA),
    panel.background = element_rect(fill = "transparent", color = NA),
    plot.margin = margin(0, 0, 0, 0)
  )

# Generate light version of hexagon sticker
# White background with navy border following ggconsulting brand colors
# Subplot geometry keeps the treemap inside the hexagon's tapered bottom
sticker(
  subplot = subplot,
  s_x = 1,
  s_y = 0.72,
  s_width = 1.15,
  s_height = 0.78,
  package = "ggconsulting",
  p_x = 1,
  p_y = 1.45,
  p_color = "#000000",
  p_family = "Poppins",
  p_size = 5,
  h_fill = "#FFFFFF",
  h_color = "#1F4E79",
  h_size = 0.5,
  filename = "man/figures/logo.png",
  dpi = 300,
  spotlight = FALSE,
  white_around_sticker = TRUE
)

# Generate dark version of hexagon sticker
# Navy background with black border for use on dark backgrounds
sticker(
  subplot = subplot,
  s_x = 1,
  s_y = 0.72,
  s_width = 1.15,
  s_height = 0.78,
  package = "ggconsulting",
  p_x = 1,
  p_y = 1.45,
  p_color = "#FFFFFF",
  p_family = "Poppins",
  p_size = 5,
  h_fill = "#1F4E79",
  h_color = "#000000",
  h_size = 1,
  filename = "man/figures/logo_dark.png",
  dpi = 300,
  white_around_sticker = TRUE
)

# Post-process dark version to add transparency
# The magick package removes white background by making it transparent
# Flood-fills start at each corner of the actual rendered image
p <- image_read("man/figures/logo_dark.png")
dim <- image_info(p)

pp <- p |>
  image_fill(
    color = "transparent", refcolor = "white", fuzz = 4,
    point = paste0("+1+1")
  ) |>
  image_fill(
    color = "transparent", refcolor = "white", fuzz = 4,
    point = paste0("+", dim$width - 2, "+1")
  ) |>
  image_fill(
    color = "transparent", refcolor = "white", fuzz = 4,
    point = paste0("+1+", dim$height - 2)
  ) |>
  image_fill(
    color = "transparent", refcolor = "white", fuzz = 4,
    point = paste0("+", dim$width - 2, "+", dim$height - 2)
  )

image_write(image = pp, path = "man/figures/logo_cropped.png")

cli::cli_inform(c(
  "v" = "Hex logo created successfully!",
  "-" = "man/figures/logo.png (light version)",
  "-" = "man/figures/logo_dark.png (dark version)",
  "-" = "man/figures/logo_cropped.png (official, transparent background)"
))
