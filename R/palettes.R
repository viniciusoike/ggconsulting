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
  ),
  finance_classic = c(
    "#1A2B3D",
    "#3D5A7A",
    "#6D8AA6",
    "#A8BAC9",
    "#7A3030",
    "#525B68"
  ),
  finance_steel = c(
    "#243447",
    "#3F556E",
    "#7185A0",
    "#B4C0CE",
    "#6B7B3C",
    "#525B68"
  ),
  finance_burgundy = c(
    "#5A1F2B",
    "#8B3340",
    "#B5707A",
    "#D4B5BA",
    "#2A4A6B",
    "#525B68"
  ),
  editorial_warm = c(
    "#A8324A",
    "#D4593D",
    "#E89E3D",
    "#F2D49D",
    "#3D5A6B",
    "#5C5550"
  ),
  editorial_clay = c(
    "#7B3B30",
    "#B05E47",
    "#D08D6E",
    "#E8C9B0",
    "#4A6B5C",
    "#5C5550"
  ),
  editorial_oxide = c(
    "#264653",
    "#2A9D8F",
    "#E9C46A",
    "#F4A261",
    "#E76F51",
    "#5C5550"
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
