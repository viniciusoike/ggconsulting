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

# Install consent ----

test_that(".is_temp_path() recognises the session tempdir and its children", {
  expect_true(.is_temp_path(tempdir()))
  expect_true(.is_temp_path(file.path(tempdir(), "fonts")))
  expect_false(.is_temp_path(path.expand("~/Library/Fonts")))
})

test_that(".confirm_font_install() passes through for tempdir destinations", {
  expect_true(.confirm_font_install(tempdir(), "Inter"))
})

test_that(".confirm_font_install() aborts non-interactively for home directories", {
  withr::local_options(ggconsulting.font_consent = NULL)
  expect_error(
    .confirm_font_install(path.expand("~/Library/Fonts"), "Inter"),
    "non-interactive session"
  )
})

test_that(".confirm_font_install() honours the consent option", {
  withr::local_options(ggconsulting.font_consent = TRUE)
  expect_true(.confirm_font_install(path.expand("~/Library/Fonts"), "Inter"))
})

test_that("install_consulting_fonts() refuses to touch the home directory unasked", {
  withr::local_options(ggconsulting.font_consent = NULL)
  # No dest given, non-interactive: must abort before any download.
  expect_error(install_consulting_fonts("Inter"), "non-interactive session")
})

test_that("install_consulting_fonts() validates fonts before consent", {
  # Unknown-name error must fire regardless of destination or consent state.
  expect_error(install_consulting_fonts("Comic Sans"), "Unknown font")
  expect_error(install_consulting_fonts("Comic Sans"), "Available")
})

# Font resolution ----

test_that(".resolve_font() returns the primary when it is installed", {
  expect_equal(.resolve_font("sans"), "sans")
})

test_that(".resolve_font() falls through to the first available fallback", {
  expect_equal(.resolve_font("NotARealFont12345", c("NopeAlsoFake999", "serif")), "serif")
})

test_that(".resolve_font() returns the last fallback when nothing resolves", {
  expect_equal(
    .resolve_font("NotARealFont12345", c("NopeAlsoFake999", "StillFake000")),
    "StillFake000"
  )
})

# Registered fonts ----

# A font registered from a file lands in systemfonts::registry_fonts(),
# not system_fonts(). Consultants register client brand fonts this way,
# so ggconsulting must treat them as available.

local_registered_font <- function(family, env = parent.frame()) {
  # Borrow any real font file on this machine; we only care that the
  # family name resolves through the registry, not how it renders.
  sf <- systemfonts::system_fonts()
  paths <- unique(sf$path[grepl("[.](ttf|otf)$", sf$path, ignore.case = TRUE)])
  if (length(paths) == 0L) {
    testthat::skip("No font file available to register")
  }
  systemfonts::register_font(name = family, plain = paths[[1]])
  withr::defer(systemfonts::clear_registry(), envir = env)
  invisible(paths[[1]])
}

test_that(".available_font_families() spans system and registry tables", {
  local_registered_font("ggconsultingTestFace")
  fams <- .available_font_families()
  expect_true("ggconsultingTestFace" %in% fams)
  expect_true(all(systemfonts::system_fonts()$family %in% fams))
})

test_that("has_font() finds a session-registered family", {
  expect_false(has_font("ggconsultingTestFace"))
  local_registered_font("ggconsultingTestFace")
  expect_true(has_font("ggconsultingTestFace"))
})

test_that("has_font() is vectorised and still returns a logical", {
  out <- has_font(c("sans", "NotARealFont12345"))
  expect_type(out, "logical")
  expect_length(out, 2L)
  expect_false(out[[2]])
})

test_that(".resolve_font() honours a registered family instead of falling back", {
  local_registered_font("ggconsultingTestFace")
  expect_equal(.resolve_font("ggconsultingTestFace"), "ggconsultingTestFace")
})

test_that("ct_theme(font =) applies a registered family as base_family", {
  local_registered_font("ggconsultingTestFace")
  th <- ct_theme(font = "ggconsultingTestFace")
  expect_equal(th$text$family, "ggconsultingTestFace")
})

test_that("an unregistered family still falls back", {
  th <- ct_theme(font = "ggconsultingTestFace", font_fallback = "serif")
  expect_equal(th$text$family, "serif")
})
