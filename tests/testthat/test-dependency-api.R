test_that("ggplot2 still recognises the theme elements theme_nsw() sets", {
  # theme() accepts unknown names through `...` without complaint
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

test_that("scales::col_mix blends towards its second argument", {
  # reactable_nswtheme() relies on the direction
  expect_equal(scales::col_mix("#000000", "#ffffff", amount = 0), "#000000FF")
  expect_equal(scales::col_mix("#000000", "#ffffff", amount = 1), "#FFFFFFFF")
})
