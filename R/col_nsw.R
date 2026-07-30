#' @export
#' @rdname col_nsw
#' @format NULL
nsw_colours <- list(
  # NOTE: order is important. Adjust grid definitions below if changing order.
  black = "#000000",
  white = "#ffffff",
  off_white = "#F2F2F2",

  grey_01 = "#22272b",
  grey_02 = "#495054",
  grey_03 = "#cdd3d6",
  grey_04 = "#ebebeb",
  green_01 = "#004000",
  green_02 = "#00aa45",
  green_03 = "#a8edb3",
  green_04 = "#dbfadf",
  teal_01 = "#0b3f47",
  teal_02 = "#2e808e",
  teal_03 = "#8cdbe5",
  teal_04 = "#d1eeea",
  blue_01 = "#002664",
  blue_02 = "#146cfd",
  blue_03 = "#8ce0ff",
  blue_04 = "#cbedfd",
  purple_01 = "#441170",
  purple_02 = "#8055f1",
  purple_03 = "#cebfff",
  purple_04 = "#e6e1fd",
  fuchsia_01 = "#65004d",
  fuchsia_02 = "#d912ae",
  fuchsia_03 = "#f4b5e6",
  fuchsia_04 = "#fddef2",
  red_01 = "#630019",
  red_02 = "#d7153a",
  red_03 = "#ffb8c1",
  red_04 = "#ffe6ea",
  orange_01 = "#941b00",
  orange_02 = "#f3631b",
  orange_03 = "#FFCE99",
  orange_04 = "#fdeddf",
  yellow_01 = "#694800",
  yellow_02 = "#faaf05",
  yellow_03 = "#fde79a",
  yellow_04 = "#fff4cf",
  brown_01 = "#523719",
  brown_02 = "#b68d5d",
  brown_03 = "#e8d0b5",
  brown_04 = "#ede3d7",

  earth_red = "#950906",
  ember_red = "#e1261c",
  coral_pink = "#fbb4b3",
  galah_pink = "#fdd9d9",
  deep_orange = "#882600",
  orange_ochre = "#ee6314",
  clay_orange = "#f4aa7d",
  sunset_orange = "#f9d4be",
  riverbed_brown = "#552105",
  firewood_brown = "#9e5332",
  claystone_brown = "#d39165",
  macadamia_brown = "#e9c8b2",
  bush_honey_yellow = "#895e00",
  sandstone_yellow = "#fea927",
  golden_wattle_yellow = "#FEE48C",
  sunbeam_yellow = "#FFF1C5",
  bushland_green = "#215834",
  marshland_lime = "#78a146",
  gumleaf_green = "#b5cda4",
  saltbush_green = "#dae6d1",
  billabong_blue = "#00405e",
  saltwater_blue = "#0d6791",
  light_water_blue = "#84c5d1",
  coastal_blue = "#c1e2e8",
  bush_plum = "#472642",
  spirit_lilac = "#9a5e93",
  lilli_pilli_purple = "#c99ac2",
  dusk_purple = "#e4cce0",
  charcoal_grey = "#272727",
  emu_grey = "#555555",
  ash_grey = "#ccc6c2",
  smoke_grey = "#e5e3e0"
)

# defines the offsets and dimensions of each colour grid,
# used to index into the above vector
new_grid <- function(offset, hues, tones) {
  n_cols <- length(hues) * length(tones)
  idx <- seq_len(n_cols) + offset
  cols <- matrix(nsw_colours[idx], ncol = length(hues))
  labs <- matrix(names(nsw_colours)[idx], ncol = length(hues))
  dimnames(cols) <- dimnames(labs) <- list(tones, hues)
  attr(cols, "labels") <- labs
  class(cols) <- c("col_grid", class(cols))
  cols
}

# implements slicing i.e. `[` for the grid objects, but preserving labels
# and allowing unambiguous substrings
grid_slice <- function(col_grid, hue, tone, .transpose = FALSE) {
  if (!missing(hue) && is.character(hue)) {
    hue <- match.arg(hue, colnames(col_grid), several.ok = TRUE)
  }
  if (!missing(tone) && is.character(tone)) {
    tone <- match.arg(tone, rownames(col_grid), several.ok = TRUE)
  }
  shp <- if (.transpose) t else identity
  cols <- shp(col_grid[tone, hue])
  labs <- shp(attr(col_grid, "labels")[tone, hue])
  attr(cols, "labels") <- labs
  cols
}

grid_get <- function(name) {
  name <- match.arg(name, names(nsw_colour_grids))
  get(name, envir = nsw_colour_grids, inherits = FALSE)
}

