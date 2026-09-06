# Layout baselines (no font dependency) ----
# Use ct_theme() directly with font = "sans" to reproduce each archetype's
# layout without depending on installed fonts.

test_that("vdiffr: strategy col layout", {
  skip_on_cran()
  d <- aggregate(revenue_brl ~ business_unit, data = bu_quarterly, FUN = sum)
  p <- ggplot2::ggplot(d, ggplot2::aes(business_unit, revenue_brl)) +
    ggplot2::geom_col() +
    ct_theme(palette = "strategy_navy", font = "sans")
  vdiffr::expect_doppelganger("strategy-col-layout", p)
})

test_that("vdiffr: strategy line layout", {
  skip_on_cran()
  d <- ibov_sectors[ibov_sectors$sector_index == "IBOV", ]
  p <- ggplot2::ggplot(d, ggplot2::aes(date, close)) +
    ggplot2::geom_line() +
    ct_theme(palette = "strategy_navy", font = "sans")
  vdiffr::expect_doppelganger("strategy-line-layout", p)
})

test_that("vdiffr: finance col layout", {
  skip_on_cran()
  d <- aggregate(revenue_brl ~ business_unit, data = bu_quarterly, FUN = sum)
  p <- ggplot2::ggplot(d, ggplot2::aes(business_unit, revenue_brl)) +
    ggplot2::geom_col() +
    ct_theme(
      palette = "finance_classic", font = "sans",
      density = "tight", context = "report"
    ) +
    ggplot2::theme(
      plot.title         = ggplot2::element_text(face = "plain"),
      panel.grid.major.y = ggplot2::element_line(colour = "#EEEEEE", linewidth = 0.25),
      panel.grid.major.x = ggplot2::element_blank()
    )
  vdiffr::expect_doppelganger("finance-col-layout", p)
})

test_that("vdiffr: finance line layout", {
  skip_on_cran()
  d <- ibov_sectors[ibov_sectors$sector_index == "IBOV", ]
  p <- ggplot2::ggplot(d, ggplot2::aes(date, close)) +
    ggplot2::geom_line() +
    ct_theme(
      palette = "finance_classic", font = "sans",
      density = "tight", context = "report"
    ) +
    ggplot2::theme(
      plot.title         = ggplot2::element_text(face = "plain"),
      panel.grid.major.y = ggplot2::element_line(colour = "#EEEEEE", linewidth = 0.25),
      panel.grid.major.x = ggplot2::element_blank()
    )
  vdiffr::expect_doppelganger("finance-line-layout", p)
})

test_that("vdiffr: editorial col layout", {
  skip_on_cran()
  d <- aggregate(revenue_brl ~ business_unit, data = bu_quarterly, FUN = sum)
  p <- ggplot2::ggplot(d, ggplot2::aes(business_unit, revenue_brl)) +
    ggplot2::geom_col() +
    ct_theme(palette = "editorial_warm", font = "sans") +
    ggplot2::theme(
      plot.title    = ggplot2::element_text(size = ggplot2::rel(1.15), lineheight = 1),
      plot.subtitle = ggplot2::element_text(face = "italic")
    )
  vdiffr::expect_doppelganger("editorial-col-layout", p)
})

test_that("vdiffr: editorial line layout", {
  skip_on_cran()
  d <- ibov_sectors[ibov_sectors$sector_index == "IBOV", ]
  p <- ggplot2::ggplot(d, ggplot2::aes(date, close)) +
    ggplot2::geom_line() +
    ct_theme(palette = "editorial_warm", font = "sans") +
    ggplot2::theme(
      plot.title    = ggplot2::element_text(size = ggplot2::rel(1.15), lineheight = 1),
      plot.subtitle = ggplot2::element_text(face = "italic")
    )
  vdiffr::expect_doppelganger("editorial-line-layout", p)
})

test_that("vdiffr: ct_finish values + sort layout", {
  skip_on_cran()
  d <- aggregate(revenue_brl ~ business_unit, data = bu_quarterly, FUN = sum)
  p <- ggplot2::ggplot(d, ggplot2::aes(business_unit, revenue_brl)) +
    ggplot2::geom_col() +
    ct_finish(values = TRUE, sort = "desc") +
    ct_theme(palette = "strategy_navy", font = "sans")
  vdiffr::expect_doppelganger("finish-values-sort-layout", p)
})

test_that("vdiffr: ct_finish end_labels layout", {
  skip_on_cran()
  d <- market_share[market_share$company %in% c("Player A", "Player B", "Player C"), ]
  p <- ggplot2::ggplot(d, ggplot2::aes(year, share, colour = company)) +
    ggplot2::geom_line() +
    ct_finish(end_labels = TRUE) +
    ct_theme(palette = "strategy_navy", font = "sans")
  vdiffr::expect_doppelganger("finish-endlabels-layout", p)
})

test_that("vdiffr: palette show layout", {
  skip_on_cran()
  p <- ct_palette_show("strategy_navy")
  vdiffr::expect_doppelganger("palette-show-layout", p)
})

