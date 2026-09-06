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

# Ground colour ----

test_that("ct_theme() leaves the background alone by default", {
  th <- ct_theme()
  expect_equal(th$plot.background$fill, "white")
  expect_equal(th$panel.grid.major.y$colour, "#E5E5E5")
})

test_that("ct_theme(paper = ...) fills the plot background without a border", {
  th <- ct_theme(paper = "cream")
  expect_equal(th$plot.background$fill, "#FFF1E5")
  expect_true(is.na(th$plot.background$colour))
})

test_that("named paper shortcuts resolve to their hex values", {
  expect_equal(.resolve_paper("cream"), "#FFF1E5")
  expect_equal(.resolve_paper("warm_grey"), "#F0EFEB")
  expect_equal(.resolve_paper("white"), "#FFFFFF")
})

test_that("paper accepts hex and named R colours", {
  expect_equal(.resolve_paper("#123456"), "#123456")
  expect_equal(.resolve_paper("ivory"), "ivory")
})

test_that("paper = NULL resolves to NULL", {
  expect_null(.resolve_paper(NULL))
})

test_that("paper rejects non-colours and non-strings", {
  expect_error(.resolve_paper("notacolour"), "not a colour")
  expect_error(.resolve_paper(42), "single colour")
  expect_error(.resolve_paper(c("a", "b")), "single colour")
})

test_that("gridlines warm to match the ground", {
  expect_equal(.grid_color(NULL), "#E5E5E5")
  expect_equal(.grid_color("#FFF1E5"), "#E3D7CC")
  expect_equal(ct_theme(paper = "cream")$panel.grid.major.y$colour, "#E3D7CC")
})

test_that("ct_theme(paper = ...) keeps the palette attributes", {
  th <- ct_theme(palette = "editorial_warm", paper = "cream")
  expect_equal(attr(th, "ct_main_color"), ct_palette("editorial_warm")[1])
  expect_length(attr(th, "ct_palette"), 6L)
})

test_that("archetypes forward paper to ct_theme()", {
  expect_equal(theme_editorial(paper = "cream")$plot.background$fill, "#FFF1E5")
  expect_equal(theme_strategy(paper = "warm_grey")$plot.background$fill, "#F0EFEB")
})
