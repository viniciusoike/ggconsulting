# McKinsey house style — brief

Corpus: 11 charts. Three carry deep-dive YAML in `strategy/` (`ref-001` to
`ref-003`, from Global Economics Intelligence); eight sit in
`general/mckinsey-*.png`, drawn from two McKinsey Global Institute reports.
Archetype: **strategy**. Hexes sampled from the PNGs by pixel frequency, so
compression shifts them a little from canonical values.

McKinsey anchors the strategy archetype. Where the editorial publishers argue
about ground colour and the institutions argue about panel density, these
charts argue about one thing, which is how much of the analysis the chart
itself should state.

## Ground

- White throughout. No panel fill, no plot border, no rules around the figure.
- White carries 73–91% of pixels in every reference. The archetype spends its
  ink on marks and labels, not on furniture.

## Palette (sampled)

Two dark anchors coexist across the corpus, and both appear inside the same
report, so they are alternates rather than a revision.

| Role                      | Hex       | Seen in                          |
| ------------------------- | --------- | -------------------------------- |
| dark anchor (near-black)  | `#051C2C` | GEI refs, pay-gap bridge         |
| dark anchor (indigo)      | `#061F79` | trade-geometry report, bubbles   |
| signature cyan            | `#00A9F4` | positives, primary series, fills |
| electric blue             | `#2251FF` | second categorical slot          |
| magenta                   | `#9C217D` | losses, counterfactual overlays  |
| aqua                      | `#20E9DA` | third categorical slot           |
| mid grey (context)        | `#B2B2B2` | residuals, de-emphasised series  |
| light grey (structure)    | `#D8D8D8` | connectors, brackets, rules      |
| text grey (source note)   | `#7F7F7F` | notes and attribution            |

The palette runs cold. No red, no orange, no gold appears anywhere in eleven
charts, which is the sharpest single difference from the editorial publishers.

**Negatives are dark, not red.** `ref-003` encodes a contracting economy as
near-black against cyan positives and lets the minus sign carry the rest. The
two bridges encode losses as magenta, which reads as "other direction" rather
than as "bad". Whichever encoding a chart picks, it also states direction a
second way, through a sign, a triangle glyph, or a label position, so the
chart survives grayscale printing.

**Grey means context.** Residual categories, unhighlighted comparison points,
and the tail of a distribution all drop to `#B2B2B2`. Grey is a semantic slot
in this palette, not a leftover.

## Typography

- Geometric humanist sans, two weights. Free equivalents: Inter, Source Sans 3.
- Title: bold, large, left-aligned, near-black, and written as a **full
  takeaway sentence** that names the finding. Titles run to two lines and often
  name both the winner and the loser.
- Subtitle: carries scope and units only. It sits either above the plot or, in
  the GEI charts, in a dedicated left margin column beside it, which buys
  vertical room for the plot.
- Data labels: tabular numerals, no `%` sign, because the subtitle already
  states the unit.
- Label colour follows the mark it sits on. White inside a saturated bar, dark
  outside a dark one. `ref-003` does both in one chart.

## Grid, axes, legend

- **No gridlines.** Not faint ones, none. Nine of eleven references draw no
  gridline at all; the remaining two draw a single zero rule.
- Y axis frequently omitted outright. Bar heights plus printed values carry the
  numbers, and the baseline is implied by the bars themselves.
- X ticks are sparse and abbreviated. Dates stack over two lines (`Mar` above
  `2025`), and long series label every third or fourth year.
- **No legend block anywhere in the corpus.** Series are named at the end of
  the line, once beside the first column of a stack, or inside the segment.
  Panels of a small multiple share one caption and label the categories once.

## Annotation conventions

Annotation is where these charts spend the budget the gridlines gave back.

- **Prose callouts on curved arrows.** Short sentences point at the region they
  describe, rather than sitting in a caption below.
- **Estimated and forecast periods** get a dashed final segment plus a grey
  band behind it, so the reader sees the boundary twice.
- **Brackets** annotate a span and label it with a derived quantity, such as
  the share of a total gap or the size of an unreplaced tail.
- **Overlay markers** carry a second vintage or a counterfactual onto an
  existing bar. A magenta dot on a stacked column says "and this is what it
  would have been" without a second panel.
- **Marker hierarchy**: filled circles for series the reader should follow,
  hollow circles for context (`ref-002`).
- **Truncated axes are disclosed** with an inset panel showing the full range.
- Source block sits bottom-left in small grey type, with `Note:` on its own
  line before `Source:`.

## Waterfalls

The corpus holds the only two waterfalls collected anywhere, and they are
structurally different constructions that a `ct_waterfall()` must both cover.

1. **Running bridge** (`mckinsey-waterfall-import-bridge`): navy anchor totals
   at each end, signed floating deltas between them, thin connectors joining
   consecutive bars, blue for gains and magenta for losses, grey for the
   residual.
2. **Two-anchor bridge** (`mckinsey-waterfall-pay-gap-bridge`): descending from
   one anchor bar to another, deltas floating between, no connectors. Each
   delta stacks value, label, and share-of-total beneath it in italic, and a
   right-hand bracket annotates the gap being decomposed.

Both restate direction with a small triangle under or beside the bar.

## What ggconsulting takes from this

- `strategy_navy` matches McKinsey only at index 1 (`#051C2C`). Its mid-tones
  are muted where McKinsey's are saturated, and its `#C8A064` accent has no
  counterpart in any reference. A palette built from the sampled table above
  would track the archetype more closely.
- Reserve a grey slot for context in the strategy palettes and let
  `ct_finish(highlight = )` route unhighlighted categories to it.
- `ct_finish(values = TRUE)` should pick label colour from the fill's
  luminance, placing light labels inside saturated bars and dark labels
  outside dark ones.
- Consider a `ct_finish()` mode that drops the y axis entirely once value
  labels are on, since the numbers are then printed twice.
- `theme_strategy()` should keep gridlines off by default rather than faint.
  Faint is a compromise the reference never makes.
- Backlog: `ct_waterfall()` covering both bridge variants, with connectors and
  a direction glyph as options; a marker-prominence argument on `ct_line()`
  for the filled-versus-hollow hierarchy; a forecast-band helper pairing a
  dashed segment with a grey block.
