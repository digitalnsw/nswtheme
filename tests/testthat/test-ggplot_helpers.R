test_that("col_contrasting chooses suitable colours", {
  colours <- c("navy", "white", "black", "yellow")
  expect_equal(col_contrasting(colours), c("white", "black", "white", "black"))
})

test_that("col_contrasting accepts custom ink colours and hex input", {
  expect_equal(
    col_contrasting(c("#000000", "#ffffff"), light = "off_white", dark = "grey_01"),
    c("off_white", "grey_01")
  )
  expect_equal(
    col_contrasting(unname(col_nsw(hue = "blues"))),
    c("white", "white", "black", "black")
  )
  expect_length(col_contrasting(character()), 0L)
})

test_that("pal_c concatenates palettes and bare colour vectors", {
  pal <- pal_c(pal_nsw(palette = "core"), c("#123456", "#654321"))
  expect_true(scales::is_discrete_pal(pal))
  expect_equal(
    pal_values(pal),
    c(unname(pal_values(pal_nsw(palette = "core"))), "#123456", "#654321")
  )
})

test_that("pal_interleave alternates between palettes", {
  expect_equal(
    pal_values(pal_interleave(c("a1", "a2", "a3"), c("b1", "b2", "b3"))),
    c("a1", "b1", "a2", "b2", "a3", "b3")
  )
  expect_equal(
    pal_values(pal_interleave(
      pal_nsw(tone = 1),
      pal_nsw(tone = 2),
      pal_nsw(tone = 3)
    )),
    unname(col_nsw(tone = 1:3))
  )
})

test_that("pal_interleave requires palettes of compatible lengths", {
  expect_error(pal_interleave(c("a", "b"), c("c", "d", "e")))
})

test_that("pal_stretch interpolates a discrete palette to any size", {
  pal <- pal_stretch(pal_nsw(palette = "core"))
  expect_true(scales::is_discrete_pal(pal))
  ends <- toupper(unname(pal_values(pal_nsw(palette = "core"))))
  expect_equal(pal(2), ends)
  expect_equal(pal(5)[c(1, 5)], ends)
  expect_length(pal(5), 5L)
  expect_length(pal(6), 6L)
})

test_that("as_colour_vector unwraps discrete palettes only", {
  expect_equal(as_colour_vector(c("red", "blue")), c("red", "blue"))
  expect_equal(
    as_colour_vector(pal_nsw(palette = "core")),
    unname(pal_values(pal_nsw(palette = "core")))
  )
})
