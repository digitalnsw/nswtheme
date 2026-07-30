# Access NSW palette grids by rows and/or columns

The NSW design system colours work in grids of colour columns and tonal
rows.

- `col_nsw()` allows accessing a colour grid like a matrix. For ggplot
  colour palettes, you'll normally want
  [`pal_nsw()`](https://digitalnsw.github.io/nswtheme/reference/pal_nsw.md)
  instead.

- `define_colour_theme()` defines a new colour theme that can be used in
  any nswtheme function that accepts a `variant` parameter.

## Usage

``` r
nsw_colours

define_colour_theme(name, parent, colours)

col_nsw(
  hue,
  tone,
  variant = getOption("nswtheme.colour_theme", default = "base"),
  byrow = FALSE
)
```

## Arguments

- name:

  name for the new colour theme.

- parent:

  name of the parent grid or theme, usually `"base"` or `"aboriginal"`.

- colours:

  character vector of colour column names.

- hue:

  name or index of the hue - see below.

- tone:

  name or index of the tone - see below.

- variant:

  name of palette variant. Available options are: base, aboriginal,
  corporate, treasury.

- byrow:

  vary `tone` faster than `hue` if `TRUE`.

## Value

- for `col_nsw()` a named vector of colours,

- for `define_colour_theme()` nothing: this is called for its side
  effects.

## Details

`hue` and `tone` work the same way as matrix indexing with `[` in that
they can be used to return single or multiple entries from the grid.
They can be character vectors, integer vectors, or logicals.

Anchor colours used to create the NSW colour palettes can also be used
stand-alone (e.g. `nsw_colours$blue_01` is `"#002664"`).

## Colour columns and tonal rows

The `"base"` variant supports:

- **hue**: greys, greens, teals, blues, purples, fucshias, reds,
  oranges, yellows, browns

- **tone**: dark, normal, light, pale

The `"aboriginal"` variant supports:

- **hue**: reds, oranges, browns, yellows, greens, blues, purples, greys

- **tone**: dark, normal, light, pale

Colour themes support subsets of the hues from one of the main grids in
a specific order. These themes are built in:

- `"treasury"`: teals, greys, oranges, greens

- `"corporate"`: blues, reds, greys

The default variant can be specified globally with
`options(nswtheme.colour_theme)`.

Unambiguous shortened forms are accepted, e.g.
`pal_nsw(h = "red", v = "a")`.

## See also

[`pal_nsw()`](https://digitalnsw.github.io/nswtheme/reference/pal_nsw.md)

## Examples

``` r
col_nsw(h = "blue", v = "aboriginal")
#>   billabong_blue   saltwater_blue light_water_blue     coastal_blue 
#>        "#00405e"        "#0d6791"        "#84c5d1"        "#c1e2e8" 
col_nsw(h = c("teal", "orange"), t = 1:2)
#>   teal_01   teal_02 orange_01 orange_02 
#> "#0b3f47" "#2e808e" "#941b00" "#f3631b" 
col_nsw(h = c("teal", "orange"), t = 1:2, byrow = TRUE)
#>   teal_01 orange_01   teal_02 orange_02 
#> "#0b3f47" "#941b00" "#2e808e" "#f3631b" 
```
