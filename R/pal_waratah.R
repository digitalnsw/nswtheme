#' Flexible colour palettes
#'
#' Unlike [`pal_nsw()`], `pal_waratah()` is not based strictly on the NSW colour
#' palette grids.
#' It tries to choose colours that are perceptually distinct, optionally taking
#' into account colour-blindness when doing so.
#'
#' @param type type of palette that should be generated:
#'   - `"qual"` discrete qualitative palette
#'   - `"seq"` continuous sequential palette: a gradient spanning extreme tones of `hue`
#'   - `"div"` continuous diverging palette: a gradient spanning extreme tones of `hue`
#'     and a second distinct colour.
#'   - `"pairs"`, `"triples"` like `"qual"`` but in sets of 2 or 3 tones per hue.
#' @param hue main hue, either by name of index.
#'   See [`col_nsw()`] for supported values.
#'   Only used when `type` is `"seq"` or `"div"`.
#' @param cvd when `TRUE` account for colour vision disorders.
#'   Requires the `colorBlindness` package.
#' @inheritParams pal_nsw
#'
#' @returns A palette object (see [palette constructors][scales::new_continuous_palette])
#' @family palettes
#' @export
#' @examples
#' library(scales)
#'
#' pal_waratah("qual") |> show_col()
#' pal_waratah("pairs") |> show_col()
#' pal_waratah("seq", hue = "red") |> show_col(labels = FALSE)
#' pal_waratah("div", hue = "yellow", variant = "aboriginal") |>
#'   show_col(labels = FALSE)
#'
pal_waratah <- function(
  type = c("qual", "seq", "div", "pairs", "triples"),
  hue = 1,
  cvd = getOption("nswtheme.cvd", default = FALSE),
  variant = getOption("nswtheme.colour_theme", default = "base"),
  direction = 1
) {
  type <- rlang::arg_match(type)

  if (type == "qual") {
    if (!missing(hue)) {
      cli::cli_warn("{.arg hue} will be ignored")
    }
    colours <-
      col_nsw(tone = 1:2, variant = variant) |>
      col_anticluster(cvd = cvd) |>
      col_distinct(cvd = cvd) |>
      col_anticluster(cvd = cvd)
    if (direction < 0) {
      colours <- rev(colours)
    }
    scales::pal_manual(unlist(colours), type = "colour")
  } else if (type %in% c("pairs", "triples")) {
    if (!missing(hue)) {
      cli::cli_warn("{.arg hue} will be ignored")
    }
    hues <- col_nsw(tone = 2, variant = variant) |> col_anticluster(cvd = cvd)
    hues <- match(hues, col_nsw(tone = 2, variant = variant))
    tones <- if (type == "pairs") 2:3 else 1:3
    colours <- col_nsw(hue = hues, tone = tones, variant = variant)
    if (direction < 0) {
      colours <- rev(colours)
    }
    scales::pal_manual(unlist(colours), type = "colour")
  } else if (type == "seq") {
    if (variant == "base" && missing(hue)) {
      hue = 4L
    }
    colours <- col_nsw(hue = hue, variant = variant)
    if (direction < 0) {
      colours <- rev(colours)
    }
    scales::pal_gradient_n(colours)
  } else if (type == "div") {
    if (variant == "base" && missing(hue)) {
      hue = 4L
    }
    initial <- col_nsw(tone = 2, hue = hue, variant = variant)
    initial <- which(col_nsw(tone = 2, variant = variant) == initial)
    hues <- col_nsw(tone = 2, variant = variant) |>
      col_anticluster(initial = initial, cvd = cvd)
    final <- which(col_nsw(tone = 2, variant = variant) == hues[[2]])
    colours <- c(
      col_nsw(hue = initial, variant = variant),
      "white",
      rev(col_nsw(hue = final, variant = variant))
    )
    if (direction < 0) {
      colours <- rev(colours)
    }
    scales::pal_gradient_n(colours)
  }
}
