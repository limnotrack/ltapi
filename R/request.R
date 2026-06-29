#' @keywords internal
#' @importFrom httr2 req_perform req_error resp_status resp_is_error resp_status_desc
#' @importFrom cli cli_abort
#' @importFrom rlang caller_env
perform_request <- function(req, call = rlang::caller_env()) {
  tryCatch(
    req |>
      httr2::req_error(is_error = \(r) FALSE) |>
      httr2::req_perform(),
    httr2_failure = \(e) {
      cli::cli_abort(
        "The LimnoTrack API is unreachable. Please check your connection or try again later.",
        class = "ltapi_api_unavailable",
        call = call
      )
    },
    error = \(e) {
      cli::cli_abort(
        "Unexpected error during request: {conditionMessage(e)}",
        class = "ltapi_api_error",
        call = call
      )
    }
  ) |>
    check_response(call = call)
}

#' @keywords internal
#' @importFrom httr2 resp_status resp_is_error resp_status_desc
#' @importFrom cli cli_abort
#' @importFrom rlang caller_env
check_response <- function(resp, call = rlang::caller_env()) {
  status <- httr2::resp_status(resp)

  if (status %in% c(502L, 503L, 504L)) {
    cli::cli_abort(
      "LimnoTrack API is currently unavailable (HTTP {status}). Try again later.",
      class = "ltapi_api_unavailable",
      call = call
    )
  }

  if (httr2::resp_is_error(resp)) {
    cli::cli_abort(
      c(
        "API request failed with HTTP {status}.",
        "x" = "{httr2::resp_status_desc(resp)}"
      ),
      class = "ltapi_api_error",
      status = status,
      call = call
    )
  }

  resp
}
