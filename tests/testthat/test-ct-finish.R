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
