#' List available tables from the LimnoTrack API
#'
#' Retrieves and caches the OpenAPI schema from the LimnoTrack PostgREST API,
#' returning the names of all available tables.
#'
#' @param base_url Base URL for the LimnoTrack PostgREST API. Defaults to
#'   `"https://api.limnotrack.com/postgrest"`.
#'
#' @return A sorted character vector of table names.
#' @export
#'
#' @examples
#' \dontrun{
#'   lt_tables()
#' }
#'
#' @section Errors:
#' \describe{
#'   \item{`ltapi_api_unavailable`}{The API could not be reached, or returned a 502/503/504.}
#'   \item{`ltapi_api_error`}{The API returned an unexpected HTTP error.}
#' }
lt_tables <- function(base_url = "https://api.limnotrack.com/postgrest") {
  spec <- get_spec(base_url)
  sort(names(spec$definitions))
}