nsw_colour_grids <- rlang::new_environment()
nsw_colour_grids[["base"]] <- new_grid(
  offset = 3L,
  hues = c(
    "greys",
    "greens",
    "teals",
    "blues",
    "purples",
    "fucshias",
    "reds",
    "oranges",
    "yellows",
    "browns"
  ),
  tones = c("dark", "normal", "light", "pale")
)
nsw_colour_grids[["aboriginal"]] <- new_grid(
  offset = 43L,
  hues = c(
    "reds",
    "oranges",
    "browns",
    "yellows",
    "greens",
    "blues",
    "purples",
    "greys"
  ),
  tones = c("dark", "normal", "light", "pale")
)

#' @param name name for the new colour theme.
#' @param parent name of the parent grid or theme, usually `"base"` or `"aboriginal"`.
#' @param colours character vector of colour column names.
#' @export
#' @rdname col_nsw
define_colour_theme <- function(name, parent, colours) {
  parent <- match.arg(parent, names(nsw_colour_grids))
  col_grid <- get(parent, envir = nsw_colour_grids, inherits = FALSE)
  nsw_colour_grids[[name]] <- grid_slice(col_grid, hue = colours)
  NULL
}

define_colour_theme("corporate", "base", c("blue", "red", "grey"))
define_colour_theme("treasury", "base", c("teal", "grey", "orange", "green"))

doc_themes <- function() {
  names(nsw_colour_grids) |>
    setdiff(c("base", "aboriginal")) |>
    sapply(function(x) {
      hues <- paste0(
        colnames(get(x, envir = nsw_colour_grids)),
        collapse = ", "
      )
      sprintf('  - `"%s"`: %s', x, hues)
    }) |>
    paste0(collapse = "\n")
}
#' Access NSW palette grids by rows and/or columns
#'
#' The NSW design system colours work in grids of colour columns and tonal rows.
#'   - `col_nsw()` allows accessing a colour grid like a matrix.
#'     For ggplot colour palettes, you'll normally want [pal_nsw()] instead.
#'   - `define_colour_theme()` defines a new colour theme that can be used
#'     in any nswtheme function that accepts a `variant` parameter.
#'
#' @param hue name or index of the hue - see below.
#' @param tone name or index of the tone - see below.
#' @param variant name of palette variant.
#'   Available options are: `r rev(names(nsw_colour_grids))`.
#' @param byrow vary `tone` faster than `hue` if `TRUE`.
#'
#' @details
#' `hue` and `tone` work the same way as matrix indexing with `[` in that they
#' can be used to return single or multiple entries from the grid.
#' They can be character vectors, integer vectors, or logicals.
#'
#' Anchor colours used to create the NSW colour palettes can also be used
#' stand-alone (e.g. `nsw_colours$blue_01` is \code{"`r nsw_colours$blue_01`"}).
#'
#' @section Colour columns and tonal rows:
#' The `"base"` variant supports:
#'   - **hue**: `r colnames(nsw_colour_grids$base)`
#'   - **tone**: `r rownames(nsw_colour_grids$base)`
#'
#' The `"aboriginal"` variant supports:
#'   - **hue**: `r colnames(nsw_colour_grids$aboriginal)`
#'   - **tone**: `r rownames(nsw_colour_grids$aboriginal)`
#'
#' Colour themes support subsets of the hues from one of the main grids in a specific order.
#' These themes are built in:
#' `r doc_themes()`
#'
#' The default variant can be specified globally with `options(nswtheme.colour_theme)`.
#'
#' Unambiguous shortened forms are accepted, e.g. `pal_nsw(h = "red", v = "a")`.
#'
#' @return
#'   - for `col_nsw()` a named vector of colours,
#'   - for `define_colour_theme()` nothing: this is called for its side effects.
#' @export
#' @seealso [pal_nsw()]
#'
#' @examples
#' col_nsw(h = "blue", v = "aboriginal")
#' col_nsw(h = c("teal", "orange"), t = 1:2)
#' col_nsw(h = c("teal", "orange"), t = 1:2, byrow = TRUE)
#'
col_nsw <- function(
  hue,
  tone,
  variant = getOption("nswtheme.colour_theme", default = "base"),
  byrow = FALSE
) {
  variant <- match.arg(variant, names(nsw_colour_grids))
  if (missing(hue) && missing(tone)) {
    cli::cli_abort("Must specify {.arg hue} and/or {.arg tone}")
  }
  col_grid <- grid_get(name = variant)
  sub_grid <- grid_slice(col_grid, hue, tone, .transpose = byrow)
  rlang::set_names(unlist(sub_grid), unlist(attr(sub_grid, "labels")))
}

# replaces NSW colours with their hex codes, leaving others unchanged
resolve_colours <- function(x) {
  if (is.character(x)) {
    hex_colours <- setdiff(names(nsw_colours), grDevices::colors())
    hex <- rlang::env_get_list(
      x,
      env = as.environment(nsw_colours),
      default = NA_character_
    )
    ifelse(x %in% hex_colours, as.character(hex), x)
  } else {
    x
  }
}
