#' Query LimnoTrack database with flexible parameters
#'
#' Query any table in the LimnoTrack database with optional parameters for
#' selecting columns, filtering rows, ordering results, and pagination.
#' Automatically detects geometry columns and returns an [sf::sf] object if
#' present, or a [tibble::tibble] otherwise.
#'
#' @param table character; name of the table to query (e.g., `"lake_contours"`).
#' @param select character; comma-separated column names to select
#'   (e.g., `"col1,col2"`). If `NULL`, all columns are returned.
#' @param filter named list of PostgREST filter expressions, typically built
#'   with [lt_filter()] (e.g., `lt_filter(lernzmp_id == "LID40188")`).
#' @param order character; column ordering (e.g., `"col1.asc,col2.desc"`).
#' @param limit integer; maximum number of records to return. Default `1000`.
#' @param offset integer; number of records to skip for pagination. Default `0`.
#' @param base_url character; base URL of the LimnoTrack PostgREST API.
#'
#' @return A [tibble::tibble], or an [sf::sf] object if the table contains
#'   geometry data.
#' @export
#' @importFrom httr2 request req_url_path_append req_headers req_url_query
#' @importFrom httr2 resp_body_json resp_body_string
#'
#'
#' @examples
#' \dontrun{
#'   lt_fetch(
#'     table  = "lake_contours",
#'     filter = lt_filter(lernzmp_id == "LID40188")
#'   )
#' }
#'
#' @section Errors:
#' \describe{
#'   \item{`ltapi_api_unavailable`}{The API could not be reached, or returned a 502/503/504.}
#'   \item{`ltapi_api_error`}{The API returned an unexpected HTTP error.}
#' }
lt_fetch <- function(
    table,
    select   = NULL,
    filter   = NULL,
    order    = NULL,
    limit    = 1000L,
    offset   = 0L,
    base_url = "https://api.limnotrack.com/postgrest"
) {
  geom_info <- lt_detect_geom(table, base_url)
  has_geom  <- !is.null(geom_info)

  if (!is.null(select) && has_geom && !geom_info$col %in% select) {
    select <- c(select, geom_info$col)
  }

  req <- httr2::request(base_url) |>
    httr2::req_url_path_append(table) |>
    httr2::req_headers(Accept = if (has_geom) "application/geo+json" else "application/json") |>
    httr2::req_url_query(
      limit  = limit,
      offset = offset,
      select = select,
      order  = order,
      !!!filter,
      .multi = "comma"
    )

  resp <- perform_request(req)

  if (has_geom) {
    sf_obj <- geojsonsf::geojson_sf(httr2::resp_body_string(resp))
    if (geom_info$crs != 4326L) {
      suppressWarnings(sf::st_crs(sf_obj) <- geom_info$crs)
    }
    sf_obj
  } else {
    tibble::as_tibble(httr2::resp_body_json(resp, simplifyVector = TRUE))
  }
}


#' Construct filter parameters for lt_fetch
#'
#' Converts R expressions into PostgREST filter format. Supports `==`, `!=`,
#' `>`, `<`, `>=`, `<=`, `%in%`, `is.na()`, and `!is.na()`.
#'
#' @param ... R filter expressions (e.g., `col == "value"`, `col %in% c("a", "b")`).
#'
#' @return A named list of filter conditions for passing to [lt_fetch()].
#' @export
#'
#' @examples
#' lt_filter(lernzmp_id == "LID40188")
#' lt_filter(depth >= 10, lernzmp_id %in% c("LID40188", "LID40189"))
lt_filter <- function(...) {
  exprs <- match.call(expand.dots = FALSE)$`...`
  do.call(c, lapply(exprs, parse_expr))
}

#' @noRd
parse_expr <- function(expr) {
  if (!is.call(expr)) {
    cli::cli_abort("Expected a filter expression, e.g. {.code col == 'value'}.")
  }

  op  <- as.character(expr[[1]])
  col <- as.character(expr[[2]])

  if (op == "is.na")  return(stats::setNames(list("is.null"),     col))
  if (op == "!")      return(stats::setNames(list("not.is.null"), as.character(expr[[2]][[2]])))

  val <- eval(expr[[3]], parent.frame(2))

  pg_val <- switch(op,
                   "=="   = paste0("eq.",   val),
                   "!="   = paste0("neq.",  val),
                   ">"    = paste0("gt.",   val),
                   ">="   = paste0("gte.",  val),
                   "<"    = paste0("lt.",   val),
                   "<="   = paste0("lte.",  val),
                   "%in%" = paste0("in.(", paste(val, collapse = ","), ")"),
                   cli::cli_abort("Unsupported operator {.code {op}} in filter expression.")
  )

  stats::setNames(list(pg_val), col)
}
