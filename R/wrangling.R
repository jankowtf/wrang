#' Frequency table
#'
#' @param data Data
#' @param ... [[symbol], [character]]
#' @param .sort [[logical]] Should results be sorted yes/no
#' @param .col_n_abs [[symbol] or [character]] Column name for absolute count
#' @param .col_n_rel [[symbol] or [character]] Column name for relative count
#'
#' @return
#' @export
#'
#' @examples
#' mtcars %>% wr_freq_table(cyl)
#' mtcars %>% wr_freq_table(cyl, gear, .sort = TRUE)
#'
#' mtcars %>% wr_freq_table(cyl, .col_n_abs = "n",
#'     .col_n_rel = rel, .sort = TRUE)
#'
#' mtcars %>% wr_freq_table(cyl, "gear")
#'
#' cyl_ <- dplyr::quo(cyl)
#' gear_ <- dplyr::sym("gear")
#' mtcars %>% wr_freq_table(!!cyl_, !!gear_)
wr_freq_table <- function(
    data,
    ...,
    .sort = FALSE,
    .col_n_abs = "n_abs",
    .col_n_rel = "n_rel"
) {
    cols <- dplyr::enquos(...) %>%
        purrr::map(~.x %>% handle_nse_input)

    col_n_abs <- dplyr::enquo(.col_n_abs) %>% handle_nse_input()
    col_n_rel <- dplyr::enquo(.col_n_rel) %>% handle_nse_input()

    data %>%
        dplyr::group_by(!!!cols) %>%
        # dplyr::summarise(n = dplyr::n()) %>%
        dplyr::summarise(!!col_n_abs := dplyr::n()) %>%
        # dplyr::mutate(freq = n / sum(n)) %>%
        dplyr::mutate(!!col_n_rel := !!col_n_abs / sum(!!col_n_abs)) %>%
        {
            if (.sort) {
                # dplyr::arrange(., dplyr::desc(n), .by_group = TRUE)
                dplyr::arrange(., dplyr::desc(!!col_n_abs), .by_group = TRUE)
            } else {
                .
            }
        } %>%
        dplyr::ungroup()
}
