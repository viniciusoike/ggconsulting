# References Research — Claude Code Runbook

Operational guide for executing `prompts/references-research.md` from a Claude
Code session with `@playwright/mcp` installed.

## Prerequisites

1. `@playwright/mcp` configured — see `prompts/playwright-mcp-setup.md`.
2. Working directory: repo root (so paths like
   `ggconsulting/data-raw/references/` resolve).
3. Directory scaffold already exists (created by this Cowork session):

   ```
   ggconsulting/data-raw/references/
   ├── README.md
   ├── catalog.csv                  # header only, ready for appends
   ├── _TEMPLATE.yml                # schema reference
   ├── strategy/
   ├── finance/
   └── editorial/
   ```

## Suggested session sequence

### Session 1 — Prompt A pilot (3 strategy refs)

```
Read prompts/references-research.md and prompts/references-research-runbook.md.

Run Prompt A from references-research.md, but ONLY collect 3 STRATEGY
references first. Use the playwright MCP for navigation and screenshots.
Write PNG + YAML + a row in catalog.csv for each.

After the third one, stop and summarize what you collected so I can review the
YAML schema and the legal guardrails before you continue.
```

After review, kick off the rest:

```
Looks good, continue Prompt A — collect the remaining strategy refs to hit 12,
then move on to finance (12) and editorial (12). Pause and summarize after
each archetype.
```

### Session 2 — Prompt B (chart-type focus)

Run after Session 1's catalog is in place. Same pattern, but invoke Prompt B
and instruct the agent to keep `ref-NNN` numbering monotonic from where the
catalog left off.

### Session 3 — Prompt C (palettes) + Prompt D (typography)

These are mostly synthesis over the existing catalog — no new browsing
required. Can be run with or without Playwright.

## Cost / time budget

- Prompt A full run: roughly 30–50 chart pages visited, ~30 minutes of agent
  wall-clock time, but realistically you'll want to babysit the first
  archetype to make sure the YAML conventions are being followed.
- Token cost: dominated by screenshots in context. Compress aggressively or
  ask the agent to take small targeted screenshots (chart region only, not
  full pages).

## Quality gates before merging the catalog

After each archetype completes, sanity-check:

```r
# In R, from ggconsulting/
catalog <- readr::read_csv("data-raw/references/catalog.csv")
catalog |> dplyr::count(archetype, chart_type)
```

- Each archetype has ≥4 distinct chart types.
- No firm names in `image_path` or `source_url` filenames.
- All YAML files parse:

  ```r
  ymls <- fs::dir_ls("data-raw/references", recurse = TRUE, glob = "*.yml") |>
    purrr::keep(~ !grepl("_TEMPLATE", .x))
  purrr::walk(ymls, yaml::read_yaml)  # any parse error throws
  ```

## When something goes wrong

- **Agent saves a logo by accident**: tell it to re-crop and re-save the PNG
  with the logo removed. Don't try to edit the YAML in place — regenerate it.
- **Catalog gets out of sync with files**: ask the agent to rebuild
  `catalog.csv` from the YAML files in each archetype subfolder.
- **Duplicate-looking references**: have the agent dedupe by `source.url` and
  visual similarity; the second collector should check `catalog.csv` before
  saving.
- **Playwright crashes mid-run**: numbering is per-archetype, so the agent can
  resume by scanning the highest `ref-NNN-*.yml` filename in each folder.
