#' @importFrom ggplot2 waiver is_waiver
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
  scales::pal_manual(unlist(pals)[idx], type = "colour")
}

#' @export
#' @rdname ggplot_palettes
pal_c <- function(...) {
  pals <- Map(as_colour_vector, rlang::list2(...))
  scales::pal_manual(unlist(pals), type = "colour")
}

#' @export
#' @rdname ggplot_palettes
pal_stretch <- function(pal) {
  cts <- scales::as_continuous_pal(pal)
  scales::as_discrete_pal(cts)
}

#' @export
#' @rdname ggplot_palettes
col_contrasting <- function(colour, light = "white", dark = "black") {
  lab <- farver::decode_colour(colour, to = "lab")
  ifelse(lab[, 1] < 50, light, dark)
}

as_colour_vector <- function(x) {
  if (scales::is_discrete_pal(x)) {
    x(scales::palette_nlevels(x))
  } else {
    x
  }
}
