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

Following a similar workflow, we can also upload videos to youtube. Assuming you already have created the client as above, you will need a snippet and a video path. The snippet defines the title, description, and other metadata for the video. The video path is the path to the video file on your local machine. 

```

snippet <- list(snippet = list("title" = unbox("video kids test"),
                    "description" = unbox("description_test"),
                    "tags" = "kevin,kent"),
status = list("privacyStatus" = unbox("private"),
            "selfDeclaredMadeForKids" = unbox("false")))
             
video_path <- "path/to/video.mp4"

upload_video(client = my_client, snippet, video_path)

```