test_that("reactable_nswtheme resolves NSW colour names", {
  skip_if_not_installed("reactable")
  theme <- reactable_nswtheme(colour = "blue_01", backgroundColor = "off_white")
  expect_s3_class(theme, "reactableTheme")
  expect_equal(theme$style$color, nsw_colours$blue_01)
  expect_equal(theme$borderColor, nsw_colours$blue_01)
  expect_equal(theme$backgroundColor, nsw_colours$off_white)
})

test_that("reactable_nswtheme derives the striped colour and header size", {
  skip_if_not_installed("reactable")
  theme <- reactable_nswtheme(base_text_size = 14)
  expect_equal(
    theme$stripedColor,
    scales::col_mix(nsw_colours$white, nsw_colours$blue_01, amount = 0.3)
  )
  expect_equal(theme$style$fontSize, "14pt")
  expect_equal(theme$headerStyle$fontSize, "16pt")
})
