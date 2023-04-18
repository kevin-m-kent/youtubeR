# TODO: Update to use youtubeR test channel.

# HACK: These tests are even more fragile. They will change every time there's a
# new upload or an upload changes status. We should set up an account for
# testing, and even then this will be tricky.
with_mock_dir("../api/videos", {
  test_that("get_video_processing_details works", {
    video_ids <- get_upload_playlist_id() |>
      get_playlist_video_ids(max_results = 2)
    expect_snapshot(get_video_processing_details(video_ids))
  })
})
