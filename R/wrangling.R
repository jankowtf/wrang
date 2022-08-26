#' Frequency table
#'
#' @param data [[tibble]] Data
#' @param ... [[name], [character] or [symbol]] Column names
#' @param .sort [[logical]] Should results be sorted yes/no
#' @param .col_n_abs [[symbol] or [character]] Column name for absolute count
#' @param .col_n_rel [[symbol] or [character]] Column name for relative count
#' @param .round_n_rel [[logical]] Round `n_rel` yes/no
#' @param .digits_n_rel [[integer]] Number of digits for rounding
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
#' # Check that relative counts add up to `1`
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
    .round_n_rel = FALSE,
    .digits_n_rel = 0,
    .ungroup = TRUE
) {
    cols <- dplyr::enquos(...) %>%
        purrr::map(~.x %>% handle_nse_input)

    if (!length(cols)) {
        cols <- data %>% dplyr::group_vars() %>%
            purrr::map(~.x %>% handle_nse_input)
    }

    col_n_abs <- dplyr::enquo(.col_n_abs) %>% handle_nse_input()
    col_n_rel <- dplyr::enquo(.col_n_rel) %>% handle_nse_input()

    data %>%
        dplyr::group_by(!!!cols) %>%
        dplyr::summarise(!!col_n_abs := dplyr::n()) %>%
        dplyr::mutate(!!col_n_rel := !!col_n_abs / sum(!!col_n_abs)) %>%
        add_count_relative(
            .col_abs = col_n_abs,
            .col_rel = col_n_rel,
            .round = .round_n_rel,
            .digits = .digits_n_rel,
            .ungroup = FALSE
        ) %>%
        {
            if (.sort) {
                dplyr::arrange(., dplyr::desc(!!col_n_abs), .by_group = TRUE)
            } else {
                .
            }
        } %>%
        struc_ungroup(exec = .ungroup)
}

# Add ---------------------------------------------------------------------

#' Add: relative count
#'
#' @param data [[tibble]] Data
#' @param ... [[name], [character] or [symbol]] Column names
#' @param .col_abs [[name], [character] or [symbol]] Column name for column with
#'   absolute counts
#' @param .col_rel [[name], [character] or [symbol]] Column name for column with
#'   relative counts
#' @param .round [[logical]] Round relative count yes/no
#' @param .digits [[integer]] Number of digits when rounding relative count
#' @param .ungroup [[logical]] Ungroup data before returning it
#'
#' @return
#' @export
#'
#' @examples
#' tibble::tibble(abs = 1:10) %>%
#'     add_count_relative(.col_abs = "abs", .col_rel = "rel",
#'         .round = TRUE, .digits = 2)
add_count_relative <- function(
    data,
    ...,
    .col_abs = "n_abs",
    .col_rel = "n_rel",
    .round = FALSE,
    .digits = 2,
    .ungroup = TRUE
) {
    grouping_vars_expr <- dplyr::quos(...)

    col_abs <- dplyr::enquo(.col_abs) %>% handle_nse_input()
    col_rel <- dplyr::enquo(.col_rel) %>% handle_nse_input()

    data %>%
        {
            if(inherits(., "grouped_df")) {
                .
            } else {
                dplyr::group_by(., !!! grouping_vars_expr)
            }
        } %>%
        dplyr::mutate(
            !!col_rel := (!! col_abs) / sum(!! col_abs)
        ) %>%
        format_round(col_rel, .exec = .round, .digits = .digits) %>%
        struc_ungroup(exec = .ungroup)
}

# Format ------------------------------------------------------------------

#' Format: round
#'
#' Functional programming wrapper around `[dplyr::mutate].
#'
#' @param data [[tibble]]
#' @param ... [[name], [symbol] or [character]] NSE-flexible column name
#' @param .exec [[logical]] Execute functionality yes/no
#' @param .digits [[integer]] Number of digits for rounding
#'
#' @return
#' @export
#'
#' @examples
#' tibble::tribble(
#'     ~a, ~b, ~c,
#'     "a", 1.123, 0.12345,
#'     "b", 1.567, 0.567
#' ) %>% format_round(b, c, .digits = 2)
format_round <- function(
    data,
    ...,
    .exec = TRUE,
    .digits = 0
) {
    # Early exit
    if (!.exec) {
        return(data)
    }

    vars_expr <- dplyr::quos(...)

    # Account for NSE case "column names via variable"
    is_all_of <- vars_expr %>%
        purrr::map_lgl(~.x %>% rlang::quo_squash() %>% is.character()) %>%
        all()

    data %>%
        {
            if (is_all_of) {
                dplyr::mutate(
                    .,
                    dplyr::across(
                        .cols = dplyr::all_of(c(!!!vars_expr)),
                        .fns = ~round(.x, digits = .digits)
                    )
                )
            } else {
                dplyr::mutate(
                    .,
                    dplyr::across(
                        .cols = c(!!!vars_expr),
                        .fns = ~round(.x, digits = .digits)
                    )
                )
            }
        }
}

# Structure ---------------------------------------------------------------

#' Structure: ungroup
#'
#' Functional programming wrapper around [dplyr::ungroup]..
#'
#' @param data [[tibble]] Data
#' @param exec [[logical]] Execute inner functionality yes/no
#'
#' @return
#' @export
#'
#' @examples
#' mtcars %>%
#'     dplyr::group_by(cyl) %>%
#'     struc_ungroup(TRUE)
#'
#' mtcars %>%
#'     dplyr::group_by(cyl) %>%
#'     struc_ungroup(FALSE)
struc_ungroup <- function(
    data,
    exec
) {
    data %>%
        {
            if (exec) {
                dplyr::ungroup(.)
            } else {
                .
            }
        }
}


