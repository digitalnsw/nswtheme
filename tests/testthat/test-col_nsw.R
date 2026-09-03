test_that("col_nsw indexes the grid like a matrix", {
  expect_equal(
    col_nsw(hue = "reds", tone = 1:2),
    c(red_01 = "#630019", red_02 = "#d7153a")
  )
  expect_equal(col_nsw(hue = 7L, tone = 1:2), col_nsw(hue = "reds", tone = 1:2))
  expect_length(col_nsw(tone = "normal"), ncol(nsw_colour_grids$base))
  expect_length(col_nsw(hue = "blues"), nrow(nsw_colour_grids$base))
  expect_length(col_nsw(hue = c("teals", "oranges"), tone = 1:2), 4L)
})

test_that("col_nsw names its result after the anchor colours", {
  expect_named(
    col_nsw(hue = c("teals", "oranges"), tone = 1:2),
    c("teal_01", "teal_02", "orange_01", "orange_02")
  )
  expect_true(all(names(col_nsw(tone = 2)) %in% names(nsw_colours)))
})

test_that("col_nsw accepts unambiguous abbreviations", {
  expect_equal(col_nsw(hue = "red", tone = 2), col_nsw(hue = "reds", tone = 2))
  expect_equal(
    col_nsw(hue = 1, tone = "norm"),
    col_nsw(hue = 1, tone = "normal")
  )
  expect_equal(
    col_nsw(hue = 1, variant = "abo"),
    col_nsw(hue = 1, variant = "aboriginal")
  )
  # "gre" is ambiguous between greys and greens
  expect_error(col_nsw(hue = "gre"))
  expect_error(col_nsw(hue = "chartreuse"))
  expect_error(col_nsw(hue = 1, variant = "nonexistent"))
})

test_that("byrow varies tone faster than hue", {
  by_hue <- col_nsw(hue = c("teals", "oranges"), tone = 1:2)
  by_tone <- col_nsw(hue = c("teals", "oranges"), tone = 1:2, byrow = TRUE)
  expect_named(by_tone, c("teal_01", "orange_01", "teal_02", "orange_02"))
  expect_equal(by_tone[names(by_hue)], by_hue)
})

test_that("col_nsw requires at least one of hue and tone", {
  expect_error(col_nsw(), "hue")
})

test_that("colour themes are subsets of a parent grid in the given order", {
  expect_equal(
    col_nsw(tone = 2, variant = "corporate"),
    col_nsw(hue = c("blues", "reds", "greys"), tone = 2)
  )
  expect_equal(
    col_nsw(tone = 2, variant = "treasury"),
    col_nsw(hue = c("teals", "greys", "oranges", "greens"), tone = 2)
  )
})

test_that("define_colour_theme registers a reusable variant", {
  with_defined_theme("test_theme", "aboriginal", c("greens", "blues"), {
    expect_true("test_theme" %in% names(nsw_colour_grids))
    expect_equal(
      col_nsw(tone = "normal", variant = "test_theme"),
      col_nsw(hue = c("greens", "blues"), tone = "normal", v = "aboriginal")
    )
    expect_equal(
      colnames(nsw_colour_grids$test_theme),
      c("greens", "blues")
    )
  })
  expect_false("test_theme" %in% names(nsw_colour_grids))
})

test_that("define_colour_theme rejects an unknown parent", {
  expect_error(define_colour_theme("bad", "nonexistent", "greens"))
})

test_that("the default variant follows the nswtheme.colour_theme option", {
  expect_equal(
    with_colour_theme("aboriginal", col_nsw(tone = 2)),
    col_nsw(tone = 2, variant = "aboriginal")
  )
  expect_equal(
    with_colour_theme("aboriginal", pal_values(pal_nsw(tone = 2))),
    pal_values(pal_nsw(tone = 2, variant = "aboriginal"))
  )
  expect_equal(
    with_colour_theme("corporate", pal_values(pal_waratah("qual"))),
    pal_values(pal_waratah("qual", variant = "corporate"))
  )
})

test_that("resolve_colours substitutes NSW names only", {
  expect_equal(
    resolve_colours(c("blue_01", "off_white", "#123456", "navy", NA)),
    c(nsw_colours$blue_01, nsw_colours$off_white, "#123456", "navy", NA)
  )
})

test_that("resolve_colours leaves base R colour names alone", {
  # black and white appear in both nsw_colours and grDevices::colors()
  expect_equal(resolve_colours(c("black", "white")), c("black", "white"))
})

test_that("resolve_colours passes through non-character input", {
  expect_null(resolve_colours(NULL))
  expect_identical(resolve_colours(3L), 3L)
})
