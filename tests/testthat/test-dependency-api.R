test_that("ggplot2 still recognises the theme elements theme_nsw() sets", {
  skip_if_old_ggplot2()
  # theme_nsw() sets these by name, so they must stay registered
  elements <- c(
    "geom",
    "palette.colour.discrete",
    "palette.fill.discrete",
    "palette.colour.continuous",
    "palette.fill.continuous"
  )
  expect_equal(
    setdiff(elements, names(ggplot2::get_element_tree())),
    character()
  )
})

test_that("farver reports colour distances above the diagonal", {
  lab <- farver::decode_colour(c("#000000", "#FFFFFF"), to = "lab")
  expect_equal(unname(lab[, "l"]), c(0, 100), tolerance = 1e-4)
  for (method in c("cmc", "cie2000")) {
    distances <- farver::compare_colour(
      lab,
      from_space = "lab",
      method = method
    )
    expect_gt(distances[1, 2], 0)
    expect_equal(distances[2, 1], 0, label = method)
  }
})

test_that("scales still interoperates with our palette objects", {
  # We build palette objects ourselves so that scales 1.3.0 is enough. When a
  # newer scales is present it should still recognise what we produce.
  skip_if_not_installed("scales", "1.4.0")

  pal <- pal_nsw(hue = "blues")
  expect_true(scales::is_discrete_pal(pal))
  expect_equal(scales::palette_type(pal), "colour")
  expect_equal(scales::palette_nlevels(pal), 4L)
  expect_true(scales::is_continuous_pal(pal_waratah("seq")))

  cts <- scales::as_continuous_pal(pal)
  expect_equal(cts(c(0, 1)), toupper(unname(col_nsw(hue = "blues")[c(1, 4)])))
  expect_equal(
    col_mix("#000000", "#ffffff", amount = 0.3),
    scales::col_mix("#000000", "#ffffff", amount = 0.3)
  )
})
