foo <- function(
    data,
    col = "carb_sum",
    col_src = "carb",
    fn = purrr::partial(sum, na.rm = TRUE)
) {
    col <- col %>% dplyr::sym()
    col_src <- col_src %>% dplyr::sym()

    data %>%
        tibble::as_tibble() %>%
        dplyr::summarize(
            !!col := fn(!!col_src)
        )
}

bar <- function(
    data,
    col = "carb_sum",
    col_src = "carb",
    fn = purrr::partial(sum, na.rm = TRUE)
) {
    col <- dplyr::enquo(col) %>% handle_nse_input()
    col_src <- dplyr::enquo(col_src) %>% handle_nse_input()

    data %>%
        tibble::as_tibble() %>%
        dplyr::summarize(
            !!col := fn(!!col_src)
        )
}

test_that("Summarize", {
    result <- mtcars %>% tibble::as_tibble() %>%
        dplyr::summarize(
            carb_sum = sum(carb, na.rm = TRUE),
            carb_mean = mean(carb, na.rm = TRUE)
        )
    expected <- structure(list(carb_sum = 90, carb_mean = 2.8125), class = c("tbl_df",
        "tbl", "data.frame"), row.names = c(NA, -1L))
    expect_identical(result, expected)
})

test_that("Summarize NSE", {
    col_sum <- "carb_sum" %>% dplyr::sym()
    col_mean <- "carb_mean" %>% dplyr::sym()
    col_src <- "carb" %>% dplyr::sym()

    result <- mtcars %>%
        tibble::as_tibble() %>%
        dplyr::summarize(
            !!col_sum := sum(!!col_src, na.rm = TRUE),
            !!col_mean := mean(!!col_src, na.rm = TRUE)
        )
    expected <- structure(list(carb_sum = 90, carb_mean = 2.8125), class = c("tbl_df",
        "tbl", "data.frame"), row.names = c(NA, -1L))
    expect_identical(result, expected)
})

test_that("Summarize NSE (2)", {
    result <- mtcars %>% foo()
    expected <- structure(list(carb_sum = 90), class = c("tbl_df",
        "tbl", "data.frame"), row.names = c(NA, -1L))
    expect_identical(result, expected)

    result <- mtcars %>% foo(fn = mean)
    expected <- structure(list(carb_sum = 2.8125), class = c("tbl_df", "tbl",
        "data.frame"), row.names = c(NA, -1L))
    expect_identical(result, expected)

    result <- mtcars %>% foo(fn = purrr::partial(mean, na.rm = TRUE))
    expected <- structure(list(carb_sum = 2.8125), class = c("tbl_df", "tbl",
        "data.frame"), row.names = c(NA, -1L))
    expect_identical(result, expected)
})

test_that("Summarize NSE (3)", {
    result <- mtcars %>% bar()
    expected <- structure(list(carb_sum = 90), class = c("tbl_df",
        "tbl", "data.frame"), row.names = c(NA, -1L))
    expect_identical(result, expected)
})

test_that("Summarize NSE (4)", {
    result <- mtcars %>% bar(col = carb_test)
    expected <- structure(list(carb_test = 90), class = c("tbl_df",
        "tbl", "data.frame"), row.names = c(NA, -1L))
    expect_identical(result, expected)
})

test_that("Summarize NSE (5)", {
    result <- mtcars %>% bar(col = "carb_test")
    expected <- structure(list(carb_test = 90), class = c("tbl_df",
        "tbl", "data.frame"), row.names = c(NA, -1L))
    expect_identical(result, expected)
})

