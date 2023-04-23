# Tests built against the youtubeR Package Tests YouTube channel. If you're not
# using the mock, be sure to set up a YOUTUBE_TOKEN for that channel.
with_mock_dir("../api/playlist_items", {
  test_that("get_playlist_items works", {
    skip_if_not(
      yt_has_client_envvars() && nchar(Sys.getenv("YOUTUBE_REFRESH_TOKEN"))
    )

    playlist_id <- get_upload_playlist_id()
    expect_snapshot({
      get_playlist_items(playlist_id)
    })
    expect_snapshot({
      get_playlist_items(playlist_id, max_results = 1)
    })
  })
  test_that("get_playlist_video_ids works", {
    skip_if_not(
      yt_has_client_envvars() && nchar(Sys.getenv("YOUTUBE_REFRESH_TOKEN"))
    )

    playlist_id <- get_upload_playlist_id()
    expect_snapshot({
      get_playlist_video_ids(playlist_id)
    })
    expect_snapshot({
      get_playlist_video_ids(playlist_id, max_results = 1)
    })
  })
})
