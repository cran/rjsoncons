## ----include = FALSE----------------------------------------------------------
knitr::opts_chunk$set(
  collapse = TRUE
)

## ----install, eval = FALSE----------------------------------------------------
#  install.packages("rjsoncons", repos = "https://CRAN.R-project.org")

## ----install_github, eval = FALSE---------------------------------------------
#  if (!requireNamespace("remotes", quiety = TRUE))
#      install.packages("remotes", repos = "https://CRAN.R-project.org")
#  remotes::install_github("mtmorgan/rjsoncons")

## ----library, messages = FALSE------------------------------------------------
library(rjsoncons)
rjsoncons::version()

## ----json_example-------------------------------------------------------------
json <- '{
  "locations": [
    {"name": "Seattle", "state": "WA"},
    {"name": "New York", "state": "NY"},
    {"name": "Bellevue", "state": "WA"},
    {"name": "Olympia", "state": "WA"}
  ]
}'

## ----j_query------------------------------------------------------------------
j_query(json, "locations[?state == 'NY']") |>
    cat("\n")

## ----as_arg-------------------------------------------------------------------
j_query(json, "locations[?state == 'WA'].name", as = "R")

## ----jsonpointer--------------------------------------------------------------
j_query(json, "/locations/0/state")

## ----array_of_objects---------------------------------------------------------
path <- '{
    name: locations[].name,
    state: locations[].state
}'
j_query(json, path, as = "R") |>
    data.frame()

## ----j_pivot------------------------------------------------------------------
j_pivot(json, "locations", as = "data.frame")

## ----r_list-------------------------------------------------------------------
## `lst` is an *R* list
lst <- jsonlite::fromJSON(json, simplifyVector = FALSE)
j_query(lst, "locations[?state == 'WA'].name | sort(@)", auto_unbox = TRUE) |>
    cat("\n")

## -----------------------------------------------------------------------------
ndjson_file <-
    system.file(package = "rjsoncons", "extdata", "2023-02-08-0.json")

## ----ndjson_listviewer, eval = FALSE------------------------------------------
#  j_query(ndjson_file, n_records = 1) |>
#      listviewer::jsonedit()

## ----ndjson_j_query-----------------------------------------------------------
j_query(ndjson_file, "{id: id, type: type}", n_records = 5)

## ----ndjson_j_pivot-----------------------------------------------------------
j_pivot(ndjson_file, "{id: id, type: type}", as = "data.frame")

## ----ndjson_j_pivot_filter----------------------------------------------------
path <-
    "[{id: id, type: type, org: org}]
         [?@.type == 'PushEvent' && @.org != null]"
j_pivot(ndjson_file, path, as = "data.frame")

## ----as_r---------------------------------------------------------------------
as_r('[true, false, true]') # boolean -> logical
as_r('[1, 2, 3]')           # integer -> integer
as_r('[1.0, 2.0, 3.0]')     # double  -> numeric
as_r('["a", "b", "c"]')     # string  -> character

## ----as_r_integer_numeric-----------------------------------------------------
as_r('[1, 2.0]') |> class() # numeric

## ----as_r_64_bit--------------------------------------------------------------
as_r('[1, 2147483648]') |> class()  # 64-bit integers -> numeric

## ----as_r_objects-------------------------------------------------------------
as_r('{}')
as_r('{"a": 1.0, "b": [2, 3, 4]}') |> str()

## ----as_r_scalars-------------------------------------------------------------
identical(as_r("3.14"), as_r("[3.14]"))

## ----as_r_mixed_arrays--------------------------------------------------------
as_r('[true, 1, "a"]') |> str()

## ----as_r_null----------------------------------------------------------------
as_r('null')                  # NULL
as_r('[null]') |> str()       # list(NULL)
as_r('[null, null]') |> str() # list(NULL, NULL)

## ----as_r_field_order---------------------------------------------------------
json <- '{"b": 1, "a": {"d": 2, "c": 3}}'
as_r(json) |> str()
as_r(json, object_names = "sort") |> str()

## ----as_r_tiny_test_source, eval = FALSE--------------------------------------
#  system.file(package = "rjsoncons", "tinytest", "test_as_r.R")

## ----jsonlite_fromJSON--------------------------------------------------------
j_query(json, "locations[?state == 'WA']") |>
    ## `fromJSON()` simplifies list-of-objects to data.frame
    jsonlite::fromJSON()

## ----session_info-------------------------------------------------------------
sessionInfo()

