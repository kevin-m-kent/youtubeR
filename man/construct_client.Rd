% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/construct_client.R
\name{construct_client}
\alias{construct_client}
\title{Construct Client}
\usage{
construct_client(token_url = "https://oauth2.googleapis.com/token")
}
\arguments{
\item{token_url}{Google's oauth url}
}
\value{
an httr2 oauth client object
}
\description{
Builds the oauth client object for google apis.
}
\details{
Requires the following environment variables: CLIENT_ID, CLIENT_SECRET
}
\examples{

google_client <- create_client()
}
