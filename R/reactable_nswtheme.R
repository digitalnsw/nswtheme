#' Theme for reactable interactive tables
#'
#' If using reactable, this helper constructs a theme.
#'
#' @param colour starting colour used only to set a common default for other
#'   colour parameters.
#' @param text_colour colour of all text.
#' @param backgroundColor background colour.
#' @param borderColor colour for the horizontal lines between rows.
#' @param stripedColor fill colour for alternate rows.
#'   When `NA`, this is set to a blend of `borderColor` and `backgroundColor`.
#' @param title_family font family for title text.
#' @param base_family font family for normal text.
#' @param base_text_size base text size in pt.
#'   The header size is relative to the base text size.
#' @param ... other parameters to pass to [`reactable::reactableTheme()`].
#'   For examples of what can be done with reactable, see
#'   <https://glin.github.io/reactable/articles/cookbook/cookbook.html>.
#'
#' @details
#' Colours can be specified as named NSW colours as in [`nsw_colours`].
#'
#' As normal with HTML elements, you must make sure that the final document
#' loads the necessary fonts. See `vignette("nswtheme")` for instructions.
#'
#' @return A reactable theme object
#' @export
#' @examples
#' library(reactable)
#'
#' # The default theme
#' head(palmerpenguins::penguins, 10) |>
#'   reactable(theme = reactableTheme())
#'
#' # Adding nswtheme style
#' head(palmerpenguins::penguins, 10) |>
#'   reactable(theme = reactable_nswtheme())
#'
#' # More customised styling
#' head(palmerpenguins::penguins, 10) |>
#'   reactable(
#'     theme = reactable_nswtheme(
#'       colour = "blue_01",
#'       base_family = "Arial",
#'       text_colour = "black",
#'       backgroundColor = NULL
#'     ),
#'     striped = TRUE
#'   )
#'
reactable_nswtheme <- function(
  colour = "blue_01",
  text_colour = colour,
  borderColor = colour,
  backgroundColor = "white",
  base_family = "Public Sans",
  title_family = "Public Sans",
  base_text_size = 10,
  stripedColor = NA,
  ...
) {
  rlang::check_installed("reactable")

  text_colour <- resolve_colours(text_colour)
  backgroundColor <- resolve_colours(backgroundColor)
  borderColor <- resolve_colours(borderColor)

  style_list <- list(
    color = text_colour,
    fontFamily = base_family,
    fontSize = paste0(base_text_size, "pt")
  )
  table_style_list <- list(
    fontFamily = base_family,
    fontSize = paste0(base_text_size, "pt")
  )
  header_style_list <- list(
    fontFamily = title_family,
    fontSize = paste0(base_text_size + 2, "pt")
  )
  cell_style_list <- list(
    fontFamily = base_family,
    fontSize = paste0(base_text_size, "pt")
  )

  if (is.na(stripedColor)) {
    stripedColor <- scales::col_mix(backgroundColor, borderColor, amount = 0.3)
  }

  reactable::reactableTheme(
    style = style_list,
    tableStyle = table_style_list,
    headerStyle = header_style_list,
    cellStyle = cell_style_list,
    backgroundColor = backgroundColor,
    borderColor = borderColor,
    stripedColor = stripedColor,
    ...
  )
}
