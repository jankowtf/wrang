
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

Functionality for programmatic data wrangling based on
[{dplyr}](https://github.com/tidyverse/dplyr),
[{rlang}](https://github.com/r-lib/rlang) and friends

## Why?

In non-interactive use cases you typically need more programmatic
approaches than hard-coding certain input for data wrangling tasks -
e.g. column names or functions to be executed.

This package tries to come up with some out-of-the-box helpers for that.

### DISCLAIMER

It’s one of those scratch-your-own-itch things where the code base might
change as flesh my ideas out.

## How?

``` r
library(wrang)
```

## Frequency table

``` r
mtcars %>% summa_freq_table(cyl)
#> # A tibble: 3 × 3
#>     cyl n_abs n_rel
#>   <dbl> <int> <dbl>
#> 1     4    11 0.344
#> 2     6     7 0.219
#> 3     8    14 0.438
mtcars %>% summa_freq_table(cyl, gear, .sort = TRUE)
#> # A tibble: 8 × 4
#>     cyl  gear n_abs  n_rel
#>   <dbl> <dbl> <int>  <dbl>
#> 1     4     4     8 0.727 
#> 2     4     5     2 0.182 
#> 3     4     3     1 0.0909
#> 4     6     4     4 0.571 
#> 5     6     3     2 0.286 
#> 6     6     5     1 0.143 
#> 7     8     3    12 0.857 
#> 8     8     5     2 0.143

mtcars %>% summa_freq_table(cyl, .col_n_abs = "n",
    .col_n_rel = rel, .sort = TRUE)
#> # A tibble: 3 × 3
#>     cyl     n   rel
#>   <dbl> <int> <dbl>
#> 1     8    14 0.438
#> 2     4    11 0.344
#> 3     6     7 0.219

mtcars %>% summa_freq_table(cyl, "gear")
#> # A tibble: 8 × 4
#>     cyl  gear n_abs  n_rel
#>   <dbl> <dbl> <int>  <dbl>
#> 1     4     3     1 0.0909
#> 2     4     4     8 0.727 
#> 3     4     5     2 0.182 
#> 4     6     3     2 0.286 
#> 5     6     4     4 0.571 
#> 6     6     5     1 0.143 
#> 7     8     3    12 0.857 
#> 8     8     5     2 0.143

cyl_ <- dplyr::quo(cyl)
gear_ <- dplyr::sym("gear")
mtcars %>% summa_freq_table(!!cyl_, !!gear_)
#> # A tibble: 8 × 4
#>     cyl  gear n_abs  n_rel
#>   <dbl> <dbl> <int>  <dbl>
#> 1     4     3     1 0.0909
#> 2     4     4     8 0.727 
#> 3     4     5     2 0.182 
#> 4     6     3     2 0.286 
#> 5     6     4     4 0.571 
#> 6     6     5     1 0.143 
#> 7     8     3    12 0.857 
#> 8     8     5     2 0.143
```

With specifying an “dependend variable” (not satisfied with the name
yet, likely to change)

``` r
# install.packages("palmerpenguins")
library(palmerpenguins)

penguins %>% summa_freq_table(species, island, sex, .digits_n_rel = 2)
#> # A tibble: 13 × 5
#>    species   island    sex    n_abs  n_rel
#>    <fct>     <fct>     <fct>  <int>  <dbl>
#>  1 Adelie    Biscoe    female    22 0.5   
#>  2 Adelie    Biscoe    male      22 0.5   
#>  3 Adelie    Dream     female    27 0.482 
#>  4 Adelie    Dream     male      28 0.5   
#>  5 Adelie    Dream     <NA>       1 0.0179
#>  6 Adelie    Torgersen female    24 0.462 
#>  7 Adelie    Torgersen male      23 0.442 
#>  8 Adelie    Torgersen <NA>       5 0.0962
#>  9 Chinstrap Dream     female    34 0.5   
#> 10 Chinstrap Dream     male      34 0.5   
#> 11 Gentoo    Biscoe    female    58 0.468 
#> 12 Gentoo    Biscoe    male      61 0.492 
#> 13 Gentoo    Biscoe    <NA>       5 0.0403
```

Check that relative counts add up to `1`

``` r
penguins %>% 
    summa_freq_table(species, island, sex, 
        .digits_n_rel = 2, .ungroup = FALSE) %>%
    dplyr::summarise(n_rel_total = sum(n_rel)) %>% 
    dplyr::ungroup()
#> `summarise()` has grouped output by 'species'. You can override using the
#> `.groups` argument.
#> # A tibble: 5 × 3
#>   species   island    n_rel_total
#>   <fct>     <fct>           <dbl>
#> 1 Adelie    Biscoe              1
#> 2 Adelie    Dream               1
#> 3 Adelie    Torgersen           1
#> 4 Chinstrap Dream               1
#> 5 Gentoo    Biscoe              1
```

## Handling NSE input

``` r
foo <- function(
    data,
    col = "carb_sum",
    col_src = "carb",
    fn = purrr::partial(sum, na.rm = TRUE)
) {
    col <- dplyr::enquo(col) %>% handle_nse_input()
    col_src <- dplyr::enquo(col_src) %>% handle_nse_input()
    
    data %>% dplyr::summarize(
        !!col := fn(!!col_src)
    )
}
```

``` r
mtcars %>% foo()
#>   carb_sum
#> 1       90
```

``` r
mtcars %>% foo(
    col = "mpg_mean", 
    col_src = "mpg", 
    fn = purrr::partial(mean, na.rm = TRUE)
)
#>   mpg_mean
#> 1 20.09062
```

``` r
mtcars %>% foo(
    col = mpg_mean_2, 
    col_src = "mpg", 
    fn = purrr::partial(mean, na.rm = TRUE)
)
#>   mpg_mean_2
#> 1   20.09062
```

``` r
mtcars %>% foo(
    col = mpg_mean_2, 
    col_src = mpg, 
    fn = purrr::partial(mean, na.rm = TRUE)
)
#>   mpg_mean_2
#> 1   20.09062
```

## Other

``` r
mtcars %>% dplyr::summarize(
    carb_sum = sum(carb, na.rm = TRUE),
    carb_mean = mean(carb, na.rm = TRUE)
)
#>   carb_sum carb_mean
#> 1       90    2.8125
```

``` r
col_sum <- "carb_sum" %>% dplyr::sym()
col_mean <- "carb_mean" %>% dplyr::sym()
col_src <- "carb" %>% dplyr::sym()

mtcars %>% dplyr::summarize(
    !!col_sum := sum(!!col_src, na.rm = TRUE),
    !!col_mean := mean(!!col_src, na.rm = TRUE)
)
#>   carb_sum carb_mean
#> 1       90    2.8125
```
