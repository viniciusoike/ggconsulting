# IMF house style — brief

Corpus: 10 charts in `finance/imf_*.png`, all from the October 2025 World
Economic Outlook. Archetype: **finance**. Hexes sampled from the PNGs by pixel
frequency.

The WEO exhibits are the most internally consistent set in the whole reference
corpus. Four hues, one legend policy, one panel construction, repeated across
ten figures with no drift. That consistency is the finding, and it makes the
IMF the best template available for `theme_finance()`. It also contradicts
three things `theme_finance()` currently does.

## Ground

- Pure white `#FFFFFF`, 73–92% of pixels. No panel fill, no panel border, no
  figure border.
- Multi-panel figures stack vertically in a shared column grid with generous
  gutters. Panels never get a box.

## Palette (sampled)

The same four hues carry every figure, in the same order.

| Slot | Role                | Hex       | Present in |
| ---- | ------------------- | --------- | ---------- |
| 1    | blue                | `#315CA1` | 10 of 10   |
| 2    | brick red           | `#9D2D32` | 10 of 10   |
| 3    | ochre               | `#EABE5D` | 8 of 10    |
| 4    | olive green         | `#53743F` | 5 of 10    |
| 5    | periwinkle          | `#8799C6` | 3 of 10    |
| —    | aggregate / total   | `#000000` | overlay lines only |
| —    | forecast block      | `#E0E0E1` | behind the marks   |
| —    | interquartile band  | `#C9CFE5` | behind the marks   |

**Slots 5 and up are tints of slots 1 to 4.** Lightening a hue by roughly 40%
toward white produces the next family: `#315CA1` → `#8799C6`, `#9D2D32` →
`#C28A7C`, `#53743F` → `#9CA989`. `imf_panel_cols_2` uses the whole tint row at
once as a second group, and `imf_panel_lines_shade` uses the lightened blue as
an ordinary fifth series. The interquartile band lightens once more, to
`#C9CFE5`.

That is a palette system rather than a colour list. Eight series stay legible
because the reader sorts them by hue first and by lightness second.

**Black is reserved.** It never takes a categorical slot. Black draws the
aggregate or total that a stacked figure sums to, so the total reads as a
different kind of quantity than its components.

## Typography

Humanist sans throughout, in two weights. Free equivalents: Inter, Source Sans
3, Fira Sans.

The WEO sets its *body text* in serif and its *exhibits* in sans. Only the
exhibits are the reference here.

- Figure title: **bold**, set in the lead series blue `#315CA1`, not in black.
  It names the topic rather than the takeaway, in contrast to McKinsey.
- Directly beneath it, an italic parenthetical carries the unit, in the same
  blue. Axis titles are then unnecessary and absent.
- Panel titles: bold, numbered, inline at the panel's top-left, sitting level
  with the topmost y tick label rather than on a line of their own.
- Notes: regular sans, left-aligned, full figure width, `Sources:` line then
  `Note:` line. The note carries series definitions, sample sizes, and every
  abbreviation expansion.

## Grid, axes, legend

- **No gridlines**, horizontal or vertical.
- **Mirrored tick dashes.** Short dashes sit at every y break on both the left
  and right edges. The left ones carry labels, the right ones do not. Together
  they let the eye track a level across a wide panel, doing a gridline's job
  with a fraction of the ink.
- A thin grey rule marks zero when the data crosses it. Only at zero, never at
  other breaks.
- The x axis draws a solid line with outward ticks. Dates stack over two lines
  and abbreviate with a period (`Jan.` above `2019`).
- **One legend above the whole figure**, shared across every panel. Horizontal,
  wrapping to a second row, line-segment swatches rather than boxes, no legend
  title, no surrounding box. Direct labels appear only in the bubble scatters,
  where country codes sit beside the points.

## Annotation conventions

- **Forecast horizons are shaded, not dashed.** A grey `#E0E0E1` block sits
  behind the projected years while the line style continues unchanged. BIS and
  McKinsey change the line instead. Shading is the more legible choice when
  several series enter the forecast together.
- **Uncertainty as a band**, drawn in the tint of the series hue, no border.
- **Vintage comparison by overlay.** Square markers sit on top of current bars
  to carry the previous release, so one panel holds two vintages without
  grouping the bars.
- **Ranges as thick bars.** `imf_panel_scatter_col` draws an interquartile span
  as a single thick bar with two square markers on it. This is the nearest the
  institutional corpus comes to a dumbbell.
- **45-degree reference lines** where deviation from the diagonal is the point.
- Residual categories are folded into a named component and disclosed in the
  note, never left unlabelled.

## Where `theme_finance()` diverges

Three of the theme's current choices contradict the reference it is meant to
follow. BACEN, which the coverage notes rank second for this archetype, sides
with the IMF on all three.

| `theme_finance()` today | IMF exhibits |
| ----------------------- | ------------ |
| `Source Serif 4`, serif fallback chain | humanist sans |
| `plot.title` forced to `face = "plain"` | bold title, in the lead series blue |
| `panel.grid.major.y` at `#EEEEEE` | no gridlines; mirrored tick dashes |

The serif assumption looks like it came from the *report body*, which is indeed
serif. The charts inside it are not. Reading the exhibits alone, the
print-report look comes from density, muted hues, and shared legends, not from
the letterform.

`finance_classic` is also a different kind of object than the IMF palette. It
ramps one navy from `#1A2B3D` to `#A8BAC9` and adds a brick accent, which suits
a sequential or highlight encoding. The IMF palette is qualitative, four
distinct hues wide before it starts tinting, and it holds six series apart
where the navy ramp would muddy them.

## What ggconsulting takes from this

- Add a categorical finance palette from the sampled table. `#9D2D32` already
  sits close to `finance_classic[5]`, so the two families can share an accent.
- Generate extended palette slots by lightening toward white by ~40% rather
  than by interpolating between existing colours, which is what
  `scale_colour_ct()` does when the data outruns the palette. Tinting keeps hue
  identity; interpolation invents in-between hues that name nothing.
- Reconsider the serif default, or at least document that it follows report
  body text rather than institutional chart practice.
- Reserve black for totals and aggregates in the finance archetype, and keep it
  out of the categorical scales.
- Backlog: a mirrored-tick axis option as a gridline alternative; a
  forecast-shading helper taking a start value and drawing the block behind the
  layers; a range-bar geom covering the thick-bar-with-markers construction,
  which likely shares an implementation with `ct_dumbbell()`.
