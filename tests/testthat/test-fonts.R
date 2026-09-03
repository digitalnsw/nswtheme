test_that("the Public Sans files that .onAttach registers are bundled", {
  for (style in c("Regular", "Bold", "Italic", "BoldItalic")) {
    path <- system.file(
      sprintf("fonts/Public_Sans/static/PublicSans-%s.ttf", style),
      package = "nswtheme"
    )
    expect_true(nzchar(path), label = style)
    expect_gt(file.size(path), 0)
  }
})

test_that("bundled fonts are readable by systemfonts", {
  path <- system.file(
    "fonts/Public_Sans/static/PublicSans-Regular.ttf",
    package = "nswtheme"
  )
  info <- systemfonts::font_info(path = path, index = 0)
  expect_equal(info$family, "Public Sans")
})

test_that("theme_nsw asks for the bundled font by name", {
  expect_equal(formals(theme_nsw)$base_family, "Public Sans")
  expect_equal(formals(theme_nsw)$header_family, "Public Sans")
  expect_equal(formals(reactable_nswtheme)$base_family, "Public Sans")
  expect_match(eval(formals(tooltip_css)$font_family), "Public Sans", fixed = TRUE)
})

test_that("systemfonts reports the family names .onAttach checks", {
  expect_true("family" %in% names(systemfonts::system_fonts()))
})
