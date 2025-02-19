
<!-- README.md is generated from README.Rmd. Please edit that file -->

# youtubeR

<!-- badges: start -->

[![Lifecycle:
experimental](https://img.shields.io/badge/lifecycle-experimental-orange.svg)](https://lifecycle.r-lib.org/articles/stages.html#experimental)
[![CRAN
status](https://www.r-pkg.org/badges/version/youtubeR)](https://CRAN.R-project.org/package=youtubeR)
[![R-CMD-check](https://github.com/kevin-m-kent/youtubeR/actions/workflows/R-CMD-check.yaml/badge.svg)](https://github.com/kevin-m-kent/youtubeR/actions/workflows/R-CMD-check.yaml)
[![Codecov test
coverage](https://codecov.io/gh/kevin-m-kent/youtubeR/graph/badge.svg)](https://app.codecov.io/gh/kevin-m-kent/youtubeR)
<!-- badges: end -->

A package for interacting with the Youtube Data API. This package is
being developed first to aid in the processing of [R4DS Online Learning
Community](https://r4ds.io) book club videos. As such, functionality
will be focused where it is needed for that task. Long-term, we hope to
implement the entire YouTube API.

## Installation

<div class="pkgdown-release">

Install the released version of youtubeR from
[CRAN](https://cran.r-project.org/):

``` r
# Not yet!
install.packages("youtubeR")
```

</div>

<div class="pkgdown-devel">

Install the development version of youtubeR from
[GitHub](https://github.com/):

``` r
# install.packages("pak")
pak::pak("kevin-m-kent/youtubeR")
```

</div>

## Setting up

### Step 1: Create an OAuth 2.0 client.

We’ll add details here about the settings to apply in your client.
You’ll need to enable the YouTube Data API v3.

``` r
library(youtubeR)

browse_gc_credentials()
# Copy the client id and client secret.
```

### Step 2: Set up environment variables

``` r
# Use the values copied above.
Sys.setenv(YOUTUBE_CLIENT_ID = "12345-ab12c.apps.googleusercontent.com")
Sys.setenv(YOUTUBE_CLIENT_SECRET = "ABCD-eFg_H")
# Ideally, set these in your .Renviron file.
```

### Step 3: Use the package

You should now be set up to call functions in the package. The first
time you call a function interactively, you will be asked to authorize
your client to act on your behalf (in your web browser).

## Retrieving Video Status

The goal here is to get the video status (if it is finished processing)
for each video that has been uploaded.

The workflow is as follows:

- Get the playlist ids
- For each playlist, get the video ids
- For each video, get the status

``` r
my_playlist_id <- get_upload_playlist_id()
video_ids <- get_playlist_video_ids(my_playlist_id)
video_details <- get_video_processing_details(video_ids)
```

## Uploading Videos

Following a similar workflow, we can also upload videos to youtube.
Assuming you already have created the client as above, you will need a
snippet and a video path. The snippet defines the title, description,
and other metadata for the video. The video path is the path to the
video file on your local machine.

``` r
snippet <- yt_schema_video_snippet(
  title = "video test",
  description = "description of this test video",
  tags = c("example tag", "another tag")
)
status <- yt_schema_video_status(
  privacy_status = "private",
  self_declared_made_for_kids = FALSE
)
video_path <- "path/to/video.mp4"

yt_videos_insert(
  video_path = video_path,
  snippet = snippet,
  status = status
)
```
