make_d <- function() {
  data.frame(g = c("A", "B", "C", "D", "E"), v = c(3, 8, 5, 12, 7))
}

test_that("ct_finish(values = TRUE) adds a geom_text layer on geom_col", {
  d <- make_d()
  p <- ggplot2::ggplot(d, ggplot2::aes(g, v)) +
    ggplot2::geom_col() +
    ct_finish(values = TRUE)
  has_text <- vapply(p$layers, function(l) inherits(l$geom, "GeomText"), logical(1))
  expect_true(any(has_text))
})

test_that("ct_finish(sort = 'desc') reorders the x factor by descending y", {
  d <- make_d()
  p <- ggplot2::ggplot(d, ggplot2::aes(g, v)) +
    ggplot2::geom_col() +
    ct_finish(sort = "desc")
  expect_equal(levels(p$data$g), c("D", "B", "E", "C", "A"))
})

test_that("ct_finish(sort = 'asc') reorders the x factor by ascending y", {
  d <- make_d()
  p <- ggplot2::ggplot(d, ggplot2::aes(g, v)) +
    ggplot2::geom_col() +
    ct_finish(sort = "asc")
  expect_equal(levels(p$data$g), c("A", "C", "E", "B", "D"))
})

test_that("ct_finish(label_fmt = 'brl') resolves to a function", {
  obj <- ct_finish(label_fmt = "brl")
  expect_type(obj$label_fmt, "closure")
  expect_equal(obj$label_fmt(1000), "R$\u00a01.000,00")
})

test_that("ct_finish(label_fmt = function) accepts a user formatter", {
  fmt <- function(x) paste0("~", x)
  obj <- ct_finish(label_fmt = fmt)
  expect_identical(obj$label_fmt, fmt)
})

test_that("ct_finish(label_fmt = ...) bad name errors", {
  expect_error(ct_finish(label_fmt = "nope"), "label_fmt")
})

test_that("ct_finish(label_fmt = 2) wrong type errors", {
  expect_error(ct_finish(label_fmt = 2), "label_fmt")
})

test_that("ct_finish(highlight = ...) injects a fill scale on geom_col", {
  d <- make_d()
  p <- ggplot2::ggplot(d, ggplot2::aes(g, v)) +
    ggplot2::geom_col() +
    ct_finish(highlight = "D")
  fill_scales <- p$scales$get_scales("fill")
  expect_false(is.null(fill_scales))
})

test_that("ct_finish(expand = 'auto') on geom_col adds a y scale", {
  d <- make_d()
  p_base <- ggplot2::ggplot(d, ggplot2::aes(g, v)) + ggplot2::geom_col()
  n_before <- length(p_base$scales$scales)

  p <- p_base + ct_finish(expand = "auto")
  n_after <- length(p$scales$scales)
  expect_gt(n_after, n_before)
})

test_that("ct_finish(expand = FALSE) leaves scales untouched", {
  d <- make_d()
  p_base <- ggplot2::ggplot(d, ggplot2::aes(g, v)) + ggplot2::geom_col()
  n_before <- length(p_base$scales$scales)

  p <- p_base + ct_finish(expand = FALSE)
  n_after <- length(p$scales$scales)
  expect_equal(n_after, n_before)
})

test_that("ct_finish(sort = 'wrong') errors", {
  expect_error(ct_finish(sort = "wrong"), "sort")
})

test_that("ct_finish(expand = 'auto') on geom_line with POSIXct x adds a datetime scale", {
  d <- data.frame(
    x = as.POSIXct(c("2024-01-01", "2024-06-01", "2024-12-01"), tz = "UTC"),
    y = c(1, 2, 3)
  )
  p <- ggplot2::ggplot(d, ggplot2::aes(x, y)) +
    ggplot2::geom_line() +
    ct_finish(expand = "auto")
  has_datetime <- any(vapply(
    p$scales$scales,
    function(s) inherits(s, "ScaleContinuousDatetime"),
    logical(1)
  ))
  expect_true(has_datetime)
})

test_that("ct_finish(end_labels = TRUE) on numeric geom_line adds geom_text + x expansion", {
  d <- data.frame(
    x = rep(1:5, 2),
    y = c(1:5, 6:10),
    g = rep(c("A", "B"), each = 5)
  )
  p <- ggplot2::ggplot(d, ggplot2::aes(x, y, colour = g)) +
    ggplot2::geom_line() +
    ct_finish(end_labels = TRUE)
  has_text <- vapply(p$layers, function(l) inherits(l$geom, "GeomText"), logical(1))
  expect_true(any(has_text))

  has_x_scale <- any(vapply(
    p$scales$scales,
    function(s) "x" %in% s$aesthetics,
    logical(1)
  ))
  expect_true(has_x_scale)
})

test_that("ct_finish(end_labels = TRUE) errors on non-numeric x", {
  d <- data.frame(
    x = as.Date(c("2024-01-01", "2024-06-01")),
    y = c(1, 2),
    g = c("A", "A")
  )
  expect_error(
    ggplot2::ggplot(d, ggplot2::aes(x, y, group = g)) +
      ggplot2::geom_line() +
      ct_finish(end_labels = TRUE),
    "numeric"
  )
})

# Guard branches ----

