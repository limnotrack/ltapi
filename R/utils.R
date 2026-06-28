#' @noRd
lt_detect_geom <- function(table, base_url = "https://api.limnotrack.com/postgrest") {
  spec  <- get_spec(base_url)
  props <- spec$definitions[[table]]$properties
  if (is.null(props)) return(NULL)

  geom_cols <- Filter(\(p) isTRUE(grepl("geometry", p$format)), props)
  if (length(geom_cols) == 0) return(NULL)

  fmt       <- geom_cols[[1]]$format
  crs_match <- regmatches(fmt, regexpr("\\d+(?=\\))", fmt, perl = TRUE))
  crs       <- if (length(crs_match) == 1) as.integer(crs_match) else 4326L

  list(col = names(geom_cols)[[1]], crs = crs)
}
