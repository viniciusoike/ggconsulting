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

# Attach hook ----

test_that(".onAttach() applies defaults and announces them", {
  withr::local_options(ggconsulting.autoload = TRUE)
  withr::defer(ct_unset_defaults())
  ct_unset_defaults()

  expect_message(.onAttach(NULL, "ggconsulting"), "aesthetic defaults")
  expect_equal(ggplot2::GeomPoint$default_aes$size, 2.5)
})

test_that(".onAttach() respects the autoload opt-out", {
  withr::local_options(ggconsulting.autoload = FALSE)
  withr::defer(ct_unset_defaults())
  ct_unset_defaults()
  before <- ggplot2::GeomPoint$default_aes$size

  expect_silent(out <- .onAttach(NULL, "ggconsulting"))
  expect_null(out)
  expect_equal(ggplot2::GeomPoint$default_aes$size, before)
})

test_that(".onLoad() initialises the package environment", {
  withr::defer({
    .ct_env$captured <- FALSE
    .ct_env$originals <- list()
  })
  .ct_env$captured <- TRUE
  .ct_env$originals <- list(bogus = 1)

  .onLoad(NULL, "ggconsulting")
  expect_false(.ct_env$captured)
  expect_equal(.ct_env$originals, list())
})
