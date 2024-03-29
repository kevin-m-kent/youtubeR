% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/aaa_authentication.R
\name{.yt_refresh_token}
\alias{.yt_refresh_token}
\title{Refresh a YouTube OAuth token}
\usage{
.yt_refresh_token(client, refresh_token = NULL)
}
\arguments{
\item{client}{A YouTube OAuth client created with \code{\link[=yt_construct_client]{yt_construct_client()}}.}

\item{refresh_token}{A refresh token associated with this \code{client}.}
}
\value{
A YouTube OAuth token, or \code{NULL}.
}
\description{
Refresh a YouTube OAuth token
}
\keyword{internal}
