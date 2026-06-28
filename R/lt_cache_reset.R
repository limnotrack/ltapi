#' Reset the cached PostgREST schema
#'
#' Clears any cached API schema data, forcing the next call to [lt_tables()] or
#' [lt_schema()] to re-fetch from the API.
#'
#' @return Invisibly returns `NULL`.
#' @export
#'
#' @examples
#' \dontrun{
#'   lt_cache_reset()
#' }
lt_cache_reset <- function() {
  keys <- ls(envir = .lt_schema_cache)
  if (length(keys) == 0) {
    cli::cli_inform("Cache is already empty.")
  } else {
    rm(list = keys, envir = .lt_schema_cache)
    cli::cli_inform("Cleared {length(keys)} cached schema{?s}.")
  }
  invisible(NULL)
}
