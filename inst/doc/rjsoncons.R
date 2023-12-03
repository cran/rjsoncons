## ----include = FALSE----------------------------------------------------------
knitr::opts_chunk$set(
  collapse = TRUE
)

## ----eval = FALSE-------------------------------------------------------------
#  install.pacakges("rjsoncons", repos = "https://CRAN.R-project.org")

## ----eval = FALSE-------------------------------------------------------------
#  if (!requireNamespace("remotes", quiety = TRUE))
#      install.packages("remotes", repos = "https://CRAN.R-project.org")
#  remotes::install_github("mtmorgan/rjsoncons")

## ----messages = FALSE---------------------------------------------------------
library(rjsoncons)
rjsoncons::version()

## -----------------------------------------------------------------------------
json <- '{
  "locations": [
    {"name": "Seattle", "state": "WA"},
    {"name": "New York", "state": "NY"},
    {"name": "Bellevue", "state": "WA"},
    {"name": "Olympia", "state": "WA"}
  ]
}'

## -----------------------------------------------------------------------------
jmespath(json, "locations[?state == 'NY']") |>
    cat("\n")

## -----------------------------------------------------------------------------
jmespath(json, "locations[?state == 'WA'].name", as = "R")

## -----------------------------------------------------------------------------
path <- '{
    name: locations[].name,
    state: locations[].state
}'
jmespath(json, path, as = "R") |>
    data.frame()

## -----------------------------------------------------------------------------
jmespath(json, "locations[?state == 'WA']", as  = "string") |>
    ## `fromJSON()` simplifies list-of-objects to data.frame
    jsonlite::fromJSON()

## -----------------------------------------------------------------------------
## `lst` is an *R* list
lst <- jsonlite::fromJSON(json, simplifyVector = FALSE)
jmespath(lst, "locations[?state == 'WA'].name | sort(@)", auto_unbox = TRUE) |>
    cat("\n")

## -----------------------------------------------------------------------------
as_r('[true, false, true]') # boolean -> logical
as_r('[1, 2, 3]')           # integer -> integer
as_r('[1.0, 2.0, 3.0]')     # double  -> numeric
as_r('["a", "b", "c"]')     # string  -> character

## -----------------------------------------------------------------------------
as_r('[1, 2.0]') |> class() # numeric

## -----------------------------------------------------------------------------
as_r('[1, 2147483648]') |> class()  # 64-bit integers -> numeric

## -----------------------------------------------------------------------------
as_r('{}')
as_r('{"a": 1.0, "b": [2, 3, 4]}') |> str()

## -----------------------------------------------------------------------------
identical(as_r("3.14"), as_r("[3.14]"))

## -----------------------------------------------------------------------------
as_r('[true, 1, "a"]') |> str()

## -----------------------------------------------------------------------------
as_r('null')                  # NULL
as_r('[null]') |> str()       # list(NULL)
as_r('[null, null]') |> str() # list(NULL, NULL)

## -----------------------------------------------------------------------------
json <- '{"b": 1, "a": {"d": 2, "c": 3}}'
as_r(json) |> str()
as_r(json, object_names = "sort") |> str()

## ----eval = FALSE-------------------------------------------------------------
#  system.file(package = "rjsoncons", "tinytest", "test_as_r.R")

## -----------------------------------------------------------------------------
sessionInfo()

