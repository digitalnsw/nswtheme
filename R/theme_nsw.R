#' Theme plots using NSW colours and fonts
#'
#' A 'ggplot2' theme compatible with the NSW design system.
#' It sets default colour scales, fonts, and some other styles.
#'
#' @param geom_ink default ink colour used by geoms for points, lines and fills.
#' @param variant name of palette variant.
#'   Available options are: `r rev(names(nsw_colour_grids))`.
#' @param void whether to hide grid lines and axes.
#'   If `TRUE`, all grid lines and axes are removed. This is useful when creating
#'   pie/donut charts.
#' @param show_grid_lines whether to show grid lines.
#'   If `FALSE`, all grid lines are removed but the axis text is retained.
#'   Ignored when `void` is `TRUE`.
#' @inheritParams ggplot2::theme_minimal
#' @returns ggplot theme specification to add to a plot
#' @section Compatibility:
#' ggplot2 versions prior to 4.0.0 are missing some theme elements. If your'e
#' using an older version:
#'   * `accent` is accepted but unused,
#'   * geoms keep the ggplot2 defaults instead of `geom_ink`,
#'   * NSW palettes need [`scale_colour_nsw()`] or [`scale_fill_nsw()`].
#'
#' @export
#' @importFrom ggplot2 theme element_blank element_text element_line element_rect %+replace% rel
#' @examples
#' library(ggplot2)
#' theme_set(theme_nsw())
#'
#' ggplot(palmerpenguins::penguins) +
#'   geom_point(aes(
#'     x = bill_length_mm,
#'     y = flipper_length_mm,
#'     colour = species,
#'     size = body_mass_g
#'   )) +
#'   labs(
#'     caption = "Data from {palmerpenguins}",
#'     x = "Bill length (mm)",
#'     y = "Flipper length (mm)",
#'     colour = "Species",
#'     size = "Body mass (g)"
#'   )
#'
theme_nsw <- function(
  base_size = 11,
  base_family = "Public Sans",
  header_family = "Public Sans",
  base_line_size = base_size / 22,
  base_rect_size = base_size / 22,
  ink = "black",
  paper = "white",
  geom_ink = "blue_01",
  accent = "blue_02",
  variant = getOption("nswtheme.colour_theme", default = "base"),
  show_grid_lines = TRUE,
  void = FALSE
) {
  # support using NSW colour names
  ink <- resolve_colours(ink)
  geom_ink <- resolve_colours(geom_ink)
  paper <- resolve_colours(paper)
  accent <- resolve_colours(accent)

  new_theme <-
    theme_minimal(
      base_size = base_size,
      base_family = base_family,
      header_family = header_family,
      base_line_size = base_line_size,
      base_rect_size = base_rect_size,
      ink = ink,
      paper = paper,
      accent = accent
    ) %+replace%
    theme(
      # plot.title = marquee::element_marquee(
      #   width = 1,
      #   family = header_family,
      #   size = base_size + 2,
      #   style = marquee::classic_style(weight = "bold"),
      #   colour = ink,
      #   hjust = 0,
      # ),
      # plot.subtitle = marquee::element_marquee(
      #   width = 1,
      #   family = header_family,
      #   margin = ggplot2::margin_part(t = base_size, b = base_size)
      # ),
      plot.title.position = "plot",
      plot.title = ggtext::element_markdown(
        family = header_family,
        face = "bold",
        size = base_size + 2,
        color = ink,
        hjust = 0,
        halign = 0,
        vjust = 1,
        valign = 0
      ),
      plot.subtitle = ggtext::element_textbox_simple(
        margin = margin_part(t = base_size, b = base_size * 2),
        lineheight = 1,
        hjust = 0,
        halign = 0,
        vjust = 1,
        valign = 0
      ),
      plot.caption.position = "plot",
      plot.caption = ggtext::element_markdown(
        margin = ggplot2::margin(t = 12),
        hjust = 0,
        halign = 0,
        vjust = 1,
        valign = 0
      ),
      legend.key = element_rect(colour = ink),
      panel.grid.major = element_line(
        colour = nsw_colours$grey_03,
        linewidth = rel(0.3)
      ),
      panel.grid.minor = element_line(
        color = nsw_colours$grey_03,
        linetype = "dotted",
        linewidth = rel(0.3)
      ),
      strip.background = element_rect(fill = "transparent"),
      axis.line = element_line(
        colour = nsw_colours$grey_02,
        linewidth = rel(0.3)
      ),
      axis.ticks = element_line(
        colour = nsw_colours$grey_03,
        linewidth = rel(0.3)
      ),
      axis.ticks.length = ticks_length(base_size),
      complete = TRUE
    ) %+replace%
    theme_nsw_extras(ink, paper, accent, geom_ink, variant)

  if (!show_grid_lines) {
    new_theme <- new_theme %+replace%
      ggplot2::theme(
        axis.ticks = element_blank(),
        panel.grid.major = element_blank(),
        panel.grid.minor = element_blank(),
        complete = TRUE
      )
  }

  if (void) {
    new_theme <- new_theme %+replace%
      ggplot2::theme(
        plot.background = element_blank(),
        panel.background = element_blank(),
        panel.grid.major = element_blank(),
        panel.grid.minor = element_blank(),
        axis.title = element_blank(),
        axis.text = element_blank(),
        axis.ticks = element_blank(),
        axis.line = element_blank(),
        axis.ticks.x = element_blank(),
        complete = TRUE
      )
  }

  new_theme
}

# ggplot2 4.0.0 carries geom defaults and scale palettes in the theme itself.
# On earlier versions use scale_colour_nsw()/scale_fill_nsw() instead.
theme_nsw_extras <- function(ink, paper, accent, geom_ink, variant) {
  if (!has_theme_elements()) {
    return(theme())
  }
  theme(
    geom = ggplot2::element_geom(
      ink = ink,
      paper = paper,
      accent = accent,
      colour = geom_ink,
      fill = geom_ink,
      pointsize = 2,
    ),
    palette.colour.discrete = pal_waratah(type = "qual", variant = variant),
    palette.fill.discrete = pal_waratah(type = "qual", variant = variant),
    palette.colour.continuous = pal_waratah(type = "seq", variant = variant),
    palette.fill.continuous = pal_waratah(type = "seq", variant = variant)
  )
}
