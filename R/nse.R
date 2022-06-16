#' Handle NSE input
#'
#' @param x [[character] or [name] or [call]]
#' @param env [[environment]] Caller environment
#' @param eval
#'
#' @return
handle_nse_input <- function(
    x,
    env = rlang::caller_env(),
    eval = FALSE
) {
    value <- rlang::quo_squash(x)

    if (inherits(value, "character")) {
        value %>% dplyr::sym()
    } else if (inherits(value, "call")) {
        res <- try(rlang::eval_tidy(value, env = env), silent = TRUE)
        if (inherits(res, "try-error")) {
            value[[2]] %>% rlang::eval_tidy(env = env)
        } else {
            res %>% dplyr::sym()
        }
    } else {
        if (eval) {
            try(rlang::eval_tidy(x, env = env), silent = TRUE) %>%
                handle_nse_input(env = env)
        } else {
            x
        }
    }
}
