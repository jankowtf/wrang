#' Frequency table
#'
#' @param data Data
#' @param ... [[symbol], [character]]
#' @param .sort [[logical]] Should results be sorted yes/no
#' @param .col_n_abs [[symbol] or [character]] Column name for absolute count
#' @param .col_n_rel [[symbol] or [character]] Column name for relative count
#' @param .digits_n_rel [[integer]] Number of digits for rounding. `0` means "no
#'   rounding"
#' @param var_dep [[symbol] or [character]]
#' @param .ungroup [[logical]] Ungroup data frame yes/no
#'
#' @return
#' @export
#'
#' @examples
#' mtcars %>% summa_freq_table(cyl)
#' mtcars %>% summa_freq_table(cyl, gear, .sort = TRUE)
#'
#' mtcars %>% summa_freq_table(cyl, .col_n_abs = "n",
#'     .col_n_rel = rel, .sort = TRUE)
#'
#' mtcars %>% summa_freq_table(cyl, "gear")
#'
#' cyl_ <- dplyr::quo(cyl)
#' gear_ <- dplyr::sym("gear")
#' mtcars %>% summa_freq_table(!!cyl_, !!gear_)
#'
#' library(palmerpenguins)
#' penguins %>% summa_freq_table(species, island, var_dep = sex, .digits_n_rel = 2)
#'
#' Check that relative counts add up to `1`
#' penguins %>%
#'     summa_freq_table(species, island, var_dep = sex,
#'         .digits_n_rel = 2, .ungroup = FALSE) %>%
#'     dplyr::summarise(n_rel_total = sum(n_rel)) %>%
#'     dplyr::ungroup()
summa_freq_table <- function(
    data,
    ...,
    .sort = FALSE,
    .col_n_abs = "n_abs",
    .col_n_rel = "n_rel",
    .digits_n_rel = 0,
    .ungroup = TRUE
) {
    cols <- dplyr::enquos(...) %>%
        purrr::map(~.x %>% handle_nse_input)

    col_n_abs <- dplyr::enquo(.col_n_abs) %>% handle_nse_input()
    col_n_rel <- dplyr::enquo(.col_n_rel) %>% handle_nse_input()

    out <- data %>%
        dplyr::group_by(!!!cols) %>%
        dplyr::summarise(!!col_n_abs := dplyr::n()) %>%
        dplyr::mutate(!!col_n_rel := !!col_n_abs / sum(!!col_n_abs)) %>%
        add_count_relative(
            .col_n_abs = .col_n_abs,
            .col_n_rel = .col_n_rel,
            .digits_n_rel = .digits_n_rel,
            .ungroup = FALSE,
            .eval = TRUE
        ) %>%
        {
            if (.sort) {
                dplyr::arrange(., dplyr::desc(!!col_n_abs), .by_group = TRUE)
            } else {
                .
            }
        } %>% {
            if (.ungroup) {
                dplyr::ungroup(.)
            } else {
                .
            }
        } #%>%
        # {
        #     if (.digits_n_rel > 0) {
        #         dplyr::mutate(., !!col_n_rel := !!col_n_rel %>% round(.digits_n_rel))
        #     } else {
        #         .
        #     }
        # }
}

# Add ---------------------------------------------------------------------

add_count_relative <- function(
    data,
    ...,
    .col_n_abs = "n_abs",
    .col_n_rel = "n_rel",
    .digits_n_rel = 0,
    .ungroup = TRUE,
    .eval = FALSE
) {
    grouping_vars_expr <- dplyr::quos(...)

    col_n_abs <- dplyr::enquo(.col_n_abs) %>% handle_nse_input(eval = .eval)
    col_n_rel <- dplyr::enquo(.col_n_rel) %>% handle_nse_input(eval = .eval)

    data %>%
        {
            if(inherits(., "grouped_df")) {
                .
            } else {
                dplyr::group_by(., !!! grouping_vars_expr)
            }
        } %>%
        dplyr::mutate(
            # !!col_n_rel := if (.digits_n_rel > 0) {
            #     ((!! col_n_abs) / sum(!! col_n_abs)) %>% round(.digits_n_rel)
            # } else {
            #     (!! col_n_abs) / sum(!! col_n_abs)
            # }
            !!col_n_rel := (!! col_n_abs) / sum(!! col_n_abs)
        ) %>%
        {
            if (.digits_n_rel > 0) {
                dplyr::mutate(., ((!! col_n_abs) / sum(!! col_n_abs)) %>% round(.digits_n_rel))
            } else {
                .
            }
        } %>%
        {
            if (.ungroup) {
                dplyr::ungroup(.)
            } else {
                .
            }
        }
}
