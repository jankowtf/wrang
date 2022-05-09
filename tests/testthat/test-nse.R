test_that("Handle NSE input: quosure", {
    result <- dplyr::quo(mpg) %>% handle_nse_input()
    expected <- dplyr::quo(mpg)
    expect_identical(result, expected)
})

test_that("Handle NSE input: character", {
    result <- dplyr::quo("mpg") %>% handle_nse_input()
    expected <- dplyr::sym("mpg")
    expect_identical(result, expected)
})

test_that("Handle NSE input: within function", {
    foo <- function(col) {
        dplyr::enquo(col) %>% handle_nse_input()
    }

    result <- foo(mpg)
    expected <- dplyr::quo(mpg)
    expect_identical(result, expected)

    result <- foo("mpg")
    expected <- dplyr::sym("mpg")
    expect_identical(result, expected)
})
