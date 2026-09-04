test_that("theme_nsw returns a complete theme", {
  theme <- theme_nsw()
  expect_s3_class(theme, "theme")
  expect_true(attr(theme, "complete"))
  expect_no_error(ggplot2::ggplot() + theme)
})

test_that("NSW colour names are accepted wherever a colour is taken", {
  theme <- theme_nsw(
    ink = "grey_01",
    paper = "off_white",
    accent = "red_02",
    geom_ink = "teal_02"
  )
  expect_equal(theme$legend.key$colour, nsw_colours$grey_01)
  expect_equal(
    ggplot2::calc_element("plot.background", theme)$fill,
    nsw_colours$off_white
  )
})

test_that("colours that are not NSW names are passed through untouched", {
  theme <- theme_nsw(ink = "navy", paper = "white")
  expect_equal(theme$legend.key$colour, "navy")
  expect_equal(ggplot2::calc_element("plot.background", theme)$fill, "white")
})

test_that("panel elements use the design system greys", {
  theme <- theme_nsw()
  expect_equal(theme$panel.grid.major$colour, nsw_colours$grey_03)
  expect_equal(theme$panel.grid.minor$colour, nsw_colours$grey_03)
  expect_equal(theme$panel.grid.minor$linetype, "dotted")
  expect_equal(theme$axis.line$colour, nsw_colours$grey_02)
  expect_equal(theme$axis.ticks$colour, nsw_colours$grey_03)
  expect_equal(theme$strip.background$fill, "transparent")

  for (element in c(
    "panel.grid.major",
    "panel.grid.minor",
    "axis.line",
    "axis.ticks"
  )) {
    linewidth <- theme[[element]]$linewidth
    expect_s3_class(linewidth, "rel")
    expect_equal(unclass(linewidth), 0.3, label = element)
  }
})

test_that("titles are markdown aware and aligned to the plot", {
  theme <- theme_nsw(base_size = 11, header_family = "Header Font")
  expect_equal(theme$plot.title.position, "plot")
  expect_equal(theme$plot.caption.position, "plot")
  expect_s3_class(theme$plot.title, "element_markdown")
  expect_s3_class(theme$plot.caption, "element_markdown")
  expect_s3_class(theme$plot.subtitle, "element_textbox")
  expect_equal(theme$plot.title$face, "bold")
  expect_equal(theme$plot.title$size, 13)
  expect_equal(theme$plot.title$hjust, 0)
  expect_equal(theme$plot.title$family, "Header Font")
})

test_that("base_family and header_family reach the elements that use them", {
  theme <- theme_nsw(base_family = "Body Font", header_family = "Header Font")
  expect_equal(ggplot2::calc_element("axis.text", theme)$family, "Body Font")
  expect_equal(ggplot2::calc_element("legend.text", theme)$family, "Body Font")
  expect_equal(ggplot2::calc_element("plot.title", theme)$family, "Header Font")
})

test_that("base_size scales the text and line sizes", {
  theme <- theme_nsw(base_size = 22)
  expect_equal(ggplot2::calc_element("text", theme)$size, 22)
  expect_equal(theme$plot.title$size, 24)
  expect_equal(ggplot2::calc_element("line", theme)$linewidth, 1)
})

test_that("show_grid_lines = FALSE hides the grid but keeps the axes", {
  theme <- theme_nsw(show_grid_lines = FALSE)
  expect_s3_class(theme$panel.grid.major, "element_blank")
  expect_s3_class(theme$panel.grid.minor, "element_blank")
  expect_s3_class(theme$axis.ticks, "element_blank")
  expect_s3_class(ggplot2::calc_element("axis.text", theme), "element_text")
  expect_s3_class(ggplot2::calc_element("axis.title", theme), "element_text")
  expect_s3_class(theme$axis.line, "element_line")
})

test_that("void = TRUE strips the panel but keeps the titles", {
  theme <- theme_nsw(void = TRUE)
  blanked <- c(
    "plot.background",
    "panel.background",
    "panel.grid.major",
    "panel.grid.minor",
    "axis.title",
    "axis.text",
    "axis.ticks",
    "axis.line"
  )
  for (element in blanked) {
    expect_s3_class(ggplot2::calc_element(element, theme), "element_blank")
  }
  expect_s3_class(theme$plot.title, "element_markdown")
  expect_s3_class(theme$legend.text, "element_text")
})

test_that("void overrides show_grid_lines", {
  theme <- theme_nsw(void = TRUE, show_grid_lines = TRUE)
  expect_s3_class(ggplot2::calc_element("axis.text", theme), "element_blank")
  expect_s3_class(theme$panel.grid.major, "element_blank")
})

