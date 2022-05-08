#' Summarize
#'
#' @param .data
#' @param ...
#' @param .groups
#'
#' @return
#' @export
#'
#' @examples
#' mtcars %>% wr_summarize(
#'     carb_sum = sum(carb, na.rm = TRUE),
#'     carb_mean = mean(carb, na.rm = TRUE)
#' )
wr_summarize <- function(
    .data,
    ...,
    .groups = NULL
) {
    dots <- rlang::enquos(...)
    dplyr::summarize(
        .data = .data,
        # ...,
        !!!dots,
        .groups = .groups
    ) %>%
        tibble::as_tibble()
}
