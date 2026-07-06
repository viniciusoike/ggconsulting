# Our World in Data house style — brief

Corpus: 8 charts in `general/owid-*.png`. Archetype: **editorial**
(annotation-forward, explanatory). Hexes sampled from screenshots.
Note: OWID publishes under CC BY with open-source tooling, so this style is
unusually well documented upstream if deeper reference is ever needed.

## Ground

- Plain white ground, thin light frame around the figure.
- Logo badge top-right and a "Data source: … | CC BY" footer line.

## Palette (sampled)

| Role                     | Hex       |
| ------------------------ | --------- |
| title text (serif)       | `#2D2E2D` |
| body text                | `#5B5B5B` |
| navy                     | `#092045` / `#536998` |
| green                    | `#468267` / `#549B98` |
| rust/orange              | `#A43F1D` / `#B56342` |
| purple                   | `#67408D` / `#AC7AAD` |
| brown/tan                | `#936F42` / `#A6775A` |
| maroon                   | `#975D62` |
| salmon                   | `#DD907F` |
| aggregate grey           | `#8C9199` |

A genuinely multi-hue categorical palette, but every hue is muted/desaturated
to a similar chroma level, so no series shouts. **Aggregates (world average,
benchmark) are always grey**, colours are reserved for entities.

## Typography

- Serif display headline (free equivalent: Playfair Display) over sans body
  (Lato). Headlines state the finding; coloured keywords in the title mirror
  series colours ("least satisfied" set in the rust of the low group).
- Sentence-length subtitles that explain the measure in plain words.

## Grid, axes, legend

- Dashed, very light gridlines; often only a baseline.
- No legend blocks: series names inside area bands (white bold), coloured
  entity names at the left of slope charts, coloured column headers over
  paired bars.
- Values labelled directly: at both ends of slopes, beside bars, inside
  stacked segments; tiny series pulled out with bracket + label.

## Annotation conventions

- Curved arrow + short prose annotation, with bold and colour inside the
  annotation text keyed to the series ("Rates have fallen by **over
  three-quarters** in Central and South Asia").
- Group annotations label clusters of bars ("The four countries with the
  highest score") rather than individual values.

## What ggconsulting takes from this

- The muted-equal-chroma categorical palette is the best template in the
  corpus for a 6-hue ggconsulting palette that stays executive-calm; compare
  against `scale_*_ct()` interpolation behaviour.
- Grey-for-aggregate is a rule `ct_finish(highlight = ...)` already
  approximates (muted_color) — document it as the intended idiom.
- Slope chart with end-value labels = design target for `ctplot::ct_slope()`.
- Coloured-keyword titles recur here and at FT — a `ggtext`-based helper is
  the natural implementation if it ever justifies the dependency.
