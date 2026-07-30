
<!-- README.md is generated from README.Rmd. Please edit that file -->

# nswtheme

<!-- badges: start -->

[![R-CMD-check](https://github.com/digitalnsw/nswtheme/actions/workflows/R-CMD-check.yaml/badge.svg)](https://github.com/digitalnsw/nswtheme/actions/workflows/R-CMD-check.yaml)
<!-- badges: end -->

The goal of `nswtheme` is to provide a R tool kit for styles, patterns
and standards following the [Digital NSW, NSW Design
System](https://github.com/digitalnsw/nsw-design-system)

## Installation

You can install nswtheme like so:

``` r
# CRAN release (not yet!)
# install.packages('nswtheme')

# development version
install.packages('pak')
pak::pak('digitalnsw/nswtheme')
```

## Usage

In many instances it may be sufficient to set the global theme:

``` r
library(ggplot2)
library(nswtheme)

set_theme(theme_nsw())

ggplot(mpg, aes(displ, hwy, colour = class)) +
  geom_point()
```

<img src="man/figures/README-unnamed-chunk-2-1.png" alt="" width="100%" />

More control is available through palette functions such as
`pal_waratah()`. See `vignette("nswtheme")` for usage guidelines.
