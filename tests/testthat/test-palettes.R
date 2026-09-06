# Palette catalog ----

test_that(".ct_palettes holds 11 palettes of 6 hex colours each", {
  expect_length(.ct_palettes, 11L)
  for (name in names(.ct_palettes)) {
    pal <- .ct_palettes[[name]]
    expect_length(pal, 6L)
    expect_true(all(grepl("^#[0-9A-Fa-f]{6}$", pal)), info = name)
  }
})

test_that("palette families are named by their archetype prefix", {
  nms <- names(.ct_palettes)
  expect_length(grep("^strategy_", nms), 5L)
  expect_length(grep("^finance_", nms), 3L)
  expect_length(grep("^editorial_", nms), 3L)
})

# ct_palette() ----

test_that("ct_palette() with no arguments lists palette names", {
  expect_equal(ct_palette(), names(.ct_palettes))
})

test_that("ct_palette(name) returns the full palette", {
  expect_equal(ct_palette("strategy_navy"), .ct_palettes$strategy_navy)
})

test_that("ct_palette(n) subsets from the front when n <= palette size", {
  expect_equal(ct_palette("strategy_navy", n = 3), .ct_palettes$strategy_navy[1:3])
  expect_no_warning(ct_palette("strategy_navy", n = 6))
})

test_that("ct_palette(n) interpolates with a warning when n exceeds palette size", {
  expect_warning(out <- ct_palette("strategy_navy", n = 9), "interpolating")
  expect_length(out, 9L)
  expect_true(all(grepl("^#[0-9A-Fa-f]{6}$", out)))
})

test_that("ct_palette(reverse = TRUE) flips before subsetting", {
  pal <- .ct_palettes$strategy_navy
  expect_equal(ct_palette("strategy_navy", reverse = TRUE), rev(pal))
  expect_equal(ct_palette("strategy_navy", n = 2, reverse = TRUE), rev(pal)[1:2])
})

test_that("ct_palette() coerces n to integer", {
  expect_length(ct_palette("strategy_navy", n = 3.9), 3L)
})

test_that("ct_palette() accepts a raw hex vector as the palette", {
  cols <- c("#000000", "#FFFFFF")
  expect_equal(ct_palette(cols), cols)
})

# .resolve_palette() ----

test_that(".resolve_palette() maps a known name to its colours", {
  expect_equal(.resolve_palette("finance_classic"), .ct_palettes$finance_classic)
})

test_that(".resolve_palette() passes an unrecognised character vector through", {
  cols <- c("#123456", "#654321")
  expect_equal(.resolve_palette(cols), cols)
  # A single unknown string is treated as a one-colour palette, not an error.
  expect_equal(.resolve_palette("red"), "red")
})

test_that(".resolve_palette() aborts on non-character input", {
  expect_error(.resolve_palette(1L), "must be a palette name")
  expect_error(.resolve_palette(NULL), "must be a palette name")
  expect_error(.resolve_palette(list("a")), "must be a palette name")
})
