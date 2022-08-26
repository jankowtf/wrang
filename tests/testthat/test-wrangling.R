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
    expected <- structure(list(mpg = c(10.4, 10.4, 13.3, 14.3, 14.7, 15, 15.2,
        15.2, 15.5, 15.8, 16.4, 17.3, 17.8, 18.1, 18.7, 19.2, 19.2, 19.7,
        21, 21, 21.4, 21.4, 21.5, 22.8, 22.8, 24.4, 26, 27.3, 30.4, 30.4,
        32.4, 33.9), cyl = c(8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 6, 6,
            8, 6, 8, 6, 6, 6, 4, 6, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4), disp = c(460,
                472, 350, 360, 440, 301, 275.8, 304, 318, 351, 275.8, 275.8,
                167.6, 225, 360, 167.6, 400, 145, 160, 160, 121, 258, 120.1,
                108, 140.8, 146.7, 120.3, 79, 75.7, 95.1, 78.7, 71.1), hp = c(215,
                    205, 245, 245, 230, 335, 180, 150, 150, 264, 180, 180, 123, 105,
                    175, 123, 175, 175, 110, 110, 109, 110, 97, 93, 95, 62, 91, 66,
                    52, 113, 66, 65), drat = c(3, 2.93, 3.73, 3.21, 3.23, 3.54, 3.07,
                        3.15, 2.76, 4.22, 3.07, 3.07, 3.92, 2.76, 3.15, 3.92, 3.08, 3.62,
                        3.9, 3.9, 4.11, 3.08, 3.7, 3.85, 3.92, 3.69, 4.43, 4.08, 4.93,
                        3.77, 4.08, 4.22), wt = c(5.424, 5.25, 3.84, 3.57, 5.345, 3.57,
                            3.78, 3.435, 3.52, 3.17, 4.07, 3.73, 3.44, 3.46, 3.44, 3.44,
                            3.845, 2.77, 2.62, 2.875, 2.78, 3.215, 2.465, 2.32, 3.15, 3.19,
                            2.14, 1.935, 1.615, 1.513, 2.2, 1.835), qsec = c(17.82, 17.98,
                                15.41, 15.84, 17.42, 14.6, 18, 17.3, 16.87, 14.5, 17.4, 17.6,
                                18.9, 20.22, 17.02, 18.3, 17.05, 15.5, 16.46, 17.02, 18.6, 19.44,
                                20.01, 18.61, 22.9, 20, 16.7, 18.9, 18.52, 16.9, 19.47, 19.9),
        vs = c(0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 0, 1, 0,
            0, 0, 0, 1, 1, 1, 1, 1, 1, 0, 1, 1, 1, 1, 1), am = c(0, 0,
                0, 0, 0, 1, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 1, 1, 1, 1,
                0, 0, 1, 0, 0, 1, 1, 1, 1, 1, 1), gear = c(3, 3, 3, 3, 3,
                    5, 3, 3, 3, 5, 3, 3, 4, 3, 3, 4, 3, 5, 4, 4, 4, 3, 3, 4,
                    4, 4, 5, 4, 4, 5, 4, 4), carb = c(4, 4, 4, 4, 4, 8, 3, 2,
                        2, 4, 3, 3, 4, 1, 2, 4, 2, 6, 4, 4, 2, 1, 1, 1, 2, 2, 2,
                        1, 2, 2, 1, 1), n_abs = c(1L, 1L, 1L, 1L, 1L, 1L, 1L, 1L,
                            1L, 1L, 1L, 1L, 1L, 1L, 1L, 1L, 1L, 1L, 1L, 1L, 1L, 1L, 1L,
                            1L, 1L, 1L, 1L, 1L, 1L, 1L, 1L, 1L), n_rel = c(1, 1, 1, 1,
                                1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1,
                                1, 1, 1, 1, 1, 1, 1, 1, 1)), class = c("tbl_df", "tbl", "data.frame"
                                ), row.names = c(NA, -32L))
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
