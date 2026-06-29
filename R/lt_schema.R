#' Inspect the schema for a table in the LimnoTrack database
#'
#' @param table character; table name
#' @param base_url character; base URL of the PostgREST API. Defaults to
#'   `"https://api.limnotrack.com/postgrest"`.
#' @return A tibble with columns: `column`, `type`, `format`, and `description`.
#' @importFrom tibble tibble
#' @importFrom cli cli_abort
#' @export
#'
#' @examples
#' \dontrun{
#'   lt_schema("my_table")
#' }
#'
#' @section Errors:
#' \describe{
#'   \item{`ltapi_api_unavailable`}{The API could not be reached, or returned a 502/503/504.}
#'   \item{`ltapi_api_error`}{The API returned an unexpected HTTP error.}
#'   \item{`ltapi_not_found`}{The requested table does not exist in the schema.}
#' }
lt_schema <- function(table, base_url = "https://api.limnotrack.com/postgrest") {
  spec  <- get_spec(base_url)
  props <- spec$definitions[[table]]$properties

  if (is.null(props)) {
    cli::cli_abort(
      c("Table {.val {table}} not found.",
        "i" = "Use {.run ltapi::lt_tables()} to see available tables."),
      class = "ltapi_not_found"
    )
  }

  tibble::tibble(
    column      = names(props),
    type        = vapply(props, \(p) p$type        %||% NA_character_, character(1)),
    format      = vapply(props, \(p) p$format      %||% NA_character_, character(1)),
    description = vapply(props, \(p) p$description %||% NA_character_, character(1))
  )
}
