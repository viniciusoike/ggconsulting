# FT house style — brief

Corpus: ~40 charts in `general/ft-*.png` (markets, economics, data-journalism
small multiples). Archetype: **editorial**. Hexes sampled from screenshots;
screen colour profile shifts them slightly from canonical values.

## Ground

- Cream page ground `#FFF1E5` (sampled `#FDF2E6`) fills the entire figure —
  no panel-vs-plot distinction, no panel border.
- Short thick black rule (top-left) above the headline anchors the figure.

## Palette (sampled)

| Role                    | Hex       |
| ----------------------- | --------- |
| ground                  | `#FDF2E6` |
| title text              | `#33302E` |
| body/axis text          | `#66605C` |
| gridline                | `#CAC2B8` – `#E4DACF` |
| primary blue (series)   | `#265394` |
| sky blue                | `#458DC7` |
| rose/pink               | `#E9639A` |
| red (negative/warm)     | `#E15A60` |
| burgundy (emphasis)     | `#74172F` |
| rust                    | `#AF4D3A` |
| teal green              | `#98CCB5` |

Diverging encodings pair blue (negative/cool) with red (positive/warm); the
most recent period is often re-emphasised in a darker shade of the series hue.

## Typography

- Humanist sans, high x-height, two weights (regular/bold). Free equivalents:
  Inter, Source Sans 3.
- Headline: bold, sentence case, dark; either a takeaway statement or plainly
  descriptive. Occasionally one keyword is set in a series colour to replace a
  legend entry.
- Subtitle carries units and scope ("Indices rebased", "Temperature (°C)") —
  axes then need no titles.

## Grid, axes, legend

- Horizontal gridlines only, warm-grey hairline; baseline slightly stronger.
- No vertical gridlines ever; x-axis has small outward ticks.
- Legend policy: top-aligned swatch legend for 2–4 series, otherwise **direct
  labels** — at line ends, or set once inside the first facet panel only.
  Never a boxed right-side legend.

## Annotation conventions

- Event reference line: dotted/dashed vertical with a plain-text label at top
  ("General election", "Russia invades Ukraine").
- Range bands: grey min–max band labelled in place ("2015-23 range") with
  highlighted year-lines over it.
- Data-journalism pieces (small multiples, strip distributions) use curved
  arrows + short italic annotations.
- Source note: "Source: …" small, grey, bottom; publisher wordmark
  bottom-left (not something to replicate).

## What ggconsulting takes from this

- Cream ground option for `theme_editorial()` (e.g. `paper = "#FFF1E5"`)
  including `plot.background`, not just panel.
- `ct_finish(end_labels = TRUE)` matches the direct-label policy — extend it
  with a label-in-first-facet-only mode.
- Backlog: event-line annotation helper (vline + top label), range-band layer,
  darkened-final-period emphasis in `ct_finish(highlight = ...)`.
- Cross-check `editorial_warm` palette hues against the sampled table above.
