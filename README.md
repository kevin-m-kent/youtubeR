# Youtube R

A package for interacting with the Youtube Data API. Right now, just uploading local videos and finding the status of uploaded videos.


# Retrieving Video Status (oauth2 manual workflow)

The goal here is to get the video status (if it is finished processing) for
each video that has been uploaded.

We will need to create the google client httr2 oauth2 object first. In order for this to work, you will need to setup environment variables for YOUTUBE_CLIENT_ID and YOUTUBE_CLIENT_SECRET. 

``` 
library(youtubeR)

google_client <- construct_client()
```

This will be used to complete each request. The workflow is as follows:

- Create google client
- Get the playlist ids
- For each playlist, get the video ids
- For each video, get the status

```
my_playlist_id <- get_playlist_ids(my_client) 

video_ids <- purrr::map(my_playlist_id, get_video_ids, client = my_client)

video_details <- purrr::map(video_ids, get_video_status, client = my_client)

```

# Uploading Videos (oauth2 manual workflow)

