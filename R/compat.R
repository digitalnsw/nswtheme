# Backports for the versions pinned on SAPHaRI: ggplot2 3.5.1, scales 1.3.0.
#
# If updating to scales 1.4.0: delete the palette API below and add
#   @importFrom scales new_discrete_palette new_continuous_palette
#   @importFrom scales is_discrete_pal is_continuous_pal
#   @importFrom scales palette_nlevels palette_type
#   @importFrom scales as_discrete_pal as_continuous_pal col_mix
#
# If updating to ggplot2 4.0.0: delete:
#   - has_theme_elements()
#   - is_waiver(),
#   - theme_minimal()
#   - margin_part()
#   - ticks_length(),
# inline theme_nsw_extras() into theme_nsw(),
# restore axis.ticks.length = rel(1), and
# add:
#   @importFrom ggplot2 is_waiver theme_minimal margin_part

new_discrete_palette <- function(fun, type, nlevels = NA) {
  class(fun) <- union(c("pal_discrete", "scales_pal"), class(fun))
  attr(fun, "type") <- type
  attr(fun, "nlevels") <- nlevels
  fun
}

new_continuous_palette <- function(fun, type, na_safe = NA) {
  class(fun) <- union(c("pal_continuous", "scales_pal"), class(fun))
  attr(fun, "type") <- type
  attr(fun, "na_safe") <- na_safe
  fun
}

is_discrete_pal <- function(x) inherits(x, "pal_discrete")

is_continuous_pal <- function(x) inherits(x, "pal_continuous")

palette_nlevels <- function(pal) attr(pal, "nlevels")

palette_type <- function(pal) attr(pal, "type")

as_continuous_pal <- function(x, ...) {
  if (is_continuous_pal(x)) {
    return(x)
  }
  new_continuous_palette(
    scales::colour_ramp(x(palette_nlevels(x))),
    type = "colour",
    na_safe = FALSE
  )
}

as_discrete_pal <- function(x, ...) {
  if (is_discrete_pal(x)) {
    return(x)
  }
  force(x)
  new_discrete_palette(
    function(n) x(seq(0, 1, length.out = n)),
    type = palette_type(x),
    nlevels = 255
  )
}

col_mix <- function(a, b, amount = 0.5, space = "rgb") {
  # recycling follows scales: a zero-length input makes the result zero-length
  sizes <- setdiff(unique(lengths(list(a, b, amount))), 1L)
  if (length(sizes) > 1) {
    cli::cli_abort("{.arg a}, {.arg b} and {.arg amount} must be recyclable.")
  }
  size <- if (length(sizes) == 1) sizes else 1L
  if (size == 0) {
    return(character())
  }
  if (any(amount < 0 | amount > 1)) {
    cli::cli_abort("{.arg amount} must be between (0, 1).")
  }
  a <- farver::decode_colour(rep_len(a, size), alpha = TRUE, to = space)
  b <- farver::decode_colour(rep_len(b, size), alpha = TRUE, to = space)
  new <- a * (1 - amount) + b * amount
  farver::encode_colour(new, alpha = new[, "alpha"], from = space)
}

is_waiver <- function(x) inherits(x, "waiver")

has_theme_elements <- function() {
  !isTRUE(getOption("nswtheme.force_legacy")) &&
    utils::packageVersion("ggplot2") >= "4.0.0"
}

# ink, paper, accent and header_family are new in ggplot2 4.0.0
theme_minimal <- function(
  base_size = 11,
  base_family = "",
  header_family = NULL,
  base_line_size = base_size / 22,
  base_rect_size = base_size / 22,
  ink = "black",
  paper = "white",
  accent = "#3366FF"
) {
  if (has_theme_elements()) {
    return(ggplot2::theme_minimal(
      base_size = base_size,
      base_family = base_family,
      header_family = header_family,
      base_line_size = base_line_size,
      base_rect_size = base_rect_size,
      ink = ink,
      paper = paper,
      accent = accent
    ))
  }

  ggplot2::theme_minimal(
    base_size = base_size,
    base_family = base_family,
    base_line_size = base_line_size,
    base_rect_size = base_rect_size
  ) +
    theme(
      line = element_line(colour = ink),
      rect = element_rect(fill = paper, colour = ink),
      text = element_text(colour = ink),
      title = element_text(family = header_family),
      axis.text = element_text(colour = col_mix(ink, paper, 0.302)),
      strip.text = element_text(colour = col_mix(ink, paper, 0.1)),
      plot.background = element_rect(fill = paper, colour = NA)
    )
}

margin_part <- function(t = 0, r = 0, b = 0, l = 0) {
  if (has_theme_elements()) {
    ggplot2::margin_part(t = t, r = r, b = b, l = l)
  } else {
    ggplot2::margin(t = t, r = r, b = b, l = l)
  }
}

ticks_length <- function(base_size) {
  if (has_theme_elements()) rel(1) else ggplot2::unit(base_size / 2, "pt")
}
