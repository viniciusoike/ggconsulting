# Preview ggconsulting palettes as a swatch

Returns a ggplot showing palettes as colour tiles with the hex value
overlaid in monospace. With `palette = NULL`, every palette shipped in
`.ct_palettes` is shown faceted.

## Usage

``` r
ct_palette_show(palette = NULL)
```

## Arguments

- palette:

  Palette name (e.g. `"strategy_emerald"`), character vector of colours,
  or `NULL` (default) to show every shipped palette.

## Value

A ggplot object.

## Examples

``` r
p_all  <- ct_palette_show()
p_one  <- ct_palette_show("strategy_emerald")
p_vec  <- ct_palette_show(c("#0F4D38", "#177B57", "#3DA876"))
```
