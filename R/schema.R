#' Get (and cache) the OpenAPI spec
#' @keywords internal
get_spec <- function(base_url, call = rlang::caller_env()) {
  cache_key <- paste0(base_url, ":spec")
  if (!exists(cache_key, envir = .lt_schema_cache)) {
    req <- httr2::request(base_url) |>
      httr2::req_headers(Accept = "application/openapi+json")
    resp <- perform_request(req, call = call)
    assign(cache_key, httr2::resp_body_json(resp), envir = .lt_schema_cache)
  }
  get(cache_key, envir = .lt_schema_cache)
}
