test_that("scale_color_ct returns a ScaleDiscrete", {
  expect_s3_class(scale_color_ct(),  "ScaleDiscrete")
  expect_s3_class(scale_colour_ct(), "ScaleDiscrete")
})

test_that("scale_fill_ct returns a ScaleDiscrete", {
  expect_s3_class(scale_fill_ct(), "ScaleDiscrete")
})

test_that("scale_color_ct_c returns a ScaleContinuous", {
  expect_s3_class(scale_color_ct_c(),  "ScaleContinuous")
  expect_s3_class(scale_colour_ct_c(), "ScaleContinuous")
})

test_that("scale_fill_ct_c returns a ScaleContinuous", {
  expect_s3_class(scale_fill_ct_c(), "ScaleContinuous")
})

test_that("discrete palette warns when n exceeds palette size", {
  s <- scale_color_ct("strategy_navy")
  # strategy_navy has 6 colours
  expect_warning(s$palette(10), "interpolat")
})

test_that("discrete palette is silent when n <= palette size", {
  s <- scale_color_ct("strategy_navy")
  expect_no_warning(s$palette(3))
  expect_length(s$palette(3), 3)
})

test_that("reverse = TRUE flips palette order", {
  s_fwd <- scale_color_ct("strategy_navy", reverse = FALSE)
  s_rev <- scale_color_ct("strategy_navy", reverse = TRUE)
  expect_equal(s_fwd$palette(6), rev(s_rev$palette(6)))
})

test_that("ct_palette_show() returns a ggplot for all palettes", {
  p <- ct_palette_show()
  expect_s3_class(p, "ggplot")
})

test_that("ct_palette_show(name) returns a ggplot for one palette", {
  p <- ct_palette_show("strategy_emerald")
  expect_s3_class(p, "ggplot")
})

test_that("ct_palette_show(vector) accepts custom hex colours", {
  p <- ct_palette_show(c("#0F4D38", "#177B57", "#3DA876"))
  expect_s3_class(p, "ggplot")
})

test_that("continuous scales honour direction = -1", {
  pal <- ct_palette("strategy_navy")
  s_fwd <- scale_color_ct_c("strategy_navy")
  s_rev <- scale_color_ct_c("strategy_navy", direction = -1)
  expect_equal(s_fwd$palette(c(0, 1)), rev(s_rev$palette(c(0, 1))))

  f_fwd <- scale_fill_ct_c("strategy_navy")
  f_rev <- scale_fill_ct_c("strategy_navy", direction = -1)
  expect_equal(f_fwd$palette(c(0, 1)), rev(f_rev$palette(c(0, 1))))
})

test_that("continuous scales accept a raw hex vector", {
  s <- scale_fill_ct_c(c("#000000", "#FFFFFF"))
  expect_s3_class(s, "ScaleContinuous")
})

test_that("scales reject a non-character palette", {
  expect_error(scale_color_ct(1L), "must be a palette name")
  expect_error(scale_fill_ct_c(1L), "must be a palette name")
})

test_that("ct_palette_show() aborts on an unknown palette name", {
  expect_error(ct_palette_show(42), "must be a palette name")
})
