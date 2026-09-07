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

test_that("ct_finish(end_labels = TRUE) accepts a Date x and keeps date labels", {
  d <- data.frame(
    x = rep(as.Date("2024-01-01") + c(0, 150, 300), 2),
    y = c(1, 2, 3, 3, 2, 1),
    g = rep(c("A", "B"), each = 3)
  )
  p <- ggplot2::ggplot(d, ggplot2::aes(x, y, colour = g)) +
    ggplot2::geom_line() +
    ct_finish(end_labels = TRUE)

  has_text <- vapply(p$layers, function(l) inherits(l$geom, "GeomText"), logical(1))
  expect_true(any(has_text))

  # A continuous x scale here would render day numbers instead of dates.
  labels <- ggplot2::ggplot_build(p)$layout$panel_params[[1]]$x$get_labels()
  expect_false(any(grepl("^[0-9]{5}$", labels)))
})

test_that("ct_finish(end_labels = TRUE) accepts a POSIXct x", {
  d <- data.frame(
    x = rep(as.POSIXct("2024-01-01", tz = "UTC") + c(0, 3600, 7200), 2),
    y = c(1, 2, 3, 3, 2, 1),
    g = rep(c("A", "B"), each = 3)
  )
  p <- ggplot2::ggplot(d, ggplot2::aes(x, y, colour = g)) +
    ggplot2::geom_line() +
    ct_finish(end_labels = TRUE)
  has_text <- vapply(p$layers, function(l) inherits(l$geom, "GeomText"), logical(1))
  expect_true(any(has_text))
})

