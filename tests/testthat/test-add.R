# Add relative count ------------------------------------------------------

test_that("Add relative count: chr", {
    result <- tibble::tibble(abs = 1:10) %>%
        add_count_relative(.col_abs = "abs", .col_rel = "rel",
            .round = TRUE, .digits = 2)

    expected <- structure(list(abs = 1:10, rel = c(0.02, 0.04, 0.05, 0.07, 0.09,
        0.11, 0.13, 0.15, 0.16, 0.18)), row.names = c(NA, -10L), class = c("tbl_df",
            "tbl", "data.frame"))
    expect_identical(result, expected)
})

test_that("Add relative count: name", {
    result <- tibble::tibble(abs = 1:10) %>%
        add_count_relative(.col_abs = "abs", .col_rel = rel,
            .round = TRUE, .digits = 2)

    expected <- structure(list(abs = 1:10, rel = c(0.02, 0.04, 0.05, 0.07, 0.09,
        0.11, 0.13, 0.15, 0.16, 0.18)), row.names = c(NA, -10L), class = c("tbl_df",
            "tbl", "data.frame"))
    expect_identical(result, expected)
})


test_that("Prototyping", {
    skip("Troubleshooting <> prototyping")
    foo <- function(data, col, .col_abs = "n_abs", .col_rel = "n_rel") {
        # col_ <- dplyr::enquo(col) %>% handle_nse_input()

        # data %>%
        #     dplyr::mutate(
        #         !!col_ := 1
        #     )

        # data %>%
        #     bar(col = col_)

        browser()
        col_abs <- dplyr::enquo(.col_abs) %>% handle_nse_input(ref = "n_abs")
        col_rel <- dplyr::enquo(.col_rel) %>% handle_nse_input(ref = "n_rel")
        # col_rel <- dplyr::enquo(.col_rel) %>% handle_nse_input()

        data %>%
            dplyr::mutate(
                !!col_rel := (!! col_abs) / sum(!! col_abs)
            )

    }

    bar <- function(data, col) {
        col_ <- dplyr::enquo(col) %>% handle_nse_input()

        data %>%
            dplyr::mutate(
                !!col_ := 1
            )

    }

    mtcars %>% foo(test)
    mtcars %>% bar(test)

    tibble::tibble(abs = 1:3) %>% foo(.col_abs = "abs", .col_rel = rel)
})
