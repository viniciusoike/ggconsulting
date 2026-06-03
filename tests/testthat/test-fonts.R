# Font utilities ----

test_that("has_font() returns logical scalar", {
  result <- has_font("Helvetica")
  expect_type(result, "logical")
  expect_length(result, 1L)
})

test_that("has_font() returns FALSE for nonsense name", {
  expect_false(has_font("NotARealFont12345"))
})

# Font URL catalog ----

test_that(".font_urls() returns named list with all 5 families", {
  urls <- .font_urls()
  expect_type(urls, "list")
  expect_named(urls)
  expected <- c("Inter", "Source Sans 3", "Lato", "Source Serif 4", "IBM Plex Sans")
  expect_true(all(expected %in% names(urls)))
  for (family in names(urls)) {
    expect_type(urls[[family]], "character")
    expect_true(length(urls[[family]]) >= 2L)
    expect_true(all(grepl("\\.ttf$", names(urls[[family]]))))
  }
})

# Font installer ----

test_that("install_consulting_fonts() errors on unknown font", {
  expect_error(
    install_consulting_fonts(fonts = "BOGUS"),
    "Unknown font"
  )
})

test_that("install_consulting_fonts(quiet = TRUE) suppresses messages", {
  dest <- withr::local_tempdir()
  local_mocked_bindings(
    download.file = function(...) 0L,
    .package = "utils"
  )
  expect_no_message(
    install_consulting_fonts(fonts = "Inter", dest = dest, quiet = TRUE)
  )
})

test_that("install_consulting_fonts() skips existing files", {
  dest <- withr::local_tempdir()
  urls <- .font_urls()[["Inter"]]
  for (f in names(urls)) {
    writeLines("placeholder", file.path(dest, f))
  }
  result <- install_consulting_fonts(fonts = "Inter", dest = dest, quiet = TRUE)
  expect_length(result, 0L)
})
