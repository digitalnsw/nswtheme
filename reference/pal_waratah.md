# Flexible colour palettes

Unlike
[`pal_nsw()`](https://digitalnsw.github.io/nswtheme/reference/pal_nsw.md),
`pal_waratah()` is not based strictly on the NSW colour palette grids.
It tries to choose colours that are perceptually distinct, optionally
taking into account colour-blindness when doing so.

## Usage

``` r
pal_waratah(
  type = c("qual", "seq", "div", "pairs", "triples"),
  hue = 1,
  cvd = getOption("nswtheme.cvd", default = FALSE),
  variant = getOption("nswtheme.colour_theme", default = "base"),
  direction = 1
)
```

## Arguments

- type:

  type of palette that should be generated:

  - `"qual"` discrete qualitative palette

  - `"seq"` continuous sequential palette: a gradient spanning extreme
    tones of `hue`

  - `"div"` continuous diverging palette: a gradient spanning extreme
    tones of `hue` and a second distinct colour.

  - `"pairs"`, `"triples"` like \`"qual"“ but in sets of 2 or 3 tones
    per hue.

- hue:

  main hue, either by name of index. See
  [`col_nsw()`](https://digitalnsw.github.io/nswtheme/reference/col_nsw.md)
  for supported values. Only used when `type` is `"seq"` or `"div"`.

- cvd:

  when `TRUE` account for colour vision disorders. Requires the
  `colorBlindness` package.

- variant:

  name of palette variant. Available options are: base, aboriginal,
  corporate, treasury. Ignored unless `hue` or `tone` is specified.

- direction:

  set to -1 to reverse the order of colours in the palette, or 1 for the
  original order.

## Value

A palette object (see [palette
constructors](https://scales.r-lib.org/reference/new_continuous_palette.html))

## See also

Other palettes:
[`pal_nsw()`](https://digitalnsw.github.io/nswtheme/reference/pal_nsw.md)

## Examples

``` r
library(scales)

pal_waratah("qual") |> show_col()

pal_waratah("pairs") |> show_col()

pal_waratah("seq", hue = "red") |> show_col(labels = FALSE)

pal_waratah("div", hue = "yellow", variant = "aboriginal") |>
  show_col(labels = FALSE)

```
