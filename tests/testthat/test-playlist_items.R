# TODO: These tests are super fragile. They will change every time there's a new
# upload. We should set up an account for testing.

# Tests built against the R4DS Online Learning Community org's YouTube channel.
# If you're not using the mock, be sure to set up a YOUTUBE_TOKEN for that
# channel.
with_mock_dir("api/playlist_items", {
  test_that("get_playlist_items works", {
    playlist_id <- get_upload_playlist_id()
    expect_snapshot(get_playlist_items(playlist_id))
    expect_snapshot(get_playlist_items(playlist_id, max_results = 2))
  })

  test_that("get_playlist_video_ids works", {
    playlist_id <- get_upload_playlist_id()
    expect_snapshot(get_playlist_video_ids(playlist_id))
    expect_snapshot(get_playlist_video_ids(playlist_id, max_results = 2))
  })
})
