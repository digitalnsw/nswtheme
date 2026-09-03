test_that("grid offsets are correct", {
  # designed to catch offset issues if the colour vector order is changes without
  # also updating the grid-based accessors

  expect_equal(
    unname(unlist(col_nsw(1L, v = "base"))),
    c("#22272b", "#495054", "#cdd3d6", "#ebebeb")
  )
  expect_equal(
    unname(unlist(col_nsw(, 3L, v = "base"))),
    c(
      "#cdd3d6",
      "#a8edb3",
      "#8cdbe5",
      "#8ce0ff",
      "#cebfff",
      "#f4b5e6",
      "#ffb8c1",
      "#FFCE99",
      "#fde79a",
      "#e8d0b5"
    )
  )

  expect_equal(
    unname(unlist(col_nsw(1L, v = "aboriginal"))),
    c("#950906", "#e1261c", "#fbb4b3", "#fdd9d9")
  )
  expect_equal(
    unname(unlist(col_nsw(, 4L, v = "aboriginal"))),
    c(
      "#fdd9d9",
      "#f9d4be",
      "#e9c8b2",
      "#FFF1C5",
      "#dae6d1",
      "#c1e2e8",
      "#e4cce0",
      "#e5e3e0"
    )
  )
})

test_that("grids tile nsw_colours exactly", {
  expect_equal(
    c(
      names(nsw_colours)[1:3],
      as.vector(attr(nsw_colour_grids$base, "labels")),
      as.vector(attr(nsw_colour_grids$aboriginal, "labels"))
    ),
    names(nsw_colours)
  )
})

test_that("grid cells hold the colour their label names", {
  for (variant in c("base", "aboriginal")) {
    grid <- nsw_colour_grids[[variant]]
    labels <- as.vector(attr(grid, "labels"))
    expect_equal(
      unname(unlist(grid)),
      unname(unlist(nsw_colours[labels])),
      label = variant
    )
  }
})

test_that("grid dimensions are named as documented", {
  expect_equal(
    colnames(nsw_colour_grids$base),
    c(
      "greys",
      "greens",
      "teals",
      "blues",
      "purples",
      "fucshias",
      "reds",
      "oranges",
      "yellows",
      "browns"
    )
  )
  expect_equal(
    colnames(nsw_colour_grids$aboriginal),
    c(
      "reds",
      "oranges",
      "browns",
      "yellows",
      "greens",
      "blues",
      "purples",
      "greys"
    )
  )
  expect_equal(
    rownames(nsw_colour_grids$base),
    c("dark", "normal", "light", "pale")
  )
  expect_equal(
    rownames(nsw_colour_grids$aboriginal),
    rownames(nsw_colour_grids$base)
  )
})

test_that("nsw_colours are uniquely named 6 digit hex codes", {
  colours <- unlist(nsw_colours)
  expect_type(colours, "character")
  expect_false(anyDuplicated(names(colours)) > 0)
  expect_match(colours, "^#[0-9A-Fa-f]{6}$")
  expect_no_error(farver::decode_colour(colours))
})

test_that("tones within a hue get progressively lighter", {
  for (variant in c("base", "aboriginal")) {
    grid <- nsw_colour_grids[[variant]]
    for (hue in colnames(grid)) {
      lightness <- farver::decode_colour(
        unlist(grid[, hue]),
        to = "lab"
      )[, "l"]
      expect_true(
        all(diff(lightness) > 0),
        label = paste0(variant, "/", hue, " lightness")
      )
    }
  }
})

test_that("new_grid labels and indexes the colour vector consistently", {
  grid <- new_grid(
    offset = 3L,
    hues = c("greys", "greens"),
    tones = c("a", "b")
  )
  expect_equal(dim(grid), c(2L, 2L))
  expect_equal(dimnames(grid), list(c("a", "b"), c("greys", "greens")))
  expect_equal(
    unname(unlist(grid)),
    unname(unlist(nsw_colours[4:7]))
  )
  expect_equal(
    as.vector(attr(grid, "labels")),
    names(nsw_colours)[4:7]
  )
  expect_s3_class(grid, "col_grid")
})

test_that("doc_themes lists the derived themes but not the parent grids", {
  themes <- doc_themes()
  expect_type(themes, "character")
  expect_match(themes, "corporate", fixed = TRUE, all = FALSE)
  expect_match(themes, "treasury", fixed = TRUE, all = FALSE)
  expect_false(grepl("`\"base\"`", themes, fixed = TRUE))
  expect_false(grepl("`\"aboriginal\"`", themes, fixed = TRUE))
})
