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

test_that("Summarize (freq table)", {
    result <- mtcars %>% summa_freq_table()
    expected <- structure(list(n_abs = 32L, n_rel = 1), row.names = c(NA, -1L
    ), class = c("tbl_df", "tbl", "data.frame"))
    expect_identical(result, expected)

    result <- mtcars %>%
        dplyr::group_by(cyl, mpg) %>%
        summa_freq_table()
    expected <- structure(list(cyl = c(4, 4, 4, 4, 4, 4, 4, 4, 4, 6, 6, 6, 6,
        6, 6, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8), mpg = c(21.4, 21.5,
            22.8, 24.4, 26, 27.3, 30.4, 32.4, 33.9, 17.8, 18.1, 19.2, 19.7,
            21, 21.4, 10.4, 13.3, 14.3, 14.7, 15, 15.2, 15.5, 15.8, 16.4,
            17.3, 18.7, 19.2), n_abs = c(1L, 1L, 2L, 1L, 1L, 1L, 2L, 1L,
                1L, 1L, 1L, 1L, 1L, 2L, 1L, 2L, 1L, 1L, 1L, 1L, 2L, 1L, 1L, 1L,
                1L, 1L, 1L), n_rel = c(0.0909090909090909, 0.0909090909090909,
                    0.181818181818182, 0.0909090909090909, 0.0909090909090909, 0.0909090909090909,
                    0.181818181818182, 0.0909090909090909, 0.0909090909090909, 0.142857142857143,
                    0.142857142857143, 0.142857142857143, 0.142857142857143, 0.285714285714286,
                    0.142857142857143, 0.142857142857143, 0.0714285714285714, 0.0714285714285714,
                    0.0714285714285714, 0.0714285714285714, 0.142857142857143, 0.0714285714285714,
                    0.0714285714285714, 0.0714285714285714, 0.0714285714285714, 0.0714285714285714,
                    0.0714285714285714)), class = c("tbl_df", "tbl", "data.frame"
                    ), row.names = c(NA, -27L))
    expect_equal(result, expected)
})
