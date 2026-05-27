# Palette catalog ----

# Internal store. Each entry is a character vector of hex colours, with
# index 1 acting as the palette's "main" colour.
.ct_palettes <- list(
  strategy_navy = c(
    "#051C2C",
    "#1F4E79",
    "#4B8BBE",
    "#9FBFD9",
    "#C8A064",
    "#646E78"
  ),
  strategy_emerald = c(
    "#0F4D38",
    "#177B57",
    "#3DA876",
    "#A8D5C2",
    "#C8A064",
    "#646E78"
  ),
  strategy_crimson = c(
    "#7A1F2B",
    "#B22234",
    "#D75A5A",
    "#E8B5B5",
    "#3D5A6B",
    "#646E78"
  ),
  strategy_azure = c(
    "#0F4C81",
    "#1A6BB6",
    "#5FA3DC",
    "#B0D4F1",
    "#E8743C",
    "#646E78"
  ),
  strategy_slate = c(
    "#2C3E50",
    "#4F6D8A",
    "#7BA4C4",
    "#C5D5E3",
    "#D4945A",
    "#646E78"
  )
)

# Palette resolver ----

.resolve_palette <- function(palette) {
  if (is.character(palette) && length(palette) == 1L &&
      palette %in% names(.ct_palettes)) {
    return(.ct_palettes[[palette]])
  }
  if (is.character(palette)) {
    return(palette)
  }
  cli::cli_abort(c(
    "{.arg palette} must be a palette name or character vector of colours.",
    "i" = "Known palettes: {.val {names(.ct_palettes)}}."
  ))
}
