#' @importFrom ggplot2 waiver
NULL

#' Construct palette variants
#'
#' Depending on the structure of your data you may wish to combine palettes
#' according to some pattern. These helpers may come in handy.
#'   - `pal_c()` concatenates multiple discrtee palettes.
#'   - `pal_interleave()` interleaves colours from multiple palettes of the same size.
#'     It helps when your data are grouped and you need more flexibility than the colour grid.
#'   - `pal_stretch()` interpolates a palette into a new discrete palette.
#'     It's useful for stretching the 4 tones into 5 or 6, at the expense of straying from
#'     the NSW grid.
#'   - `col_contrasting()` chooses colours based on the given background colours.
#'     It helps when drawing text on top of a mapped (i.e. variable) fill aesthetic
#'
#' @param ... two or more vectors of colours.
#' @param colour vector of colours.
#' @param light,dark colours to output when `colour` is dark or light respectively.
#' @param pal palette object.
#'
#' @return
#'   - for `col_contrasting()` a vector of colours the same length as `colour`,
#'   - for `pal_*()` a palette object.
#'
#' @export
#' @rdname ggplot_palettes
#'
pal_interleave <- function(...) {
  pals <- Map(as_colour_vector, rlang::list2(...))
  pals <- vctrs::vec_recycle_common(!!!pals)
  n_cols <- length(pals[[1]])
  n_pals <- length(pals)
  idx <- rep(seq_len(n_cols), each = n_pals) +
    rep(seq_len(n_pals) - 1, times = n_cols) * n_cols
  new_colour_pal(unlist(pals)[idx])
}

#' @export
#' @rdname ggplot_palettes
pal_c <- function(...) {
  pals <- Map(as_colour_vector, rlang::list2(...))
  new_colour_pal(unlist(pals))
}

#' @export
#' @rdname ggplot_palettes
pal_stretch <- function(pal) {
  cts <- as_continuous_pal(pal)
  as_discrete_pal(cts)
}

#' @export
#' @rdname ggplot_palettes
col_contrasting <- function(colour, light = "white", dark = "black") {
  lab <- farver::decode_colour(colour, to = "lab")
  ifelse(lab[, 1] < 50, light, dark)
}

as_colour_vector <- function(x) {
  if (is_discrete_pal(x)) {
    x(palette_nlevels(x))
  } else {
    x
  }
}

new_colour_pal <- function(colours) {
  colours <- unname(unlist(colours))
  new_discrete_palette(
    scales::pal_manual(colours),
    type = "colour",
    nlevels = length(colours)
  )
}

new_gradient_pal <- function(colours) {
  new_continuous_palette(
    scales::pal_gradient_n(unname(unlist(colours))),
    type = "colour",
    na_safe = FALSE
  )
}
