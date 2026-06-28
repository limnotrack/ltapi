# List available tables from the LimnoTrack API

Retrieves and caches the OpenAPI schema from the LimnoTrack PostgREST
API, returning the names of all available tables.

## Usage

``` r
lt_tables(base_url = "https://api.limnotrack.com/postgrest")
```

## Arguments

- base_url:

  Base URL for the LimnoTrack PostgREST API. Defaults to
  `"https://api.limnotrack.com/postgrest"`.

## Value

A sorted character vector of table names.

## Errors

- `ltapi_api_unavailable`:

  The API could not be reached, or returned a 502/503/504.

- `ltapi_api_error`:

  The API returned an unexpected HTTP error.

## Examples

``` r
if (FALSE) { # \dontrun{
  lt_tables()
} # }
```