test_that("vdiffr: editorial cream ground layout", {
  skip_on_cran()
  d <- ibov_sectors[ibov_sectors$sector_index == "IBOV", ]
  p <- ggplot2::ggplot(d, ggplot2::aes(date, close)) +
    ggplot2::geom_line() +
    ct_theme(palette = "editorial_warm", font = "sans", paper = "cream")
  vdiffr::expect_doppelganger("editorial-paper-cream-layout", p)
})

test_that("vdiffr: ct_finish end_labels first_facet layout", {
  skip_on_cran()
  # Small multiples in the FT mould: every panel carries the same two
  # series over the same x range, so one set of labels serves all of them.
  d <- bu_quarterly[bu_quarterly$business_unit %in% c("Industrial", "Consumer"), ]
  long <- rbind(
    data.frame(quarter = d$quarter, bu = d$business_unit,
               metric = "Revenue", value = d$revenue_brl),
    data.frame(quarter = d$quarter, bu = d$business_unit,
               metric = "COGS", value = d$cogs_brl)
  )
  p <- ggplot2::ggplot(long, ggplot2::aes(quarter, value, colour = metric)) +
    ggplot2::geom_line() +
    ggplot2::facet_wrap(~bu) +
    ct_finish(end_labels = "first_facet", end_points = TRUE, axis_y = "right") +
    ct_theme(palette = "strategy_navy", font = "sans") +
    ggplot2::theme(legend.position = "none")
  vdiffr::expect_doppelganger("finish-first-facet-layout", p)
})

# Font baselines (local only) ----

test_that("vdiffr: strategy col font", {
  skip_on_cran()
  skip_if_not(has_font("Inter"))
  d <- aggregate(revenue_brl ~ business_unit, data = bu_quarterly, FUN = sum)
  p <- ggplot2::ggplot(d, ggplot2::aes(business_unit, revenue_brl)) +
    ggplot2::geom_col() +
    theme_strategy()
  vdiffr::expect_doppelganger("strategy-col-font", p)
})

test_that("vdiffr: strategy line font", {
  skip_on_cran()
  skip_if_not(has_font("Inter"))
  d <- ibov_sectors[ibov_sectors$sector_index == "IBOV", ]
  p <- ggplot2::ggplot(d, ggplot2::aes(date, close)) +
    ggplot2::geom_line() +
    theme_strategy()
  vdiffr::expect_doppelganger("strategy-line-font", p)
})

test_that("vdiffr: finance col font", {
  skip_on_cran()
  skip_if_not(has_font("Source Serif 4"))
  d <- aggregate(revenue_brl ~ business_unit, data = bu_quarterly, FUN = sum)
  p <- ggplot2::ggplot(d, ggplot2::aes(business_unit, revenue_brl)) +
    ggplot2::geom_col() +
    theme_finance()
  vdiffr::expect_doppelganger("finance-col-font", p)
})

test_that("vdiffr: finance line font", {
  skip_on_cran()
  skip_if_not(has_font("Source Serif 4"))
  d <- ibov_sectors[ibov_sectors$sector_index == "IBOV", ]
  p <- ggplot2::ggplot(d, ggplot2::aes(date, close)) +
    ggplot2::geom_line() +
    theme_finance()
  vdiffr::expect_doppelganger("finance-line-font", p)
})

test_that("vdiffr: editorial col font", {
  skip_on_cran()
  skip_if_not(has_font("Source Serif 4"))
  d <- aggregate(revenue_brl ~ business_unit, data = bu_quarterly, FUN = sum)
  p <- ggplot2::ggplot(d, ggplot2::aes(business_unit, revenue_brl)) +
    ggplot2::geom_col() +
    theme_editorial()
  vdiffr::expect_doppelganger("editorial-col-font", p)
})

test_that("vdiffr: editorial line font", {
  skip_on_cran()
  skip_if_not(has_font("Source Serif 4"))
  d <- ibov_sectors[ibov_sectors$sector_index == "IBOV", ]
  p <- ggplot2::ggplot(d, ggplot2::aes(date, close)) +
    ggplot2::geom_line() +
    theme_editorial()
  vdiffr::expect_doppelganger("editorial-line-font", p)
})

test_that("vdiffr: ct_finish values + sort font", {
  skip_on_cran()
  skip_if_not(has_font("Inter"))
  d <- aggregate(revenue_brl ~ business_unit, data = bu_quarterly, FUN = sum)
  p <- ggplot2::ggplot(d, ggplot2::aes(business_unit, revenue_brl)) +
    ggplot2::geom_col() +
    ct_finish(values = TRUE, sort = "desc") +
    theme_strategy()
  vdiffr::expect_doppelganger("finish-values-sort-font", p)
})

test_that("vdiffr: ct_finish end_labels font", {
  skip_on_cran()
  skip_if_not(has_font("Inter"))
  d <- market_share[market_share$company %in% c("Player A", "Player B", "Player C"), ]
  p <- ggplot2::ggplot(d, ggplot2::aes(year, share, colour = company)) +
    ggplot2::geom_line() +
    ct_finish(end_labels = TRUE) +
    theme_strategy()
  vdiffr::expect_doppelganger("finish-endlabels-font", p)
})

test_that("vdiffr: palette show font", {
  skip_on_cran()
  skip_if_not(has_font("Inter"))
  p <- ct_palette_show("strategy_navy")
  vdiffr::expect_doppelganger("palette-show-font", p)
})
