# Query LimnoTrack database with flexible parameters

Query any table in the LimnoTrack database with optional parameters for
selecting columns, filtering rows, ordering results, and pagination.
Automatically detects geometry columns and returns an
[sf::sf](https://r-spatial.github.io/sf/reference/sf.html) object if
present, or a
[tibble::tibble](https://tibble.tidyverse.org/reference/tibble.html)
otherwise.

## Usage

``` r
lt_fetch(
  table,
  select = NULL,
  filter = NULL,
  order = NULL,
  limit = 1000L,
  offset = 0L,
  base_url = "https://api.limnotrack.com/postgrest"
)
```

## Arguments

- table:

  character; name of the table to query (e.g., `"lake_contours"`).

- select:

  character; comma-separated column names to select (e.g.,
  `"col1,col2"`). If `NULL`, all columns are returned.

- filter:

  named list of PostgREST filter expressions, typically built with
  [`lt_filter()`](lt_filter.md) (e.g.,
  `lt_filter(lernzmp_id == "LID40188")`).

- order:

  character; column ordering (e.g., `"col1.asc,col2.desc"`).

- limit:

  integer; maximum number of records to return. Default `1000`.

- offset:

  integer; number of records to skip for pagination. Default `0`.

- base_url:

  character; base URL of the LimnoTrack PostgREST API.

## Value

A [tibble::tibble](https://tibble.tidyverse.org/reference/tibble.html),
or an [sf::sf](https://r-spatial.github.io/sf/reference/sf.html) object
if the table contains geometry data.

## Errors

- `ltapi_api_unavailable`:

  The API could not be reached, or returned a 502/503/504.

- `ltapi_api_error`:

  The API returned an unexpected HTTP error.

## Examples

``` r
if (FALSE) { # \dontrun{
  lt_fetch(
    table  = "lake_contours",
    filter = lt_filter(lernzmp_id == "LID40188")
  )
} # }
```
