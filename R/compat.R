# Backports for the versions pinned on SAPHaRI: ggplot2 3.5.1, scales 1.3.0.
#
# If updating to scales 1.4.0: delete the palette API below and add
#   @importFrom scales new_discrete_palette new_continuous_palette
#   @importFrom scales is_discrete_pal is_continuous_pal
#   @importFrom scales palette_nlevels palette_type
#   @importFrom scales as_discrete_pal as_continuous_pal col_mix
#
# If updating to ggplot2 4.0.0: delete is_waiver() and add
#   @importFrom ggplot2 is_waiver

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
  args <- vctrs::vec_recycle_common(a = a, b = b, amount = amount)
  a <- farver::decode_colour(args$a, alpha = TRUE, to = space)
  b <- farver::decode_colour(args$b, alpha = TRUE, to = space)
  new <- a * (1 - args$amount) + b * args$amount
  farver::encode_colour(new, alpha = new[, "alpha"], from = space)
}

is_waiver <- function(x) inherits(x, "waiver")
