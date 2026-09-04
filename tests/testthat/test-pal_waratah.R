test_that("qual palettes are a reordering of the two darkest tones", {
  pal <- pal_waratah("qual")
  expect_true(is_discrete_pal(pal))
  expect_equal(palette_type(pal), "colour")

  colours <- pal_values(pal)
  expect_false(anyDuplicated(colours) > 0)
  expect_true(all(colours %in% col_nsw(tone = 1:2)))
})

test_that("qual palettes lead with the most distinct colours", {
  expect_equal(
    pal_values(pal_waratah("qual", variant = "corporate")),
    c("#d7153a", "#002664", "#146cfd", "#630019", "#495054", "#22272b")
  )
  expect_equal(
    pal_waratah("qual")(3),
    c("#faaf05", "#441170", "#004000")
  )
})

test_that("qual palettes respect the variant", {
  expect_true(all(
    pal_values(pal_waratah("qual", variant = "aboriginal")) %in%
      col_nsw(tone = 1:2, variant = "aboriginal")
  ))
  expect_setequal(
    pal_values(pal_waratah("qual", variant = "corporate")),
    unname(col_nsw(tone = 1:2, variant = "corporate"))
  )
})

test_that("pairs and triples group tones within a hue", {
  for (variant in c("base", "corporate", "aboriginal")) {
    grid <- nsw_colour_grids[[variant]]
    for (type in c("pairs", "triples")) {
      n_tones <- if (type == "pairs") 2L else 3L
      colours <- pal_values(pal_waratah(type, variant = variant))
      expect_length(colours, n_tones * ncol(grid))

      pos <- grid_position(colours, variant)
      block <- rep(seq_len(length(colours) / n_tones), each = n_tones)
      expect_true(
        all(tapply(pos$hue, block, \(h) length(unique(h)) == 1L)),
        label = paste(variant, type, "hue blocks")
      )
      expect_true(
        all(tapply(pos$tone, block, \(t) {
          identical(
            unname(t),
            rownames(grid)[
              if (type == "pairs") 2:3 else 1:3
            ]
          )
        })),
        label = paste(variant, type, "tone blocks")
      )
      expect_false(anyDuplicated(pos$hue[!duplicated(block)]) > 0)
    }
  }
})

test_that("pairs and triples use the expected tonal rows", {
  in_tones <- function(type, tones) {
    all(pal_values(pal_waratah(type)) %in% col_nsw(tone = tones))
  }
  expect_true(in_tones("pairs", 2:3))
  expect_true(in_tones("triples", 1:3))
  expect_false(any(pal_values(pal_waratah("pairs")) %in% col_nsw(tone = 1)))
  expect_false(any(pal_values(pal_waratah("triples")) %in% col_nsw(tone = 4)))
})

test_that("seq palettes span the tones of one hue", {
  pal <- pal_waratah("seq", hue = "reds")
  expect_true(is_continuous_pal(pal))
  expect_equal(
    pal(c(0, 1)),
    toupper(unname(col_nsw(hue = "reds")[c(1, 4)]))
  )
  # blues are the default hue for the base variant
  expect_equal(
    pal_waratah("seq")(c(0, 1)),
    pal_waratah("seq", hue = 4L)(c(0, 1))
  )
})

test_that("div palettes pass through white in the middle", {
  pal <- pal_waratah("div", hue = "reds")
  expect_true(is_continuous_pal(pal))
  expect_equal(pal(0.5), "#FFFFFF")
  expect_equal(pal(0), toupper(unname(col_nsw(hue = "reds")[[1]])))
  # the far end is a different hue chosen to contrast with `hue`
  expect_false(pal(1) %in% toupper(unname(col_nsw(hue = "reds"))))
})

test_that("direction = -1 reverses every palette type", {
  for (type in c("qual", "pairs", "triples")) {
    expect_equal(
      pal_values(pal_waratah(type, direction = -1)),
      rev(pal_values(pal_waratah(type))),
      label = type
    )
  }
  for (type in c("seq", "div")) {
    expect_equal(
      pal_waratah(type, direction = -1)(c(0, 0.5, 1)),
      rev(pal_waratah(type)(c(0, 0.5, 1))),
      label = type
    )
  }
})

test_that("hue is ignored for palette types that do not use it", {
  expect_warning(pal_waratah("qual", hue = "reds"), "hue")
  expect_warning(pal_waratah("pairs", hue = "reds"), "hue")
  expect_warning(pal_waratah("triples", hue = "reds"), "hue")
  expect_no_warning(pal_waratah("seq", hue = "reds"))
  expect_no_warning(pal_waratah("div", hue = "reds"))
})

test_that("type is matched against the documented options", {
  expect_error(pal_waratah("nonexistent"), "type")
  expect_equal(pal_values(pal_waratah()), pal_values(pal_waratah("qual")))
})

test_that("cvd simulation changes the colour ordering", {
  skip_if_not_installed("colorBlindness")
  plain <- pal_values(pal_waratah("qual", cvd = FALSE))
  simulated <- pal_values(pal_waratah("qual", cvd = TRUE))
  expect_true(all(simulated %in% col_nsw(tone = 1:2)))
  expect_false(identical(plain, simulated))
  expect_equal(
    pal_values(with_options(list(nswtheme.cvd = TRUE), pal_waratah("qual"))),
    simulated
  )
})
