# Economist house style — brief

Corpus: 6 charts in `general/economist-*.png`. Archetype: **editorial**.
Hexes sampled from screenshots.

## Ground

- Warm light-grey figure ground `#F0EFEB`; plot area either the same grey or
  white (`#FFFFFF`) on web embeds.
- Signature small red tab at the top-left corner of the figure.

## Palette (sampled)

| Role                  | Hex       |
| --------------------- | --------- |
| ground                | `#F0EFEB` |
| title text            | `#181818` |
| red (lead series)     | `#D03D30` (canonical brand red is near `#E3120B`) |
| salmon (2nd series)   | `#EBA796` |
| coral (bubbles)       | `#E48377` |
| context grey          | `#C5C5BB` – `#DAD8D5` |

Red is the default single-series colour; secondary series get a tint of it
(salmon) rather than a new hue. Black is used as an *episode highlight* on a
red line, not as a series colour.

## Typography

- Compact bold sans headline, near-black, often just a labelled measure
  ("United States, adult obesity rate, %") — country/scope first, measure
  second, comma-separated.
- Sparse or absent subtitles; units live in the title.

## Grid, axes, legend

- **Right-side y-axis labels**, horizontal gridlines only.
- Minimal tick labels; abbreviated decade x-labels (1990, 95, 2000, 05).
- No legends: series labelled in place, in the series colour or with bold
  in-chart labels ("Obese", "Morbidly obese").

## Annotation conventions

- Point-plus-label episode annotations on the line ("Dot-com crash",
  "ChatGPT released"), with a filled dot at the referenced point.
- Highlight-vs-muted: one bold red line for the focal year over a grey
  spaghetti of prior years, labels set directly on the lines.
- Axis titles occasionally replaced by bold arrowed labels along the axes
  (scatter), with tick labels dropped entirely.

## What ggconsulting takes from this

- Right-side y-axis appears in Economist AND Bloomberg refs — recurring
  convention, candidate `ct_theme(axis_y = "right")` argument.
- Tint-of-lead-colour for secondary series is a palette-construction rule
  worth encoding (derive series 2 from series 1, not a separate hue).
- Episode dot+label annotation → same backlog helper as FT's event line.
- `ct_finish` highlight/muted already matches the focal-vs-context pattern.
