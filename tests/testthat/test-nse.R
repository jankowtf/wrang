test_that("Handle NSE input: chr", {
    result <- dplyr::quo("mpg") %>% handle_nse_input()
    expected <- dplyr::sym("mpg")
    expect_identical(result, expected)
})

test_that("Handle NSE input: quo", {
    result <- dplyr::quo(mpg) %>% handle_nse_input()
    expected <- dplyr::sym("mpg")
    expect_identical(result, expected)
})

test_that("Handle NSE input: var", {
    col <- "mpg"
    result <- col %>% handle_nse_input()
    expected <- dplyr::sym("mpg")
    expect_identical(result, expected)
})

test_that("Handle NSE input: within function", {
    foo <- function(col, ...) {
        dplyr::enquo(col) %>% handle_nse_input(...)
    }

    result <- foo(mpg)
    expected <- dplyr::sym("mpg")
    expect_identical(result, expected)

    result <- foo("mpg")
    expected <- dplyr::sym("mpg")
    expect_identical(result, expected)

    col <- "mpg"
    result <- foo(col)
    expected <- dplyr::sym("mpg")
    expect_identical(result, expected)
})
