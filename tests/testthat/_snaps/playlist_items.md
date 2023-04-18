# get_playlist_items works

    Code
      get_playlist_items(playlist_id)
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
      
      

---

    Code
      get_playlist_items(playlist_id, max_results = 1)
    Output
      [[1]]
      [[1]]$videoId
      [1] "S7eyL16zQxc"
      
      [[1]]$videoPublishedAt
      [1] "2023-04-18T15:14:53Z"
      
      

# get_playlist_video_ids works

    Code
      get_playlist_video_ids(playlist_id)
    Output
      [1] "S7eyL16zQxc" "Lc7b1X_nDEg"

---

    Code
      get_playlist_video_ids(playlist_id, max_results = 1)
    Output
      [1] "S7eyL16zQxc"

