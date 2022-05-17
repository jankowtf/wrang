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
#'
#' library(palmerpenguins)
#' penguins %>% wr_freq_table(species, island, var_dep = sex, .digits_n_rel = 2)
#'
#' Check that relative counts add up to `1`
#' penguins %>%
#'     wr_freq_table(species, island, var_dep = sex,
#'         .digits_n_rel = 2, .ungroup = FALSE) %>%
#'     dplyr::summarise(n_rel_total = sum(n_rel)) %>%
#'     dplyr::ungroup()
wr_freq_table <- function(
    data,
    ...,
    var_dep = character(),
    .sort = FALSE,
    .col_n_abs = "n_abs",
    .col_n_rel = "n_rel",
    .digits_n_rel = 0,
    .ungroup = TRUE
) {
    cols <- dplyr::enquos(...) %>%
        purrr::map(~.x %>% handle_nse_input)
    col_var_dep <- dplyr::enquo(var_dep)
    var_dep_missing <- missing(var_dep)

    col_n_abs <- dplyr::enquo(.col_n_abs) %>% handle_nse_input()
    col_n_rel <- dplyr::enquo(.col_n_rel) %>% handle_nse_input()

    data %>%
        dplyr::group_by(!!!cols) %>% {
            if (!var_dep_missing) {
                dplyr::count(., !!col_var_dep) %>%
                    dplyr::rename(!!col_n_abs := n)
            } else {
                dplyr::summarise(., !!col_n_abs := dplyr::n())
            }
        } %>%
        dplyr::mutate(!!col_n_rel := !!col_n_abs / sum(!!col_n_abs)) %>% {
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
        } %>% {
            if (.digits_n_rel > 0) {
                dplyr::mutate(., !!col_n_rel := !!col_n_rel %>% round(.digits_n_rel))
            } else {
                .
            }
        }
}
