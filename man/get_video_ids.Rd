% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/get_video_ids.R
\name{get_video_ids}
\alias{get_video_ids}
\title{Get Video Ids}
\usage{
get_video_ids(
  playlist_id,
  client,
  token_url = "https://oauth2.googleapis.com/token",
  auth_url = "https://accounts.google.com/o/oauth2/v2/auth",
  scope = "https://www.googleapis.com/auth/youtube"
)
}
\arguments{
\item{playlist_id}{id retrieved from get_playlist_id}

\item{client}{httr2 oauth2 client for google apis}

\item{token_url}{google's oauth2 token url}

\item{auth_url}{google's oauth2 auth url}

\item{scope}{token scope, default is youtube}
}
\value{
list of video ids
}
\description{
Retrieves video ids for a particular playlist.
}
\examples{

#'google_client <- construct_client()

playlist_ids <- get_playlist_ids(google_client)

video_ids <- purrr::map(my_playlist_id, get_video_ids, client = my_client)
}
