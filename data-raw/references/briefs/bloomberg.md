# Bloomberg house style — brief

Corpus: 3 charts in `general/bloomberg-*.png`. Archetype: **finance**.
Hexes sampled from screenshots. Thin corpus — treat as directional until more
finance refs are collected.

## Ground

- Pure white ground, high contrast, generous margins.

## Palette (sampled)

| Role                   | Hex       |
| ---------------------- | --------- |
| text / lead series     | `#000000` |
| signature orange       | `#F2A547` / `#F2A679` |
| yellow                 | `#FAE172` |
| magenta accent         | `#E44DA6` |
| context grey           | `#CCCCCC` |

Black is a first-class *series* colour, not just text. Orange is the brand
accent; grey carries context series and gridlines.

## Typography

- Bold, slightly condensed sans headline in black; plain descriptive
  subtitle beneath.
- Small-caps/letterspaced section labels used as in-plot region headers
  ("PRIVATE VALUATION | IPO | PUBLIC MARKET CAP").

## Grid, axes, legend

- **Right-side y-axis**; unit carried once on the top tick ("$6T" then
  5, 4, 3 …).
- Light horizontal gridlines only.
- Top legend with coloured tick/slash swatches for category groupings;
  individual series still get direct labels.

## Annotation conventions

- Endpoint emphasis: filled dot at the line terminus + bold name label,
  sometimes with a leader line.
- Long-form narrative annotation block set inside empty plot regions
  (2–4 sentences, not a caption).
- Split/composite x-axes for before-after framing (years before IPO | IPO |
  years after).

## What ggconsulting takes from this

- `theme_finance()` is currently serif/print-report tuned; Bloomberg suggests
  a screen-finance direction (white, black-as-series, single warm accent).
  Worth deciding deliberately rather than by default — the two looks serve
  different deliverables.
- Endpoint dot + bold label: extend `ct_finish(end_labels = TRUE)` to
  optionally draw the terminal point.
- Right-side y-axis again (also Economist) — strongest recurring candidate
  for a `ct_theme()` argument.
- Unit-on-top-tick labelling is a formatter concern: `fmt_*` variants that
  emit the symbol only for the maximum break.
