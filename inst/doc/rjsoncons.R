## ---- include = FALSE---------------------------------------------------------
knitr::opts_chunk$set(
  collapse = TRUE
)

## ----eval=FALSE---------------------------------------------------------------
#  if (!requireNamespace("remotes", quiety = TRUE))
#      install.packages("remotes", repos = "https://cran.r-project.org")
#  remotes::install_github("mtmorgan/rjsoncons")

## -----------------------------------------------------------------------------
library(rjsoncons)

## -----------------------------------------------------------------------------
rjsoncons::version()  # C++ library version

json <- '{
  "locations": [
    {"name": "Seattle", "state": "WA"},
    {"name": "New York", "state": "NY"},
    {"name": "Bellevue", "state": "WA"},
    {"name": "Olympia", "state": "WA"}
  ]
}'

jsonpath(json, "$..name") |>
    noquote()

jmespath(json, "locations[?state == 'WA'].name | sort(@)") |>
    noquote()

## -----------------------------------------------------------------------------
jmespath(json, "locations[?state == 'WA'].name | sort(@)") |>
    jsonlite::fromJSON()

## -----------------------------------------------------------------------------
lst <- jsonlite::fromJSON(json, simplifyVector = FALSE)
jmespath(lst, "locations[?state == 'WA'].name | sort(@)", auto_unbox = TRUE) |>
    noquote()

## -----------------------------------------------------------------------------
sessionInfo()

