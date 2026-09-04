test_that("tooltip_css builds valid CSS from NSW colour names", {
  expect_invisible(tooltip_css())
  expect_equal(
    tooltip_css(),
    paste(
      "max-width: 300px;",
      "padding: 10px;",
      sprintf("background-color: %s;", nsw_colours$grey_01),
      sprintf("color: %s;", nsw_colours$off_white),
      'font-family: "Public Sans", Arial, sans;',
      "font-size: 11pt;"
    )
  )
  expect_length(strsplit(tooltip_css(), ";", fixed = TRUE)[[1]], 6L)
})

test_that("tooltip_css passes through colours it does not recognise", {
  css <- tooltip_css(
    background_colour = "#123456",
    text_colour = "rebeccapurple"
  )
  expect_match(css, "background-color: #123456;", fixed = TRUE)
  expect_match(css, "color: rebeccapurple;", fixed = TRUE)
})
