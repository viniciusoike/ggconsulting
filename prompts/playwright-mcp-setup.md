# Setting up `@playwright/mcp` in Claude Code

This unblocks the references-research workflow: Claude Code gains the ability to
navigate URLs, screenshot regions, and save PNGs — combined with its file tools
it can produce the full `data-raw/references/` catalog in one autonomous run.

## 1. Prerequisites

Node 18+ already needed for `@playwright/mcp`. Verify:

```bash
node --version
```

Install the Chromium binary that Playwright drives (one-time, ~150 MB):

```bash
npx playwright install chromium
```

## 2. Add the MCP server

Pick **one** of the two approaches below.

### Option A — CLI (recommended; preserves your existing config)

From the `consultr` repo root:

```bash
claude mcp add playwright -s user -- npx -y @playwright/mcp@latest
```

- `-s user` = installs into your user-scope config (`~/.claude.json`), so the
  server is available in any project. Use `-s project` instead if you want the
  server only available inside this repo (writes to `.mcp.json` at the repo root,
  which can be checked in).
- `-y` on `npx` auto-confirms the first install of the package.

Verify it landed:

```bash
claude mcp list
```

You should see `playwright` alongside your existing servers.

### Option B — Edit the JSON directly

If you prefer to edit by hand, open the relevant config file and add this entry
inside `mcpServers`:

```jsonc
{
  "mcpServers": {
    // ... your existing servers stay untouched ...
    "playwright": {
      "command": "npx",
      "args": ["-y", "@playwright/mcp@latest"]
    }
  }
}
```

Config file locations:

| Scope    | Path                                          | When to use                       |
| -------- | --------------------------------------------- | --------------------------------- |
| user     | `~/.claude.json`                              | Available in every project        |
| project  | `<repo>/.mcp.json`                            | Only in this repo, committable    |

If both exist, project-scope takes precedence.

## 3. Restart Claude Code

After adding, exit and re-launch Claude Code so it picks up the new MCP. Then
inside a session, run:

```
/mcp
```

`playwright` should be listed with a green "connected" status. If not, the
panel will show stderr from the npx spawn — usually a missing Chromium binary
(fix: `npx playwright install chromium`).

## 4. What you can ask Claude Code to do after that

Inside a Claude Code session in the `consultr` repo:

```
Run prompts/references-research.md Prompt A. Use the playwright MCP to
navigate, screenshot, and crop. Write PNGs + YAML + catalog rows directly
to ggconsulting/data-raw/references/. Start with 3 strategy references so I
can review the YAML schema before you go further.
```

The agent will:

1. Search for candidate URLs (use its built-in WebSearch for discovery).
2. Use `playwright_navigate` + `playwright_screenshot` to capture chart regions.
3. Save the PNG with `Write` to the right archetype subfolder.
4. Sample colors visually (it's multimodal — it can read the PNG).
5. Write the `.yml` sidecar and append a row to `catalog.csv`.

## 5. Useful Playwright MCP tools

`@playwright/mcp` exposes (names vary by version, check `/mcp` panel for the
authoritative list):

- `browser_navigate(url)` — load a page
- `browser_snapshot()` — DOM accessibility tree (cheap, no pixels)
- `browser_take_screenshot({selector, fullPage, ...})` — PNG bytes
- `browser_click(ref)` — click via accessibility ref
- `browser_evaluate(js)` — run JS in the page (for cookie banners, expanding
  hidden sections, etc.)
- `browser_close()` — tear down the browser context

For chart capture, the most useful pattern is:

```
1. browser_navigate(article URL)
2. browser_snapshot() → identify the chart node's ref
3. browser_evaluate to scroll the chart into view if needed
4. browser_take_screenshot({ref, raw: true}) → save bytes to disk
```

## 6. Troubleshooting

- **"Cannot find module @playwright/mcp"** — the `-y` flag should handle this;
  if it persists, try a one-time global install: `npm i -g @playwright/mcp`.
- **Chrome download fails behind a proxy** — set `HTTPS_PROXY` in the env and
  re-run `npx playwright install chromium`.
- **MCP shows red in `/mcp`** — open the panel, copy the stderr, paste it back
  into a Claude Code session and ask it to debug.
- **Cookie banners block screenshots** — tell the agent to dismiss them via
  `browser_evaluate` or by clicking the "Accept all" button; many publishers
  also accept a `?gdpr=accept` query param.
