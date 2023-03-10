% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/get_video_status.R
\name{get_video_status}
\alias{get_video_status}
\title{Get Video Status}
\usage{
get_video_status(
  video_ids,
  client,
  token_url = "https://oauth2.googleapis.com/token",
  auth_url = "https://accounts.google.com/o/oauth2/v2/auth",
  scope = "https://www.googleapis.com/auth/youtube"
)
}
\arguments{
\item{video_ids}{list of video ids}

\item{client}{an httr2 oauth2 client for the google api}

\item{token_url}{google's oauth2 token url}

\item{auth_url}{google's oauth2 auth url}

\item{scope}{token scope, default is youtube}
}
\value{
list of processing details (processingStatus is probably of most interest)
}
\description{
Retrieves the processing details for a list of videos
}
\examples{

google_client <- construct_client()

my_playlist_id <- get_playlist_ids(google_client)
video_ids <- purrr::map(my_playlist_id, get_video_ids, client = google_client)
video_details <- purrr::map(video_ids, get_video_status, client = google_client)

}
