test_that("warns when params are ignored", {
  expect_no_warning(pal_nsw())
  expect_no_warning(pal_nsw(hue = "reds", variant = "aboriginal"))
  expect_warning(pal_nsw(variant = "aboriginal"), "ignored unless")
  expect_warning(pal_nsw(palette = "default", hue = "reds"), "ignored when")
  expect_warning(
    expect_warning(
      pal_nsw(palette = "default", variant = "aboriginal"),
      "ignored unless"
    ),
    "ignored when"
  )
})

test_that("pal_nsw returns a discrete colour palette", {
  pal <- pal_nsw()
  expect_true(scales::is_discrete_pal(pal))
  expect_equal(scales::palette_type(pal), "colour")
  expect_equal(scales::palette_nlevels(pal), length(nsw_named_palettes$default))
})

test_that("pal_nsw defaults to the default named palette", {
  expect_equal(pal_values(pal_nsw()), unname(nsw_named_palettes$default))
  expect_equal(pal_values(pal_nsw(palette = "default")), pal_values(pal_nsw()))
})

test_that("named palettes are built from anchor colours", {
  expect_equal(
    pal_values(pal_nsw(palette = "core")),
    unname(c(nsw_colours$blue_01, nsw_colours$red_02))
  )
  expect_equal(
    pal_values(pal_nsw(palette = "brand_default")),
    unname(c(
      nsw_colours$blue_01,
      nsw_colours$blue_04,
      nsw_colours$blue_02,
      nsw_colours$red_02
    ))
  )
  for (name in names(nsw_named_palettes)) {
    expect_match(nsw_named_palettes[[name]], "^#[0-9A-Fa-f]{6}$")
  }
})

test_that("pal_nsw selects from the grid by hue and/or tone", {
  expect_equal(
    pal_values(pal_nsw(hue = "blues")),
    unname(col_nsw(hue = "blues"))
  )
  expect_equal(
    pal_values(pal_nsw(tone = 1:2)),
    unname(col_nsw(tone = 1:2))
  )
  expect_equal(
    pal_values(pal_nsw(hue = "reds", tone = 1:2, variant = "aboriginal")),
    unname(col_nsw(hue = "reds", tone = 1:2, variant = "aboriginal"))
  )
})

test_that("direction = -1 reverses the palette", {
  expect_equal(
    pal_values(pal_nsw(palette = "default", direction = -1)),
    rev(pal_values(pal_nsw(palette = "default")))
  )
  expect_equal(
    pal_values(pal_nsw(hue = "blues", direction = -1)),
    rev(pal_values(pal_nsw(hue = "blues")))
  )
})

test_that("pal_nsw_manual resolves anchor colour names", {
  pal <- pal_nsw_manual(c("blue_02", "red_01", "green_03"))
  expect_true(scales::is_discrete_pal(pal))
  expect_equal(
    pal_values(pal),
    unname(c(nsw_colours$blue_02, nsw_colours$red_01, nsw_colours$green_03))
  )
  expect_error(pal_nsw_manual("not_a_colour"))
})

test_that("discrete palettes can be interpolated", {
  cts <- scales::as_continuous_pal(pal_nsw(hue = "blues"))
  expect_true(scales::is_continuous_pal(cts))
  expect_equal(
    cts(c(0, 1)),
    toupper(unname(col_nsw(hue = "blues")[c(1, 4)]))
  )
})

test_that("display_pal_nsw draws every palette without error", {
  grDevices::pdf(NULL)
  on.exit(grDevices::dev.off(), add = TRUE)
  expect_no_error(display_pal_nsw())
  with_defined_theme("test_theme", "base", c("greens", "blues"), {
    expect_no_error(display_pal_nsw())
  })
})
