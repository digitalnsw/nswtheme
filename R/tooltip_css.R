#' Style interactive plot tooltips
#'
#' CSS code required to add nswtheme-styled tooltips to interactive graphs
#' created using ggiraph.
#'
#' @export
#'
#' @param background_colour tooltip background colour
#' @param text_colour tooltip text colour
#' @param font_family font family for text in tooltips
#' @param font_size font size for text in tooltips
#'
#' @details
#' As normal with HTML elements, you must make sure that the final document
#' loads the necessary fonts. See `vignette("nswtheme")` for instructions.
#'
#' @return A character vector containing CSS rules
#' @examples
#' tooltip_css()
#'
tooltip_css <- function(
  background_colour = "grey_01",
  text_colour = "off_white",
  font_family = '"Public Sans", Arial, sans',
  font_size = "11pt"
) {
  background_colour <- resolve_colours(background_colour)
  text_colour <- resolve_colours(text_colour)

  css <- paste0(
    c(
      "max-width: 300px;",
      "padding: 10px;",
      sprintf("background-color: %s;", background_colour),
      sprintf("color: %s;", text_colour),
      sprintf("font-family: %s", font_family),
      sprintf("font-size: %s;", font_size)
    ),
    collapse = " "
  )
  invisible(css)
}
