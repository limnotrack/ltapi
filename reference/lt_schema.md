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
lt_schema("depth_contours")
#> # A tibble: 8 × 4
#>   column           type    format                           description         
#>   <chr>            <chr>   <chr>                            <chr>               
#> 1 contour_id       integer integer                          "Note:\nThis is a P…
#> 2 lernzmp_id       string  character varying                "Note:\nThis is a F…
#> 3 contour_ring_id  integer integer                           NA                 
#> 4 depth_m          number  numeric                           NA                 
#> 5 elevation_m      number  numeric                           NA                 
#> 6 length_m         number  numeric                           NA                 
#> 7 depth_confidence string  character varying                 NA                 
#> 8 geom             string  public.geometry(LineString,2193)  NA                 
```
