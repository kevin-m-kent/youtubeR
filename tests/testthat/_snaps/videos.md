# get_video_processing_details works

    Code
      get_video_processing_details(video_ids, client = NULL, token = yt_token)
    Output
      $S7eyL16zQxc
      $S7eyL16zQxc$processingStatus
      [1] "succeeded"
      
      $S7eyL16zQxc$fileDetailsAvailability
      [1] "available"
      
      $S7eyL16zQxc$processingIssuesAvailability
      [1] "available"
      
      $S7eyL16zQxc$tagSuggestionsAvailability
      [1] "inProgress"
      
      $S7eyL16zQxc$editorSuggestionsAvailability
      [1] "inProgress"
      
      $S7eyL16zQxc$thumbnailsAvailability
      [1] "available"
      
      
      $Lc7b1X_nDEg
      $Lc7b1X_nDEg$processingStatus
      [1] "succeeded"
      
      $Lc7b1X_nDEg$fileDetailsAvailability
      [1] "available"
      
      $Lc7b1X_nDEg$processingIssuesAvailability
      [1] "available"
      
      $Lc7b1X_nDEg$tagSuggestionsAvailability
      [1] "inProgress"
      
      $Lc7b1X_nDEg$editorSuggestionsAvailability
      [1] "inProgress"
      
      $Lc7b1X_nDEg$thumbnailsAvailability
      [1] "available"
      
      

# playlists are back to where we started

    Code
      get_playlist_items(playlist_id, client = NULL, token = yt_token)
    Output
      [[1]]
      [[1]]$videoId
      [1] "S7eyL16zQxc"
      
      [[1]]$videoPublishedAt
      [1] "2023-04-18T15:14:53Z"
      
      
      [[2]]
      [[2]]$videoId
      [1] "Lc7b1X_nDEg"
      
      [[2]]$videoPublishedAt
      [1] "2023-04-18T15:11:46Z"
      
      

