test_that("ct_col returns a Layer and defaults width to 0.8", {
  l <- ct_col()
  expect_s3_class(l, "Layer")
  expect_equal(l$aes_params$width, 0.8)
})

test_that("ct_col passes width override through", {
  l <- ct_col(width = 0.9)
  expect_equal(l$aes_params$width, 0.9)
})

test_that("ct_line returns a Layer and defaults linewidth to 0.7", {
  l <- ct_line()
  expect_s3_class(l, "Layer")
  expect_equal(l$aes_params$linewidth, 0.7)
})

test_that("ct_line passes linewidth override through", {
  l <- ct_line(linewidth = 1.2)
  expect_equal(l$aes_params$linewidth, 1.2)
})

test_that("ct_point returns a Layer and defaults size to 2.5", {
  l <- ct_point()
  expect_s3_class(l, "Layer")
  expect_equal(l$aes_params$size, 2.5)
})

test_that("ct_point passes size override through", {
  l <- ct_point(size = 4)
  expect_equal(l$aes_params$size, 4)
})
