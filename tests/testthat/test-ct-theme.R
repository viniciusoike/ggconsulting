test_that("ct_theme() returns a theme/gg object", {
  th <- ct_theme()
  expect_s3_class(th, "theme")
  expect_s3_class(th, "gg")
})

test_that("theme_strategy() returns a theme/gg object", {
  th <- theme_strategy()
  expect_s3_class(th, "theme")
  expect_s3_class(th, "gg")
})

test_that("base_size flows through to text size", {
  th <- ct_theme(base_size = 20)
  expect_equal(th$text$size, 20)
})

test_that("context drives base_size when base_size is NULL", {
  expect_equal(ct_theme(context = "presentation")$text$size, 14)
  expect_equal(ct_theme(context = "report")$text$size, 10)
  expect_equal(ct_theme(context = "screen")$text$size, 11)
})

test_that("ct_theme() sets geom element linewidth to 0.8 for from_theme()", {
  th <- ct_theme()
  expect_equal(th$geom$linewidth, 0.8)
})

test_that("font fallback resolves to an installed family or 'sans'", {
  skip_if_not(has_font("Inter"), "Inter not installed")
  th <- ct_theme(font = "Inter")
  expect_equal(th$text$family, "Inter")
})
