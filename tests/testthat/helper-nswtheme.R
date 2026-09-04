# Test data with one row per discrete level, so that the built colour vector
# lines up with the palette vector without any reordering.
test_df <- data.frame(
  x = 1:3,
  y = c(2, 3, 1),
  g = factor(c("a", "b", "c"))
)

# Test data for continuous scales, spanning the full range in row order.
test_df_cts <- data.frame(
  x = 1:5,
  y = c(2, 3, 1, 5, 4),
  z = seq(0, 10, length.out = 5)
)

# Computed aesthetics of a built plot.
built_aes <- function(plot, aesthetic, layer = 1L) {
  ggplot2::layer_data(plot, layer)[[aesthetic]]
}

with_options <- function(opts, code) {
  old <- options(opts)
  on.exit(options(old), add = TRUE)
  force(code)
}

with_colour_theme <- function(variant, code) {
  with_options(list(nswtheme.colour_theme = variant), code)
}

# Locates colours in a grid, so that tests can talk about hues and tones
# rather than hex codes.
grid_position <- function(colour, variant = "base") {
  grid <- nsw_colour_grids[[variant]]
  idx <- match(colour, unlist(grid))
  data.frame(
    tone = rownames(grid)[(idx - 1L) %% nrow(grid) + 1L],
    hue = colnames(grid)[(idx - 1L) %/% nrow(grid) + 1L]
  )
}

with_defined_theme <- function(name, parent, colours, code) {
  define_colour_theme(name, parent, colours)
  on.exit(rm(list = name, envir = nsw_colour_grids), add = TRUE)
  force(code)
}

pal_values <- function(pal) {
  pal(palette_nlevels(pal))
}

skip_if_old_ggplot2 <- function() {
  skip_if_not(has_theme_elements(), "needs ggplot2 >= 4.0.0")
}
