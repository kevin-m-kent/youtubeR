% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/aaa_requests.R
\name{.prepare_body}
\alias{.prepare_body}
\title{Prepare the body of a call}
\usage{
.prepare_body(body, mime_type = NULL)
}
\arguments{
\item{body}{An object to use as the body of the request. If any component of
the body is a path, pass it through \code{\link[fs:path]{fs::path()}} or otherwise give it the
class "fs_path" to indicate that it is a path.}

\item{mime_type}{A character scalar indicating the mime type of any files
present in the body. Some APIs are ok leaving this at NULL for them to
guess.}
}
\value{
A prepared body list object with a "json" or "multipart" subclass.
}
\description{
Prepare the body of a call
}
\keyword{internal}
