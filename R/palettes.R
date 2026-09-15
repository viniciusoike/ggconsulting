# Palette catalog ----

# Internal store. Each entry is a character vector of hex colours, with
# index 1 acting as the palette's "main" colour.
#
# Provenance rules: anchors and accents come from the reference corpus in
# data-raw/references/briefs/; mid-tones are derived from those anchors
# (fixed-weight blends, lightness-checked) so no colour is imported from an
# external system (Tailwind, Chakra, PowerBI, coolors, MS Office, Pantone,
# Flat UI, and the like).
.ct_palettes <- list(
  # anchors: McKinsey dark (briefs/mckinsey.md); mid-tones: anchor-to-cyan
  # blends desaturated to the corpus muted rule; accent: owned gold.
  strategy_navy = c(
    "#051C2C",
    "#153C50",
    "#1A5D7D",
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
  # ramp: blends of the owned crimson shades; [2] replaces the US-flag
  # "Old Glory Red" (#B22234).
  strategy_crimson = c(
    "#7A1F2B",
    "#9B343B",
    "#D75A5A",
    "#E8B5B5",
    "#3D5A6B",
    "#646E78"
  ),
  # ramp anchor: owned azure[2] darkened; replaces a colour that matched
  # Pantone Classic Blue 2020 (#0F4C81).
  strategy_azure = c(
    "#124B7F",
    "#1A6BB6",
    "#5FA3DC",
    "#B0D4F1",
    "#E8743C",
    "#646E78"
  ),
  # ramp anchor: blend of the strategy anchor toward the owned tail grey;
  # replaces a colour that matched Flat UI's "Midnight Blue".
  strategy_slate = c(
    "#30414E",
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
  # rebuilt from the editorial corpus (briefs/ft.md sampled table): FT
  # burgundy/rust/red ramp, a cream-washed tint of the red, FT teal as the
  # counter-hue accent, owned warm-grey tail. Replaces a palette that
  # matched coolors.co's 5-colour charcoal/persian-green/saffron set.
  editorial_oxide = c(
    "#74172F",
    "#AF4D3A",
    "#E15A60",
    "#F2ADA9",
    "#98CCB5",
    "#5C5550"
  )
)

# Palette accessor ----

#' Get palette colours
#'
#' @description
#' `r lifecycle::badge("experimental")`
#'
#' Returns the hex colour vector for a named palette, optionally subsetting
#' or interpolating to `n` colours. Called with no arguments, returns the
#' names of all available palettes.
#'
#' @param palette Palette name (e.g. `"strategy_navy"`) or `NULL` (default)
#'   to list available palette names.
#' @param n Number of colours to return. When `n` is smaller than the
#'   palette, the first `n` colours are returned. When `n` is larger,
#'   colours are interpolated via [grDevices::colorRampPalette()] (with a
#'   warning). Defaults to `NULL` (return the full palette).
#' @param reverse Reverse palette order before subsetting. Defaults to
#'   `FALSE`.
#'
#' @return A character vector of hex colours, or (when `palette` is `NULL`)
#'   a character vector of palette names.
#' @export
#' @examples
#' # List available palettes
#' ct_palette()
#'
#' # Full palette
#' ct_palette("strategy_navy")
#'
#' # First 3 colours
#' ct_palette("strategy_navy", n = 3)
#'
#' # Interpolate to 9 colours
#' ct_palette("strategy_navy", n = 9)
ct_palette <- function(palette = NULL, n = NULL, reverse = FALSE) {
  if (is.null(palette)) {
    return(names(.ct_palettes))
  }

  pal <- .resolve_palette(palette)
  if (reverse) {
    pal <- rev(pal)
  }

  if (is.null(n)) {
    return(pal)
  }

  n <- as.integer(n)
  n_pal <- length(pal)

  if (n <= n_pal) {
    return(pal[seq_len(n)])
  }

  cli::cli_warn(c(
    "Requested {n} colours from a palette of {n_pal}; interpolating.",
    "i" = "Consider a larger palette or a continuous scale via {.fn scale_color_ct_c}."
  ))
  grDevices::colorRampPalette(pal)(n)
}

# Palette resolver ----

.resolve_palette <- function(palette) {
  if (
    is.character(palette) &&
      length(palette) == 1L &&
      palette %in% names(.ct_palettes)
  ) {
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
