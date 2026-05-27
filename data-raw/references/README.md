# Reference Gallery

Visual reference catalog for `ggconsulting`'s three archetype themes
(`theme_strategy`, `theme_finance`, `theme_editorial`).

This directory is git-tracked but `.Rbuildignore`d — it's design ground truth,
not user-facing data.

## Structure

```
data-raw/references/
├── catalog.csv                 # master index, one row per ref
├── strategy/
│   ├── ref-001-<slug>.png
│   ├── ref-001-<slug>.yml
│   └── ...
├── finance/
│   └── ...
└── editorial/
    └── ...
```

## How references are collected

See `prompts/references-research.md` (Prompts A–D). Run them sequentially in a
Claude Code session with the `@playwright/mcp` server installed so the agent
can navigate, screenshot, and write the YAML/PNG/catalog row in one pass.

## Catalog columns

| Column        | Description                                     |
| ------------- | ----------------------------------------------- |
| `id`          | `ref-NNN` (3-digit zero-padded, monotonic)      |
| `archetype`   | `strategy` \| `finance` \| `editorial`          |
| `chart_type`  | `bar` \| `line` \| `waterfall` \| `slope` \| `dumbbell` \| `scatter` \| `area` \| `stacked_bar` \| `other` |
| `source_url`  | Direct URL where the chart was found            |
| `image_path`  | Relative path from `data-raw/references/`       |

## Legal guardrails (recap)

- No firm logos in PNGs (crop them out).
- No firm names in filenames or YAML field values (use generic publisher
  descriptors like `"Public report — large strategy consultancy"`).
- No chart titles copied verbatim — paraphrase.
- No proprietary font names asserted — describe the font and propose a free
  equivalent.
- Public material only (no paywalled content).
