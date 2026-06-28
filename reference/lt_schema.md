# Inspect the schema for a table in the LimnoTrack database

Inspect the schema for a table in the LimnoTrack database

## Usage

``` r
lt_schema(table, base_url = "https://api.limnotrack.com/postgrest")
```

## Arguments

- table:

  character; table name

- base_url:

  character; base URL of the PostgREST API. Defaults to
  `"https://api.limnotrack.com/postgrest"`.

## Value

A tibble with columns: `column`, `type`, `format`, and `description`.

## Errors

- `ltapi_api_unavailable`:

  The API could not be reached, or returned a 502/503/504.

- `ltapi_api_error`:

  The API returned an unexpected HTTP error.

- `ltapi_not_found`:

  The requested table does not exist in the schema.

## Examples

``` r
if (FALSE) { # \dontrun{
  lt_schema("my_table")
} # }
```
