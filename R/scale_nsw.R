#' NSW colour and fill scales
#'
#' Applies an NSW palette to the `colour` or `fill` aesthetic. The palette
#' decides the kind of scale: a discrete palette gives a discrete scale, a
#' continuous one a continuous scale.
#'
#' From ggplot2 4.0.0 [`theme_nsw()`] sets default palettes itself, so these
#' scales are only needed when you want to change the defaults.
#' With earlier ggplot2 versions, you need these scales also for defaults.
#'
#' @param ... passed to [`ggplot2::discrete_scale()`] or
#'   [`ggplot2::continuous_scale()`].
#' @param palette a palette object from [`pal_nsw()`] or [`pal_waratah()`], or a
#'   vector of colours named as in [`nsw_colours`].
#' @param aesthetics aesthetics this scale applies to.
#' @param na.value colour used for missing values.
#'
#' @returns A ggplot2 scale, to add to a plot.
#' @family palettes
#' @seealso [`theme_nsw()`]
#' @export
#' @examples
#' library(ggplot2)
#'
#' ggplot(palmerpenguins::penguins) +
#'   geom_point(aes(bill_length_mm, flipper_length_mm, colour = species)) +
#'   scale_colour_nsw()
#'
#' ggplot(palmerpenguins::penguins) +
#'   geom_point(aes(bill_length_mm, flipper_length_mm, colour = body_mass_g)) +
#'   scale_colour_nsw(palette = pal_waratah("seq"))
#'
#' ggplot(palmerpenguins::penguins) +
#'   geom_bar(aes(island, fill = species)) +
#'   scale_fill_nsw(palette = pal_nsw_manual(c("blue_01", "red_02", "teal_02")))
#'
scale_colour_nsw <- function(
  ...,
  palette = pal_waratah("qual"),
  aesthetics = "colour",
  na.value = "grey50"
) {
  scale_nsw(palette, aesthetics, na.value = na.value, ...)
}

#' @rdname scale_colour_nsw
#' @export
scale_fill_nsw <- function(
  ...,
  palette = pal_waratah("qual"),
  aesthetics = "fill",
  na.value = "grey50"
) {
  scale_nsw(palette, aesthetics, na.value = na.value, ...)
}

#' @rdname scale_colour_nsw
#' @export
scale_color_nsw <- scale_colour_nsw

scale_nsw <- function(palette, aesthetics, ..., guide = NULL) {
  if (is.character(palette)) {
    palette <- new_colour_pal(resolve_colours(palette))
  }
  discrete <- is_discrete_pal(palette)
  if (is.null(guide)) {
    guide <- if (discrete) "legend" else "colourbar"
  }
  if (discrete) {
    ggplot2::discrete_scale(
      aesthetics = aesthetics,
      palette = palette,
      guide = guide,
      ...
    )
  } else {
    ggplot2::continuous_scale(
      aesthetics = aesthetics,
      palette = palette,
      guide = guide,
      ...
    )
  }
}