test_that(".detect_first_geom() reports NA for a plot with no layers", {
  p <- ggplot2::ggplot(make_d(), ggplot2::aes(g, v))
  info <- .detect_first_geom(p)
  expect_true(is.na(info$type))
  expect_null(info$layer)
})

test_that(".detect_first_geom() skips a GeomBlank layer", {
  p <- ggplot2::ggplot(make_d(), ggplot2::aes(g, v)) +
    ggplot2::geom_blank() +
    ggplot2::geom_col()
  expect_equal(.detect_first_geom(p)$type, "GeomCol")
})

test_that(".detect_first_geom() reports NA when only GeomBlank is present", {
  p <- ggplot2::ggplot(make_d(), ggplot2::aes(g, v)) + ggplot2::geom_blank()
  info <- .detect_first_geom(p)
  expect_true(is.na(info$type))
})

test_that("ct_finish() is a no-op on a layerless plot", {
  p <- ggplot2::ggplot(make_d(), ggplot2::aes(g, v))
  expect_silent(out <- p + ct_finish(values = TRUE, sort = "desc"))
  expect_s3_class(out, "ggplot")
})

test_that("sort is skipped when y is not numeric", {
  d <- data.frame(g = c("A", "B"), v = c("x", "y"))
  p <- ggplot2::ggplot(d, ggplot2::aes(g, v)) +
    ggplot2::geom_point() +
    ct_finish(sort = "desc")
  expect_false(is.factor(p$data$g))
})

test_that("sort is skipped when the data frame is empty", {
  d <- data.frame(g = character(), v = numeric())
  p <- ggplot2::ggplot(d, ggplot2::aes(g, v)) +
    ggplot2::geom_col() +
    ct_finish(sort = "desc")
  expect_equal(nrow(p$data), 0L)
})

test_that("highlight uses fill for columns and colour for points", {
  d <- make_d()
  p_col <- ggplot2::ggplot(d, ggplot2::aes(g, v)) +
    ggplot2::geom_col() +
    ct_finish(highlight = "D")
  expect_true("fill" %in% names(p_col$mapping))

  p_pt <- ggplot2::ggplot(d, ggplot2::aes(g, v)) +
    ggplot2::geom_point() +
    ct_finish(highlight = "D")
  expect_true("colour" %in% names(p_pt$mapping))
})

test_that("highlight falls back to a default main colour without a ct theme", {
  p <- ggplot2::ggplot(make_d(), ggplot2::aes(g, v)) +
    ggplot2::geom_col() +
    ct_finish(highlight = "D")
  expect_s3_class(p, "ggplot")
})

test_that("end_labels aborts on a non-numeric x aesthetic", {
  d <- data.frame(
    x = rep(c("Q1", "Q2"), 2),
    y = c(1, 2, 3, 4),
    series = rep(c("A", "B"), each = 2)
  )
  p <- ggplot2::ggplot(d, ggplot2::aes(x, y, colour = series)) +
    ggplot2::geom_line()
  expect_error(p + ct_finish(end_labels = TRUE), "requires a numeric x aesthetic")
})

test_that("end_labels is skipped without a grouping aesthetic", {
  d <- data.frame(x = 1:4, y = c(1, 2, 3, 4))
  p <- ggplot2::ggplot(d, ggplot2::aes(x, y)) +
    ggplot2::geom_line() +
    ct_finish(end_labels = TRUE)
  has_text <- vapply(p$layers, function(l) inherits(l$geom, "GeomText"), logical(1))
  expect_false(any(has_text))
})

test_that("auto expansion picks a date scale for Date x on lines", {
  d <- data.frame(x = as.Date("2026-01-01") + 0:3, y = c(1, 2, 3, 4))
  p <- ggplot2::ggplot(d, ggplot2::aes(x, y)) +
    ggplot2::geom_line() +
    ct_finish()
  classes <- vapply(p$scales$scales, function(s) class(s)[1], character(1))
  expect_true("ScaleContinuousDate" %in% classes)
})

test_that("auto expansion picks a datetime scale for POSIXct x on lines", {
  d <- data.frame(
    x = as.POSIXct("2026-01-01 00:00:00", tz = "UTC") + (0:3) * 3600,
    y = c(1, 2, 3, 4)
  )
  p <- ggplot2::ggplot(d, ggplot2::aes(x, y)) +
    ggplot2::geom_line() +
    ct_finish()
  classes <- vapply(p$scales$scales, function(s) class(s)[1], character(1))
  expect_true("ScaleContinuousDatetime" %in% classes)
})

test_that("expand = FALSE leaves scales untouched", {
  d <- make_d()
  p <- ggplot2::ggplot(d, ggplot2::aes(g, v)) +
    ggplot2::geom_col() +
    ct_finish(expand = FALSE)
  expect_length(p$scales$scales, 0L)
})

test_that("label_fmt rejects an unknown shortcut and lists the valid ones", {
  expect_error(ct_finish(label_fmt = "furlongs"), "Unknown")
  expect_error(ct_finish(label_fmt = "furlongs"), "brl")
})

test_that("label_fmt rejects input that is neither a shortcut nor a function", {
  expect_error(ct_finish(label_fmt = 42), "must be")
})
