test_that("col_distinct keeps a subset of the input colours", {
  colours <- col_nsw(tone = 1:2)
  reduced <- col_distinct(colours)
  expect_true(all(reduced %in% colours))
  expect_named(reduced)
  expect_equal(unname(nsw_colours[names(reduced)]), as.list(unname(reduced)))
  expect_false(anyDuplicated(reduced) > 0)
})

test_that("col_distinct thresholds control how much is merged", {
  colours <- col_nsw(tone = 1:2)
  expect_setequal(unname(col_distinct(colours, threshold = 0)), unname(colours))
  expect_length(col_distinct(colours, threshold = 1000), 1L)
  expect_true(
    length(col_distinct(colours, threshold = 40)) <=
      length(col_distinct(colours, threshold = 20))
  )
})

test_that("col_distinct is deterministic", {
  colours <- col_nsw(tone = 1:2)
  expect_identical(col_distinct(colours), col_distinct(colours))
})

test_that("col_distinct can simulate colour vision deficiency", {
  skip_if_not_installed("colorBlindness")
  colours <- col_nsw(tone = 1:2)
  # simulation makes colours harder to tell apart, so no more can survive
  expect_true(
    length(col_distinct(colours, cvd = TRUE)) <=
      length(col_distinct(colours, cvd = FALSE))
  )
  expect_true(all(col_distinct(colours, cvd = TRUE) %in% colours))
})

test_that("col_distinct can draw its dendrogram", {
  grDevices::pdf(NULL)
  on.exit(grDevices::dev.off(), add = TRUE)
  expect_no_error(col_distinct(col_nsw(tone = 1:2), plot = TRUE))
  expect_no_error(col_distinct(col_nsw(tone = 1:2), threshold = 0, plot = TRUE))
})

test_that("col_anticluster is a permutation of its input", {
  colours <- col_nsw(tone = 2)
  expect_setequal(unname(col_anticluster(colours)), unname(colours))
  expect_named(col_anticluster(colours))
  expect_identical(col_anticluster(colours), col_anticluster(colours))
})

test_that("col_anticluster starts from the requested colour", {
  colours <- col_nsw(tone = 2)
  for (initial in c(1L, 5L, length(colours))) {
    expect_equal(
      col_anticluster(colours, initial = initial)[[1]],
      colours[[initial]]
    )
  }
})

test_that("col_anticluster spreads out the early colours", {
  colours <- col_nsw(tone = 1:2)
  ordered <- col_anticluster(colours)
  distance <- function(x) {
    lab <- farver::decode_colour(x, to = "lab")
    d <- farver::compare_colour(lab, from_space = "lab", method = "cie2000")
    min(d[upper.tri(d)])
  }
  expect_gt(distance(ordered[1:4]), distance(colours[1:4]))
})
