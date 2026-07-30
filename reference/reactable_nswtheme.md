# Theme for reactable interactive tables

If using reactable, this helper constructs a theme.

## Usage

``` r
reactable_nswtheme(
  colour = "blue_01",
  text_colour = colour,
  borderColor = colour,
  backgroundColor = "white",
  base_family = "Public Sans",
  title_family = "Public Sans",
  base_text_size = 10,
  stripedColor = NA,
  ...
)
```

## Arguments

- colour:

  starting colour used only to set a common default for other colour
  parameters.

- text_colour:

  colour of all text.

- borderColor:

  colour for the horizontal lines between rows.

- backgroundColor:

  background colour.

- base_family:

  font family for normal text.

- title_family:

  font family for title text.

- base_text_size:

  base text size in pt. The header size is relative to the base text
  size.

- stripedColor:

  fill colour for alternate rows. When `NA`, this is set to a blend of
  `borderColor` and `backgroundColor`.

- ...:

  other parameters to pass to
  [`reactable::reactableTheme()`](https://glin.github.io/reactable/reference/reactableTheme.html).
  For examples of what can be done with reactable, see
  <https://glin.github.io/reactable/articles/cookbook/cookbook.html>.

## Value

A reactable theme object

## Details

Colours can be specified as named NSW colours as in
[`nsw_colours`](https://digitalnsw.github.io/nswtheme/reference/col_nsw.md).

As normal with HTML elements, you must make sure that the final document
loads the necessary fonts. See
[`vignette("nswtheme")`](https://digitalnsw.github.io/nswtheme/articles/nswtheme.md)
for instructions.

## Examples

``` r
library(reactable)

# The default theme
head(palmerpenguins::penguins, 10) |>
  reactable(theme = reactableTheme())

{"x":{"tag":{"name":"Reactable","attribs":{"data":{"species":["Adelie","Adelie","Adelie","Adelie","Adelie","Adelie","Adelie","Adelie","Adelie","Adelie"],"island":["Torgersen","Torgersen","Torgersen","Torgersen","Torgersen","Torgersen","Torgersen","Torgersen","Torgersen","Torgersen"],"bill_length_mm":[39.1,39.5,40.3,"NA",36.7,39.3,38.9,39.2,34.1,42],"bill_depth_mm":[18.7,17.4,18,"NA",19.3,20.6,17.8,19.6,18.1,20.2],"flipper_length_mm":[181,186,195,"NA",193,190,181,195,193,190],"body_mass_g":[3750,3800,3250,"NA",3450,3650,3625,4675,3475,4250],"sex":["male","female","female",null,"female","male","female","male",null,null],"year":[2007,2007,2007,2007,2007,2007,2007,2007,2007,2007]},"columns":[{"id":"species","name":"species","type":"factor"},{"id":"island","name":"island","type":"factor"},{"id":"bill_length_mm","name":"bill_length_mm","type":"numeric"},{"id":"bill_depth_mm","name":"bill_depth_mm","type":"numeric"},{"id":"flipper_length_mm","name":"flipper_length_mm","type":"numeric"},{"id":"body_mass_g","name":"body_mass_g","type":"numeric"},{"id":"sex","name":"sex","type":"factor"},{"id":"year","name":"year","type":"numeric"}],"dataKey":"d09fc92c32ed54493f36a19991012b2e"},"children":[]},"class":"reactR_markup"},"evals":[],"jsHooks":[]}
# Adding nswtheme style
head(palmerpenguins::penguins, 10) |>
  reactable(theme = reactable_nswtheme())

{"x":{"tag":{"name":"Reactable","attribs":{"data":{"species":["Adelie","Adelie","Adelie","Adelie","Adelie","Adelie","Adelie","Adelie","Adelie","Adelie"],"island":["Torgersen","Torgersen","Torgersen","Torgersen","Torgersen","Torgersen","Torgersen","Torgersen","Torgersen","Torgersen"],"bill_length_mm":[39.1,39.5,40.3,"NA",36.7,39.3,38.9,39.2,34.1,42],"bill_depth_mm":[18.7,17.4,18,"NA",19.3,20.6,17.8,19.6,18.1,20.2],"flipper_length_mm":[181,186,195,"NA",193,190,181,195,193,190],"body_mass_g":[3750,3800,3250,"NA",3450,3650,3625,4675,3475,4250],"sex":["male","female","female",null,"female","male","female","male",null,null],"year":[2007,2007,2007,2007,2007,2007,2007,2007,2007,2007]},"columns":[{"id":"species","name":"species","type":"factor"},{"id":"island","name":"island","type":"factor"},{"id":"bill_length_mm","name":"bill_length_mm","type":"numeric"},{"id":"bill_depth_mm","name":"bill_depth_mm","type":"numeric"},{"id":"flipper_length_mm","name":"flipper_length_mm","type":"numeric"},{"id":"body_mass_g","name":"body_mass_g","type":"numeric"},{"id":"sex","name":"sex","type":"factor"},{"id":"year","name":"year","type":"numeric"}],"theme":{"backgroundColor":"white","borderColor":"#002664","stripedColor":"#B2BED0FF","style":{"color":"#002664","fontFamily":"Public Sans","fontSize":"10pt"},"tableStyle":{"fontFamily":"Public Sans","fontSize":"10pt"},"headerStyle":{"fontFamily":"Public Sans","fontSize":"12pt"},"cellStyle":{"fontFamily":"Public Sans","fontSize":"10pt"}},"dataKey":"d09fc92c32ed54493f36a19991012b2e"},"children":[]},"class":"reactR_markup"},"evals":[],"jsHooks":[]}
# More customised styling
head(palmerpenguins::penguins, 10) |>
  reactable(
    theme = reactable_nswtheme(
      colour = "blue_01",
      base_family = "Arial",
      text_colour = "black",
      backgroundColor = NULL
    ),
    striped = TRUE
  )

{"x":{"tag":{"name":"Reactable","attribs":{"data":{"species":["Adelie","Adelie","Adelie","Adelie","Adelie","Adelie","Adelie","Adelie","Adelie","Adelie"],"island":["Torgersen","Torgersen","Torgersen","Torgersen","Torgersen","Torgersen","Torgersen","Torgersen","Torgersen","Torgersen"],"bill_length_mm":[39.1,39.5,40.3,"NA",36.7,39.3,38.9,39.2,34.1,42],"bill_depth_mm":[18.7,17.4,18,"NA",19.3,20.6,17.8,19.6,18.1,20.2],"flipper_length_mm":[181,186,195,"NA",193,190,181,195,193,190],"body_mass_g":[3750,3800,3250,"NA",3450,3650,3625,4675,3475,4250],"sex":["male","female","female",null,"female","male","female","male",null,null],"year":[2007,2007,2007,2007,2007,2007,2007,2007,2007,2007]},"columns":[{"id":"species","name":"species","type":"factor"},{"id":"island","name":"island","type":"factor"},{"id":"bill_length_mm","name":"bill_length_mm","type":"numeric"},{"id":"bill_depth_mm","name":"bill_depth_mm","type":"numeric"},{"id":"flipper_length_mm","name":"flipper_length_mm","type":"numeric"},{"id":"body_mass_g","name":"body_mass_g","type":"numeric"},{"id":"sex","name":"sex","type":"factor"},{"id":"year","name":"year","type":"numeric"}],"striped":true,"theme":{"borderColor":"#002664","stripedColor":[],"style":{"color":"black","fontFamily":"Arial","fontSize":"10pt"},"tableStyle":{"fontFamily":"Arial","fontSize":"10pt"},"headerStyle":{"fontFamily":"Public Sans","fontSize":"12pt"},"cellStyle":{"fontFamily":"Arial","fontSize":"10pt"}},"dataKey":"d09fc92c32ed54493f36a19991012b2e"},"children":[]},"class":"reactR_markup"},"evals":[],"jsHooks":[]}
```
