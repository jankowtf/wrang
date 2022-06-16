# Default -----------------------------------------------------------------

test_that("Round: name", {
    result <- tibble::tribble(
        ~a, ~b, ~c,
        "a", 1.123, 0.12345,
        "b", 1.567, 0.567
    ) %>% format_round(b, c)

    expected <- structure(list(a = c("a", "b"), b = c(1, 2), c = c(0, 1)), row.names = c(NA,
        -2L), class = c("tbl_df", "tbl", "data.frame"))
    expect_identical(result, expected)
})

test_that("Round: chr", {
    result <- tibble::tribble(
        ~a, ~b, ~c,
        "a", 1.123, 0.12345,
        "b", 1.567, 0.567
    ) %>% format_round("b", "c")

    expected <- structure(list(a = c("a", "b"), b = c(1, 2), c = c(0, 1)), row.names = c(NA,
        -2L), class = c("tbl_df", "tbl", "data.frame"))
    expect_identical(result, expected)
})

test_that("Round: var", {
    col_1 <- "b"
    col_2 <- "c"
    result <- tibble::tribble(
        ~a, ~b, ~c,
        "a", 1.123, 0.12345,
        "b", 1.567, 0.567
    ) %>% format_round(col_1, col_2)

    expected <- structure(list(a = c("a", "b"), b = c(1, 2), c = c(0, 1)), row.names = c(NA,
        -2L), class = c("tbl_df", "tbl", "data.frame"))
    expect_identical(result, expected)
})

# Digits ------------------------------------------------------------------

test_that("Round: name: digits", {
    result <- tibble::tribble(
        ~a, ~b, ~c,
        "a", 1.123, 0.12345,
        "b", 1.567, 0.567
    ) %>% format_round(b, c, .digits = 2)

    expected <- structure(list(a = c("a", "b"), b = c(1.12, 1.57), c = c(0.12,
        0.57)), row.names = c(NA, -2L), class = c("tbl_df", "tbl", "data.frame"
        ))
    expect_identical(result, expected)
})

test_that("Round: chr: digits", {
    result <- tibble::tribble(
        ~a, ~b, ~c,
        "a", 1.123, 0.12345,
        "b", 1.567, 0.567
    ) %>% format_round("b", "c", .digits = 2)

    expected <- structure(list(a = c("a", "b"), b = c(1.12, 1.57), c = c(0.12,
        0.57)), row.names = c(NA, -2L), class = c("tbl_df", "tbl", "data.frame"
        ))
    expect_identical(result, expected)
})

test_that("Round: var: digits", {
    col_1 <- "b"
    col_2 <- "c"
    result <- tibble::tribble(
        ~a, ~b, ~c,
        "a", 1.123, 0.12345,
        "b", 1.567, 0.567
    ) %>% format_round(col_1, col_2, .digits = 2)

    expected <- structure(list(a = c("a", "b"), b = c(1.12, 1.57), c = c(0.12,
        0.57)), row.names = c(NA, -2L), class = c("tbl_df", "tbl", "data.frame"
        ))
    expect_identical(result, expected)
})
