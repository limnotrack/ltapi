# Construct filter parameters for lt_fetch

Converts R expressions into PostgREST filter format. Supports `==`,
`!=`, `>`, `<`, `>=`, `<=`, `%in%`,
[`is.na()`](https://rdrr.io/r/base/NA.html), and `!is.na()`.

## Usage

``` r
lt_filter(...)
```

## Arguments

- ...:

  R filter expressions (e.g., `col == "value"`, `col %in% c("a", "b")`).

## Value

A named list of filter conditions for passing to
[`lt_fetch()`](lt_fetch.md).

## Examples

``` r
lt_filter(lernzmp_id == "LID40188")
#> $lernzmp_id
#> [1] "eq.LID40188"
#> 
lt_filter(depth >= 10, lernzmp_id %in% c("LID40188", "LID40189"))
#> $depth
#> [1] "gte.10"
#> 
#> $lernzmp_id
#> [1] "in.(LID40188,LID40189)"
#> 
```
