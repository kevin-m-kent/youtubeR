# Tests built against the youtubeR Package Tests YouTube channel. If you're not
# using the mock, be sure to set up a YOUTUBE_TOKEN for that channel.
with_mock_dir("../api/playlist_items", {
  test_that("get_playlist_items works", {
    playlist_id <- get_upload_playlist_id(client = NULL, token = yt_token)
    expect_snapshot({
      get_playlist_items(playlist_id, client = NULL, token = yt_token)
    })
    expect_snapshot({
      get_playlist_items(
        playlist_id,
        max_results = 1,
        client = NULL,
        token = yt_token
      )
    })
  })
  test_that("get_playlist_video_ids works", {
    playlist_id <- get_upload_playlist_id(client = NULL, token = yt_token)
    expect_snapshot({
      get_playlist_video_ids(playlist_id, client = NULL, token = yt_token)
    })
    expect_snapshot({
      get_playlist_video_ids(
        playlist_id,
        max_results = 1,
        client = NULL,
        token = yt_token
      )
    })
  })
})
