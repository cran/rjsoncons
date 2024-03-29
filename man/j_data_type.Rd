% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/j_data_type.R
\name{j_data_type}
\alias{j_data_type}
\alias{j_path_type}
\title{Detect JSON / NDJSON data and path types}
\usage{
j_data_type(data)

j_path_type(path)
}
\arguments{
\item{data}{a character() JSON string or NDJSON records, or an \emph{R}
object parsed to a JSON string using \code{jsonlite::toJSON()}.}

\item{path}{character(1) JSONpointer, JSONpath or JMESpath query
string.}
}
\description{
\code{j_data_type()} uses simple rules to determine whether
'data' is JSON, NDJSON, file, url, or R.

\code{j_path_type()} uses simple rules to identify
whether \code{path} is a JSONpointer, JSONpath, or JMESpath
expression.
}
\details{
\code{j_data_type()} without any arguments reports possible return
values: \code{"json"}, \code{"ndjson"}, \code{"file"}, \code{"url"}, \code{"R"}.  When
provided an argument, \code{j_data_type()} infers (but does not
validate) the type of \code{data} based on the following rules:
\itemize{
\item For a scalar (length 1) character \code{data}, either \code{"url"}
(matching regular expression \code{"^https?://"}, \code{"file"}
(\code{file.exists(data)} returns \code{TRUE}), or \code{"json"}. When \code{"file"}
or \code{"url"} is inferred, the return value is a length 2 vector,
with the first element the inferred type of data (\code{"json"} or
\code{"ndjson"}) obtained from the first 2 lines of the file.
\item For character data with \code{length(data) > 1}, \code{"ndjson"} if all
elements start a square bracket or curly brace, consistently
(i.e., agreeing with the start of the first record), otherwise
\code{"json"}.
\item \code{"R"} for all non-character data.
}

\code{j_path_type()} without any argument reports possible values:
\code{"JSONpointer"}, \code{"JSONpath"}, or \code{"JMESpath"}. When provided an
argument, \code{j_path_type()} infers the type of \code{path} using a simple
but incomplete classification:
\itemize{
\item \code{"JSONpointer"} is inferred if the the path is \code{""} or starts with \code{"/"}.
\item \code{"JSONpath"} expressions start with \code{"$"}.
\item \code{"JMESpath"} expressions satisfy neither the \code{JSONpointer} nor
\code{JSONpath} criteria.
}

Because of these rules, the valid JSONpointer path \code{"@"} is
interpreted as JMESpath; use \code{jsonpointer()} if JSONpointer
behavior is required.
}
\examples{
j_data_type()                            # available types
j_data_type("")                          # json
j_data_type('{"a": 1}')                  # json
j_data_type(c('[{"a": 1}', '{"a": 2}]')) # json
j_data_type(c('{"a": 1}', '{"a": 2}'))   # ndjson
j_data_type(list(a = 1, b = 2))          # R
fl <- system.file(package = "rjsoncons", "extdata", "example.json")
j_data_type(fl)                          # c('json', 'file')
j_data_type(readLines(fl))               # json

j_path_type()                            # available types
j_path_type("")                          # JSONpointer
j_path_type("/locations/0/name")         # JSONpointer
j_path_type("$.locations[0].name")       # JSONpath
j_path_type("locations[0].name")         # JMESpath

}
