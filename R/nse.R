#' Handle NSE input
#'
#' @param x [[character] or [name] or [call]]
#' @param env [[environment]] Caller environment
#'
#' @return
#' @export
#' @examples
#' dplyr::quo("mpg") %>% handle_nse_input()
#' dplyr::quo(mpg) %>% handle_nse_input()
#' col <- "mpg"
#' col %>% handle_nse_input()

#' foo <- function(col, ...) {
#'     dplyr::enquo(col) %>% handle_nse_input(...)
#' }
#'
#' foo(mpg)
#' foo("mpg")
#' col <- "mpg"
#' result <- foo(col)
handle_nse_input <- function(
    x,
    env = rlang::caller_env()
    # ref = character()
) {
    value_quo <- rlang::quo_squash(x)

    if (inherits(value_quo, "character")) {
        value_quo %>% dplyr::sym()
    } else if (inherits(value_quo, "call")) {
        res <- try(rlang::eval_tidy(value_quo, env = env), silent = TRUE)
        if (inherits(res, "try-error")) {
            value_quo[[2]] %>% rlang::eval_tidy(env = env)
        } else {
            res %>% dplyr::sym()
        }
    } else {
        # Previous approach via 'ref'
        # if (missing(ref)) {
        #     return(x)
        # }

        # eval <- (!(value_quo %>% as.character()) %in% ref)
        # if (eval) {
        #     try(rlang::eval_tidy(x, env = env), silent = TRUE) %>%
        #         handle_nse_input(env = env)
        # } else {
        #     x
        # }

        # Current best-shot approach
        # TODO: works, not satisfied yet - still feels too hacky -> check on how
        # to do proper XE (i.e. standard and non-standard execution) the RIGHT
        # way ;-)
        value_tidy <- try(rlang::eval_tidy(x, env = env), silent = TRUE)
        if (inherits(value_tidy, "try-error")) {
            # return(x)
            return(value_quo)
        } else {
            if ((value_quo != value_tidy) && !inherits(value_tidy, "character"))  {
                return(value_tidy)
            } else {
                value_tidy %>%
                    handle_nse_input(env = env)
            }
        }
    }
}
