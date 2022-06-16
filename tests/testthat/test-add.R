test_that("add relative count", {
    result <- mtcars %>%
        summa_freq_table(cyl, gear, .ungroup = FALSE) %>%
        add_count_relative(.col_n_rel = "horst", .digits_n_rel = 2) %>%
        dplyr::summarize(n_rel_total = sum(horst))

    mtcars %>%
        summa_freq_table(cyl, gear, .ungroup = FALSE) %>%
        add_count_relative(.col_n_rel = "horst")
})