test_that("end labels and auto expansion do not both add an x scale", {
  d <- data.frame(
    x = rep(as.Date("2024-01-01") + c(0, 150), 2),
    y = c(1, 2, 2, 1),
    g = rep(c("A", "B"), each = 2)
  )
  expect_silent(
    p <- ggplot2::ggplot(d, ggplot2::aes(x, y, colour = g)) +
      ggplot2::geom_line() +
      ct_finish(end_labels = TRUE)
  )
  n_x <- sum(vapply(
    p$scales$scales,
    function(s) "x" %in% s$aesthetics,
    logical(1)
  ))
  expect_equal(n_x, 1L)
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
  expect_error(p + ct_finish(end_labels = TRUE), "needs a numeric")
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

# End labels in the first facet only ----

# Every series spans both panels and so terminates in the *last* one.
# Pinning must therefore read facet levels from the full data; taking them
# from the end rows alone would land the labels in the last panel.
make_faceted <- function() {
  data.frame(
    x = rep(1:4, 4),
    y = c(1:4, 4:1, 2:5, 5:2),
    series = rep(c("A", "B", "C", "D"), each = 4),
    region = rep(rep(c("North", "South"), each = 2), 4)
  )
}

text_layer_data <- function(p) {
  i <- which(vapply(p$layers, function(l) inherits(l$geom, "GeomText"), logical(1)))
  ggplot2::ggplot_build(p)$data[[i[1]]]
}

test_that("end_labels = 'first_facet' puts every label in the first panel", {
  p <- ggplot2::ggplot(make_faceted(), ggplot2::aes(x, y, colour = series)) +
    ggplot2::geom_line() +
    ggplot2::facet_wrap(~region) +
    ct_finish(end_labels = "first_facet")

  counts <- table(text_layer_data(p)$PANEL)
  expect_equal(as.integer(counts[["1"]]), 4L)
  expect_equal(as.integer(counts[["2"]]), 0L)
})

test_that("end_labels = TRUE leaves labels in their own panel", {
  p <- ggplot2::ggplot(make_faceted(), ggplot2::aes(x, y, colour = series)) +
    ggplot2::geom_line() +
    ggplot2::facet_wrap(~region) +
    ct_finish(end_labels = TRUE)

  # Each series runs to x = 4, which sits in the South panel.
  counts <- table(text_layer_data(p)$PANEL)
  expect_equal(as.integer(counts[["1"]]), 0L)
  expect_equal(as.integer(counts[["2"]]), 4L)
})

test_that("'first_facet' pins to the first level even when no series ends there", {
  d <- make_faceted()
  expect_equal(unique(d$region[d$x == max(d$x)]), "South")

  p <- ggplot2::ggplot(d, ggplot2::aes(x, y, colour = series)) +
    ggplot2::geom_line() +
    ggplot2::facet_wrap(~region) +
    ct_finish(end_labels = "first_facet")
  expect_equal(as.integer(table(text_layer_data(p)$PANEL)[["1"]]), 4L)
})

test_that("end_labels = 'first_facet' works on facet_grid", {
  p <- ggplot2::ggplot(make_faceted(), ggplot2::aes(x, y, colour = series)) +
    ggplot2::geom_line() +
    ggplot2::facet_grid(rows = ggplot2::vars(region)) +
    ct_finish(end_labels = "first_facet")

  counts <- table(text_layer_data(p)$PANEL)
  expect_equal(as.integer(counts[["1"]]), 4L)
  expect_equal(as.integer(counts[["2"]]), 0L)
})

test_that("end_labels = 'first_facet' behaves like TRUE without facets", {
  d <- make_faceted()
  p <- ggplot2::ggplot(d, ggplot2::aes(x, y, colour = series)) +
    ggplot2::geom_line() +
    ct_finish(end_labels = "first_facet")
  expect_equal(nrow(text_layer_data(p)), 4L)
})

test_that(".facet_vars() reads wrap, grid, and null facets", {
  d <- make_faceted()
  base <- ggplot2::ggplot(d, ggplot2::aes(x, y)) + ggplot2::geom_line()
  expect_equal(.facet_vars((base + ggplot2::facet_wrap(~region))$facet), "region")
  expect_equal(
    .facet_vars((base + ggplot2::facet_grid(rows = ggplot2::vars(region)))$facet),
    "region"
  )
  expect_length(.facet_vars(base$facet), 0L)
})

test_that(".first_level() keeps factor levels intact", {
  f <- factor(c("b", "a"), levels = c("b", "a"))
  expect_equal(as.character(.first_level(f)), "b")
  expect_equal(levels(.first_level(f)), c("b", "a"))
  expect_equal(.first_level(c("z", "m")), "m")
})

test_that("end_labels rejects an unknown string", {
  expect_error(ct_finish(end_labels = "nope"), "first_facet")
})

# End points ----

test_that("end_points adds one point layer under the labels", {
  d <- make_faceted()
  p <- ggplot2::ggplot(d, ggplot2::aes(x, y, colour = series)) +
    ggplot2::geom_line() +
    ct_finish(end_labels = TRUE, end_points = TRUE)

  is_point <- vapply(p$layers, function(l) inherits(l$geom, "GeomPoint"), logical(1))
  expect_equal(sum(is_point), 1L)

  is_text <- vapply(p$layers, function(l) inherits(l$geom, "GeomText"), logical(1))
  expect_lt(which(is_point)[1], which(is_text)[1])
  expect_equal(nrow(ggplot2::ggplot_build(p)$data[[which(is_point)[1]]]), 4L)
})

test_that("end_points is off by default", {
  d <- make_faceted()
  p <- ggplot2::ggplot(d, ggplot2::aes(x, y, colour = series)) +
    ggplot2::geom_line() +
    ct_finish(end_labels = TRUE)
  expect_false(any(vapply(p$layers, function(l) inherits(l$geom, "GeomPoint"), logical(1))))
})

# Axis position ----

axis_grob_class <- function(p, name) {
  g <- ggplot2::ggplot_gtable(ggplot2::ggplot_build(p))
  class(g$grobs[[which(g$layout$name == name)]])[1]
}

test_that("axis_y = 'right' moves the y axis", {
  d <- make_faceted()
  p <- ggplot2::ggplot(d, ggplot2::aes(x, y)) +
    ggplot2::geom_line() +
    ct_finish(axis_y = "right")
  expect_equal(axis_grob_class(p, "axis-l"), "zeroGrob")
  expect_false(axis_grob_class(p, "axis-r") == "zeroGrob")
})

test_that("axis_y = NULL leaves the y axis on the left", {
  d <- make_faceted()
  p <- ggplot2::ggplot(d, ggplot2::aes(x, y)) +
    ggplot2::geom_line() +
    ct_finish()
  expect_false(axis_grob_class(p, "axis-l") == "zeroGrob")
  expect_equal(axis_grob_class(p, "axis-r"), "zeroGrob")
})

test_that("axis_y = 'right' preserves a user-supplied y scale", {
  d <- make_faceted()
  p <- ggplot2::ggplot(d, ggplot2::aes(x, y)) +
    ggplot2::geom_line() +
    ggplot2::scale_y_continuous(limits = c(0, 10)) +
    ct_finish(axis_y = "right")
  expect_equal(axis_grob_class(p, "axis-l"), "zeroGrob")
  expect_equal(
    ggplot2::ggplot_build(p)$layout$panel_params[[1]]$y$limits,
    c(0, 10)
  )
})

test_that("axis_y rejects an unknown position", {
  expect_error(ct_finish(axis_y = "top"), "must be")
})

test_that("end_labels leaves a caller-supplied x scale in place", {
  d <- make_faceted()
  expect_silent(
    p <- ggplot2::ggplot(d, ggplot2::aes(x, y, colour = series)) +
      ggplot2::geom_line() +
      ggplot2::scale_x_continuous(breaks = c(1, 3)) +
      ct_finish(end_labels = TRUE)
  )
  x_scales <- Filter(function(s) "x" %in% s$aesthetics, p$scales$scales)
  expect_length(x_scales, 1L)
  expect_equal(x_scales[[1]]$breaks, c(1, 3))
})

test_that("expand = 'auto' leaves a caller-supplied y scale in place", {
  d <- data.frame(g = c("a", "b", "c"), v = c(3, 5, 2))
  expect_silent(
    p <- ggplot2::ggplot(d, ggplot2::aes(g, v)) +
      ggplot2::geom_col() +
      ggplot2::scale_y_continuous(labels = function(x) paste0(x, "%")) +
      ct_finish(expand = "auto")
  )
  y_scales <- Filter(function(s) "y" %in% s$aesthetics, p$scales$scales)
  expect_length(y_scales, 1L)
  expect_equal(y_scales[[1]]$labels(c(1, 2)), c("1%", "2%"))
})

test_that("expand = 'auto' leaves a caller-supplied x scale in place on lines", {
  d <- data.frame(
    x = as.Date("2024-01-01") + c(0, 31, 60),
    y = c(1, 2, 3)
  )
  expect_silent(
    p <- ggplot2::ggplot(d, ggplot2::aes(x, y)) +
      ggplot2::geom_line() +
      ggplot2::scale_x_date(date_labels = "%b") +
      ct_finish(expand = "auto")
  )
  x_scales <- Filter(function(s) "x" %in% s$aesthetics, p$scales$scales)
  expect_length(x_scales, 1L)
  expect_equal(
    x_scales[[1]]$get_labels(as.Date(c("2024-01-01", "2024-03-01"))),
    c("Jan", "Mar")
  )
})

# mirror_y ----

test_that("mirror_y draws a second y axis and leaves the primary labelled", {
  d <- data.frame(x = 1:5, y = c(2, 4, 3, 6, 5))
  base <- ggplot2::ggplot(d, ggplot2::aes(x, y)) + ggplot2::geom_line()

  right_axis <- function(p) {
    g <- ggplot2::ggplotGrob(p)
    g$grobs[[which(g$layout$name == "axis-r")]]
  }

  expect_s3_class(right_axis(base + ct_finish()), "zeroGrob")
  expect_false(inherits(right_axis(base + ct_finish(mirror_y = TRUE)), "zeroGrob"))

  g <- ggplot2::ggplotGrob(base + ct_finish(mirror_y = TRUE))
  expect_false(
    inherits(g$grobs[[which(g$layout$name == "axis-l")]], "zeroGrob")
  )
})

test_that("mirror_y leaves a caller-supplied y scale in place", {
  d <- data.frame(x = 1:5, y = c(2, 4, 3, 6, 5))
  expect_silent(
    p <- ggplot2::ggplot(d, ggplot2::aes(x, y)) +
      ggplot2::geom_line() +
      ggplot2::scale_y_continuous(labels = function(x) paste0(x, "%")) +
      ct_finish(mirror_y = TRUE)
  )
  y_scales <- Filter(function(s) "y" %in% s$aesthetics, p$scales$scales)
  expect_length(y_scales, 1L)
  expect_equal(y_scales[[1]]$labels(c(1, 2)), c("1%", "2%"))
})

test_that("mirror_y composes with axis_y = 'right'", {
  d <- data.frame(x = 1:5, y = c(2, 4, 3, 6, 5))
  p <- ggplot2::ggplot(d, ggplot2::aes(x, y)) +
    ggplot2::geom_line() +
    ct_finish(mirror_y = TRUE, axis_y = "right")
  g <- ggplot2::ggplotGrob(p)
  expect_false(inherits(g$grobs[[which(g$layout$name == "axis-l")]], "zeroGrob"))
  expect_false(inherits(g$grobs[[which(g$layout$name == "axis-r")]], "zeroGrob"))
})