test_that("ggplot2 4 carries the geom and palette settings in the theme", {
  skip_if_old_ggplot2()
  theme <- theme_nsw(
    ink = "grey_01",
    paper = "off_white",
    accent = "red_02",
    geom_ink = "teal_02"
  )
  expect_equal(theme$geom$ink, nsw_colours$grey_01)
  expect_equal(theme$geom$paper, nsw_colours$off_white)
  expect_equal(theme$geom$accent, nsw_colours$red_02)
  expect_equal(theme$geom$colour, nsw_colours$teal_02)
  expect_equal(theme$geom$fill, nsw_colours$teal_02)

  passthrough <- theme_nsw(ink = "navy", geom_ink = "#123456", paper = "white")
  expect_equal(passthrough$geom$ink, "navy")
  expect_equal(passthrough$geom$colour, "#123456")
  expect_equal(passthrough$geom$paper, "white")

  default <- theme_nsw()
  qual <- pal_waratah("qual")
  seq_pal <- pal_waratah("seq")
  expect_equal(default$palette.colour.discrete(3), qual(3))
  expect_equal(default$palette.fill.discrete(3), qual(3))
  expect_equal(default$palette.colour.continuous(c(0, 1)), seq_pal(c(0, 1)))
  expect_equal(default$palette.fill.continuous(c(0, 1)), seq_pal(c(0, 1)))
})

test_that("discrete scales pick up the theme palette", {
  skip_if_old_ggplot2()
  plot <- ggplot2::ggplot(test_df, ggplot2::aes(x, y, colour = g)) +
    ggplot2::geom_point() +
    theme_nsw()
  expect_equal(built_aes(plot, "colour"), pal_waratah("qual")(3))

  bars <- ggplot2::ggplot(test_df, ggplot2::aes(x, y, fill = g)) +
    ggplot2::geom_col() +
    theme_nsw()
  expect_equal(built_aes(bars, "fill"), pal_waratah("qual")(3))
})

test_that("continuous scales pick up the theme palette", {
  skip_if_old_ggplot2()
  plot <- ggplot2::ggplot(test_df_cts, ggplot2::aes(x, y, colour = z)) +
    ggplot2::geom_point() +
    theme_nsw()
  colours <- built_aes(plot, "colour")
  expect_equal(colours[c(1, length(colours))], pal_waratah("seq")(c(0, 1)))
})

test_that("the variant selects which palettes the theme uses", {
  skip_if_old_ggplot2()
  plot <- ggplot2::ggplot(test_df, ggplot2::aes(x, y, colour = g)) +
    ggplot2::geom_point() +
    theme_nsw(variant = "corporate")
  expect_equal(
    built_aes(plot, "colour"),
    pal_waratah("qual", variant = "corporate")(3)
  )
  expect_equal(
    with_colour_theme("corporate", theme_nsw())$palette.colour.discrete(3),
    pal_waratah("qual", variant = "corporate")(3)
  )
})

test_that("geoms without a mapped colour use geom_ink", {
  skip_if_old_ggplot2()
  plot <- ggplot2::ggplot(test_df, ggplot2::aes(x, y)) +
    ggplot2::geom_point() +
    theme_nsw(geom_ink = "red_02")
  expect_equal(unique(built_aes(plot, "colour")), nsw_colours$red_02)
  expect_equal(unique(built_aes(plot, "size")), 2)

  bars <- ggplot2::ggplot(test_df, ggplot2::aes(x, y)) +
    ggplot2::geom_col() +
    theme_nsw(geom_ink = "red_02")
  expect_equal(unique(built_aes(bars, "fill")), nsw_colours$red_02)
})

test_that("the theme does not override explicit scales", {
  plot <- ggplot2::ggplot(test_df, ggplot2::aes(x, y, colour = g)) +
    ggplot2::geom_point() +
    ggplot2::scale_colour_manual(
      values = c(a = "red", b = "green", c = "blue")
    ) +
    theme_nsw()
  expect_equal(built_aes(plot, "colour"), c("red", "green", "blue"))
})

test_that("before ggplot2 4 the theme keeps everything but the palettes", {
  with_options(list(nswtheme.force_legacy = TRUE), {
    theme <- theme_nsw(
      base_family = "Body Font",
      header_family = "Header Font",
      ink = "grey_01",
      paper = "off_white"
    )
    expect_true(attr(theme, "complete"))
    expect_equal(ggplot2::calc_element("axis.text", theme)$family, "Body Font")
    expect_equal(ggplot2::calc_element("plot.title", theme)$family, "Header Font")
    expect_equal(ggplot2::calc_element("text", theme)$colour, nsw_colours$grey_01)
    expect_equal(
      ggplot2::calc_element("plot.background", theme)$fill,
      nsw_colours$off_white
    )
    expect_equal(theme$panel.grid.major$colour, nsw_colours$grey_03)
    expect_s3_class(ggplot2::calc_element("axis.ticks.length", theme), "unit")

    # the palettes are what is lost, and what the scales put back
    expect_null(theme$palette.colour.discrete)
    plot <- ggplot2::ggplot(test_df, ggplot2::aes(x, y, colour = g)) +
      ggplot2::geom_point() +
      theme +
      scale_colour_nsw(palette = pal_waratah("qual"))
    expect_equal(built_aes(plot, "colour"), pal_waratah("qual")(3))
  })
})
