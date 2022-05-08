#' Handle NSE input
#'
#' @param x
#'
#' @return
handle_nse_input <- function(
    x
) {
    value <- rlang::quo_squash(x)

    if (inherits(value, "character")) {
        value %>% dplyr::sym()
    } else {
        x
    }
}
