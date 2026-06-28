# Reset the cached PostgREST schema

Clears any cached API schema data, forcing the next call to
[`lt_tables()`](lt_tables.md) or [`lt_schema()`](lt_schema.md) to
re-fetch from the API.

## Usage

``` r
lt_cache_reset()
```

## Value

Invisibly returns `NULL`.

## Examples

``` r
if (FALSE) { # \dontrun{
  lt_cache_reset()
} # }
```
