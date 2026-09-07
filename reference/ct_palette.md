# Get palette colours

**\[experimental\]**

Returns the hex colour vector for a named palette, optionally subsetting
or interpolating to `n` colours. Called with no arguments, returns the
names of all available palettes.

## Usage

``` r
ct_palette(palette = NULL, n = NULL, reverse = FALSE)
```

## Arguments

- palette:

  Palette name (e.g. `"strategy_navy"`) or `NULL` (default) to list
  available palette names.

- n:

  Number of colours to return. When `n` is smaller than the palette, the
  first `n` colours are returned. When `n` is larger, colours are
  interpolated via
  [`grDevices::colorRampPalette()`](https://rdrr.io/r/grDevices/colorRamp.html)
  (with a warning). Defaults to `NULL` (return the full palette).

- reverse:

  Reverse palette order before subsetting. Defaults to `FALSE`.

## Value

A character vector of hex colours, or (when `palette` is `NULL`) a
character vector of palette names.

## Examples

``` r
# List available palettes
ct_palette()
#>  [1] "strategy_navy"    "strategy_emerald" "strategy_crimson" "strategy_azure"  
#>  [5] "strategy_slate"   "finance_classic"  "finance_steel"    "finance_burgundy"
#>  [9] "editorial_warm"   "editorial_clay"   "editorial_oxide" 

# Full palette
ct_palette("strategy_navy")
#> [1] "#051C2C" "#1F4E79" "#4B8BBE" "#9FBFD9" "#C8A064" "#646E78"

# First 3 colours
ct_palette("strategy_navy", n = 3)
#> [1] "#051C2C" "#1F4E79" "#4B8BBE"

# Interpolate to 9 colours
ct_palette("strategy_navy", n = 9)
#> Warning: Requested 9 colours from a palette of 6; interpolating.
#> ℹ Consider a larger palette or a continuous scale via `scale_color_ct_c()`.
#> [1] "#051C2C" "#153B5C" "#2A5D8A" "#4583B5" "#74A4CB" "#A4BBCA" "#BDA781"
#> [8] "#A28D6B" "#646E78"
```
