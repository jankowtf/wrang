# Freq table --------------------------------------------------------------

test_that("Freq table", {
    result <- mtcars %>% wr_freq_table(cyl)
    expected <- structure(list(cyl = c(4, 6, 8), n_abs = c(11L, 7L, 14L), n_rel = c(0.34375,
        0.21875, 0.4375)), row.names = c(NA, -3L), class = c("tbl_df",
            "tbl", "data.frame"))
    expect_identical(result, expected)
})

test_that("Freq table: sorted", {
    result <- mtcars %>% wr_freq_table(cyl, .sort = TRUE)
    expected <- structure(list(cyl = c(8, 4, 6), n_abs = c(14L, 11L, 7L), n_rel = c(0.4375,
        0.34375, 0.21875)), row.names = c(NA, -3L), class = c("tbl_df",
            "tbl", "data.frame"))
    expect_identical(result, expected)
})

test_that("Freq table: different NSE inputs for summarize", {
    result <- mtcars %>% wr_freq_table(cyl, .col_n_abs = "n",
        .col_n_rel = rel, .sort = TRUE)
    expected <- structure(list(cyl = c(8, 4, 6), n = c(14L, 11L, 7L), rel = c(0.4375,
        0.34375, 0.21875)), row.names = c(NA, -3L), class = c("tbl_df",
            "tbl", "data.frame"))
    expect_identical(result, expected)
})

test_that("Freq table: multiple grouping inputs", {
    result <- mtcars %>% wr_freq_table(cyl, gear) %>%
        dplyr::mutate(n_rel = n_rel %>% round(4))
    expected <- structure(list(cyl = c(4, 4, 4, 6, 6, 6, 8, 8), gear = c(3, 4,
        5, 3, 4, 5, 3, 5), n_abs = c(1L, 8L, 2L, 2L, 4L, 1L, 12L, 2L),
        n_rel = c(0.0909, 0.7273, 0.1818, 0.2857, 0.5714, 0.1429,
            0.8571, 0.1429)), row.names = c(NA, -8L), class = c("tbl_df",
                "tbl", "data.frame"))
    expect_identical(result, expected)
})

test_that("Freq table: different NSE inputs for grouping", {
    cyl_ <- dplyr::quo(cyl)
    gear_ <- dplyr::sym("gear")
    result <- mtcars %>% wr_freq_table(!!cyl_, !!gear_) %>%
        dplyr::mutate(n_rel = n_rel %>% round(4))
    expected <- structure(list(cyl = c(4, 4, 4, 6, 6, 6, 8, 8), gear = c(3, 4,
        5, 3, 4, 5, 3, 5), n_abs = c(1L, 8L, 2L, 2L, 4L, 1L, 12L, 2L),
        n_rel = c(0.0909, 0.7273, 0.1818, 0.2857, 0.5714, 0.1429,
            0.8571, 0.1429)), row.names = c(NA, -8L), class = c("tbl_df",
                "tbl", "data.frame"))
    expect_identical(result, expected)
})

test_that("Freq table: different NSE inputs for grouping", {
    result <- mtcars %>% wr_freq_table(cyl, "gear") %>%
        dplyr::mutate(n_rel = n_rel %>% round(4))
    expected <- structure(list(cyl = c(4, 4, 4, 6, 6, 6, 8, 8), gear = c(3, 4,
        5, 3, 4, 5, 3, 5), n_abs = c(1L, 8L, 2L, 2L, 4L, 1L, 12L, 2L),
        n_rel = c(0.0909, 0.7273, 0.1818, 0.2857, 0.5714, 0.1429,
            0.8571, 0.1429)), row.names = c(NA, -8L), class = c("tbl_df",
                "tbl", "data.frame"))
    expect_identical(result, expected)
})

test_that("Digits", {
    result <- mtcars %>% wr_freq_table(cyl, gear, .digits_n_rel = 2)
    expected <- structure(list(cyl = c(4, 4, 4, 6, 6, 6, 8, 8), gear = c(3, 4,
        5, 3, 4, 5, 3, 5), n_abs = c(1L, 8L, 2L, 2L, 4L, 1L, 12L, 2L),
        n_rel = c(0.09, 0.73, 0.18, 0.29, 0.57, 0.14, 0.86, 0.14)), row.names = c(NA,
            -8L), class = c("tbl_df", "tbl", "data.frame"))
    expect_identical(result, expected)

    result <- result %>% dplyr::group_by(cyl) %>%
        dplyr::summarise(rel_total = sum(n_rel))
    expected <- structure(list(cyl = c(4, 6, 8), rel_total = c(1, 1, 1)), class = c("tbl_df",
        "tbl", "data.frame"), row.names = c(NA, -3L))
    expect_equal(result, expected, ignore_attr = TRUE)
})
