#' @keywords internal
ltapi_error <- function(message, status = NULL, call = rlang::caller_env()) {
  structure(
    class = c("ltapi_api_error", "error", "condition"),
    list(message = message, status = status, call = call)
  )
}

#' @keywords internal
ltapi_unavailable_error <- function(message, call = rlang::caller_env()) {
  structure(
    class = c("ltapi_api_unavailable", "ltapi_api_error", "error", "condition"),
    list(message = message, call = call)
  )
}

#' @keywords internal
ltapi_not_found_error <- function(message, call = rlang::caller_env()) {
  structure(
    class = c("ltapi_not_found", "ltapi_api_error", "error", "condition"),
    list(message = message, call = call)
  )
}
