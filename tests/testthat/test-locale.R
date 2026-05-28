test_that("ct_locale flips the active locale and returns the previous", {
  current <- getOption("ggconsulting.locale", "pt-BR")
  withr::defer(options(ggconsulting.locale = current))

  prev <- ct_locale("en-US")
  expect_equal(.current_locale(), "en-US")
  expect_equal(prev, current)

  ct_locale("pt-BR")
  expect_equal(.current_locale(), "pt-BR")
})

test_that("fmt_number uses pt-BR marks by default", {
  expect_equal(fmt_number(decimals = 1)(1234.5), "1.234,5")
})

test_that("fmt_number with locale = 'en-US' uses US marks", {
  expect_equal(fmt_number(decimals = 1, locale = "en-US")(1234.5), "1,234.5")
})

test_that("fmt_brl formats positives and negatives with minus prefix", {
  expect_equal(
    fmt_brl()(c(1000, -500)),
    c("R$\u00a01.000,00", "-R$\u00a0500,00")
  )
})

test_that("fmt_brl style = 'accounting' wraps negatives in parens", {
  expect_equal(fmt_brl(style = "accounting")(-500), "(R$\u00a0500,00)")
})

test_that("fmt_brl ignores active locale (always BRL marks)", {
  withr::with_options(list(ggconsulting.locale = "en-US"), {
    expect_equal(fmt_brl()(1000), "R$\u00a01.000,00")
  })
})

test_that("fmt_currency follows the active locale", {
  withr::with_options(list(ggconsulting.locale = "en-US"), {
    expect_equal(fmt_currency()(1000), "$1,000.00")
  })
  withr::with_options(list(ggconsulting.locale = "pt-BR"), {
    expect_equal(fmt_currency()(1000), "R$\u00a01.000,00")
  })
})

test_that("fmt_pct interprets input as a fraction", {
  expect_equal(fmt_pct(decimals = 0)(0.5), "50%")
})

test_that("fmt_delta is always signed and suffix-tagged", {
  out <- fmt_delta(decimals = 1)(c(1.2, -0.3, 0))
  expect_equal(out, c("+1,2pp", "-0,3pp", "0,0pp"))
})

test_that("fmt_month gives pt-BR abbreviations by default", {
  expect_equal(fmt_month()(as.Date("2026-08-15")), "ago")
})

test_that("fmt_month gives en-US abbreviations with locale arg", {
  expect_equal(fmt_month(locale = "en-US")(as.Date("2026-08-15")), "Aug")
})

test_that("fmt_month full gives 'agosto' in pt-BR", {
  expect_equal(fmt_month(format = "full")(as.Date("2026-08-15")), "agosto")
})
