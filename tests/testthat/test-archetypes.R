test_that("theme_finance returns a theme/gg object", {
  th <- theme_finance()
  expect_s3_class(th, "theme")
  expect_s3_class(th, "gg")
})

test_that("theme_editorial returns a theme/gg object", {
  th <- theme_editorial()
  expect_s3_class(th, "theme")
  expect_s3_class(th, "gg")
})

test_that("theme_finance routes finance_classic primary into geom ink", {
  th <- theme_finance()
  expect_equal(th$geom$ink, attr(th, "ct_palette")[1])
})

test_that("theme_editorial routes editorial_warm primary into geom ink", {
  th <- theme_editorial()
  expect_equal(th$geom$ink, attr(th, "ct_palette")[1])
})

test_that("theme_finance honors a main_color override", {
  th <- theme_finance(main_color = "#222222")
  expect_equal(th$geom$ink, "#222222")
})

test_that("theme_finance resolves to Source Serif 4 if installed", {
  skip_if_not(has_font("Source Serif 4"), "Source Serif 4 not installed")
  th <- theme_finance()
  expect_equal(th$text$family, "Source Serif 4")
})

test_that("theme_editorial resolves to Source Serif 4 if installed", {
  skip_if_not(has_font("Source Serif 4"), "Source Serif 4 not installed")
  th <- theme_editorial()
  expect_equal(th$text$family, "Source Serif 4")
})

test_that("theme_finance falls back to a generic serif when nothing installed", {
  # If none of the serif fallbacks are installed, .resolve_font should still
  # return a usable family name (one of "sans"/"serif"/"mono" or whatever
  # the tail of the fallback chain is).
  th <- theme_finance()
  expect_type(th$text$family, "character")
  expect_true(nchar(th$text$family) > 0)
})

# Distinctives ----

test_that("theme_finance sets a plain-weight title (no bold)", {
  th <- theme_finance()
  expect_equal(th$plot.title$face, "plain")
})

test_that("theme_editorial sets an italic subtitle", {
  th <- theme_editorial()
  expect_equal(th$plot.subtitle$face, "italic")
})

test_that("theme_finance uses a lighter major gridline than theme_strategy", {
  expect_equal(theme_finance()$panel.grid.major$colour,  "#EEEEEE")
  expect_equal(theme_strategy()$panel.grid.major$colour, "#E5E5E5")
})
