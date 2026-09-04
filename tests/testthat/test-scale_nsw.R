test_that("discrete palettes give discrete scales", {
  plot <- ggplot2::ggplot(test_df, ggplot2::aes(x, y, colour = g)) +
    ggplot2::geom_point() +
    scale_colour_nsw(palette = pal_nsw(palette = "default"))
  expect_equal(
    built_aes(plot, "colour"),
    unname(pal_values(pal_nsw(palette = "default"))[1:3])
  )
})

test_that("continuous palettes give continuous scales", {
  plot <- ggplot2::ggplot(test_df_cts, ggplot2::aes(x, y, colour = z)) +
    ggplot2::geom_point() +
    scale_colour_nsw(palette = pal_waratah("seq", hue = "reds"))
  colours <- built_aes(plot, "colour")
  ends <- toupper(unname(col_nsw(hue = "reds")[c(1, 4)]))
  expect_equal(colours[c(1, 5)], ends)
  expect_length(unique(colours), 5L)
})

test_that("fill scales map the fill aesthetic", {
  plot <- ggplot2::ggplot(test_df, ggplot2::aes(x, y, fill = g)) +
    ggplot2::geom_col() +
    scale_fill_nsw(palette = pal_nsw(palette = "brand_default"))
  expect_equal(
    built_aes(plot, "fill"),
    unname(pal_values(pal_nsw(palette = "brand_default"))[1:3])
  )
})

test_that("colour names and hex codes are accepted directly", {
  plot <- ggplot2::ggplot(test_df, ggplot2::aes(x, y, colour = g)) +
    ggplot2::geom_point() +
    scale_colour_nsw(palette = c("blue_01", "red_02", "#123456"))
  expect_equal(
    built_aes(plot, "colour"),
    unname(c(nsw_colours$blue_01, nsw_colours$red_02, "#123456"))
  )
})

test_that("scale_color_nsw is an alias", {
  expect_equal(scale_color_nsw()$aesthetics, scale_colour_nsw()$aesthetics)
})

test_that("arguments reach the underlying ggplot2 scale", {
  scale <- scale_colour_nsw(name = "Group", guide = "none")
  expect_equal(scale$name, "Group")
  expect_equal(scale$guide, "none")
  expect_equal(scale_fill_nsw()$aesthetics, "fill")
})

test_that("the scales do not depend on the ggplot2 version", {
  colours <- function(legacy) {
    with_options(list(nswtheme.force_legacy = legacy), {
      plot <- ggplot2::ggplot(test_df, ggplot2::aes(x, y, colour = g)) +
        ggplot2::geom_point() +
        theme_nsw() +
        scale_colour_nsw(palette = pal_waratah("qual"))
      built_aes(plot, "colour")
    })
  }
  expect_equal(colours(TRUE), colours(FALSE))
  expect_equal(colours(TRUE), pal_waratah("qual")(3))
})
