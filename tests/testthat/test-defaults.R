test_that("ct_set/ct_unset round-trips geom_point size", {
  ct_unset_defaults()
  baseline <- getFromNamespace("GeomPoint", "ggplot2")$default_aes$size

  ct_set_defaults()
  expect_equal(
    getFromNamespace("GeomPoint", "ggplot2")$default_aes$size,
    2.5
  )

  ct_unset_defaults()
  expect_equal(
    getFromNamespace("GeomPoint", "ggplot2")$default_aes$size,
    baseline
  )

  # Restore the autoloaded state for downstream tests
  ct_set_defaults()
})

test_that("round-trip doesn't error", {
  expect_no_error(ct_set_defaults())
  expect_no_error(ct_unset_defaults())
  expect_no_error(ct_set_defaults())
})
