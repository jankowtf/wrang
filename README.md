
<!-- README.md is generated from README.Rmd. Please edit that file -->

# wrang

<!-- badges: start -->

[![Lifecycle:
experimental](https://img.shields.io/badge/lifecycle-experimental-orange.svg)](https://lifecycle.r-lib.org/articles/stages.html#experimental)
[![CRAN
status](https://www.r-pkg.org/badges/version/valid)](https://CRAN.R-project.org/package=valid)
<!-- badges: end -->

## Installation

You can install the development version of from
[GitHub](https://github.com/) with:

``` r
# install.packages("remotes")
remotes::install_github("rappster/wrang")
```

## What?

Functionality for programmatic data wrangling that leverages `{dplyr}`
and friends

## Why?

In non-interactive use cases you typically need more programmatic
approaches than hard-coding the input for data wrangling taks
(e.g. column names or functions to be executed)

## How?

``` r
library(wrang)
```

``` r
mtcars %>% wr_summarize(
    carb_sum = sum(carb, na.rm = TRUE),
    carb_mean = mean(carb, na.rm = TRUE)
)
#> # A tibble: 1 × 2
#>   carb_sum carb_mean
#>      <dbl>     <dbl>
#> 1       90      2.81
```

``` r
col_sum <- "carb_sum" %>% dplyr::sym()
col_mean <- "carb_mean" %>% dplyr::sym()
col_src <- "carb" %>% dplyr::sym()

mtcars %>% wr_summarize(
    !!col_sum := sum(!!col_src, na.rm = TRUE),
    !!col_mean := mean(!!col_src, na.rm = TRUE)
)
#> # A tibble: 1 × 2
#>   carb_sum carb_mean
#>      <dbl>     <dbl>
#> 1       90      2.81
```

``` r
foo <- function(
    data,
    col = "carb_sum",
    col_src = "carb",
    fn = purrr::partial(sum, na.rm = TRUE)
) {
    col <- dplyr::enquo(col) %>% handle_nse_input()
    col_src <- dplyr::enquo(col_src) %>% handle_nse_input()

    data %>% wr_summarize(
        !!col := fn(!!col_src)
    )
}
```

``` r
mtcars %>% foo()
#> # A tibble: 1 × 1
#>   carb_sum
#>      <dbl>
#> 1       90
```

``` r
mtcars %>% foo(
    col = "mpg_mean", 
    col_src = "mpg", 
    fn = purrr::partial(mean, na.rm = TRUE)
)
#> # A tibble: 1 × 1
#>   mpg_mean
#>      <dbl>
#> 1     20.1
```

``` r
mtcars %>% foo(
    col = mpg_mean_2, 
    col_src = "mpg", 
    fn = purrr::partial(mean, na.rm = TRUE)
)
#> # A tibble: 1 × 1
#>   mpg_mean_2
#>        <dbl>
#> 1       20.1
```

``` r
mtcars %>% foo(
    col = mpg_mean_2, 
    col_src = mpg, 
    fn = purrr::partial(mean, na.rm = TRUE)
)
#> # A tibble: 1 × 1
#>   mpg_mean_2
#>        <dbl>
#> 1       20.1
```
