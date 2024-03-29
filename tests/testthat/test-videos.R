# Tests built against the youtubeR Package Tests YouTube channel. If you're not
# using the mock, be sure to set up a YOUTUBE_TOKEN for that channel.
with_mock_dir("../api/videos", {
  test_that("get_video_processing_details works", {
    # NOTE: These could change at a later time. Ideally update these in a week
    # so they're "solid" (YouTube has some automated things that are currently
    # "inProgress").
    video_ids <- get_upload_playlist_id(client = NULL, token = yt_token) |>
      get_playlist_video_ids(max_results = 2, client = NULL, token = yt_token)
    expect_snapshot({
      get_video_processing_details(video_ids, client = NULL, token = yt_token)
    })
  })

  test_that("yt_videos_* works", {
    # NOTE: I don't really test that these *work*, just that they return a
    # character scalar. For now we manually test the results.
    expect_no_error({
      upload_id <- yt_videos_insert(
        video_path = test_path("youtuber_test.mp4"),
        snippet = yt_schema_video_snippet(
          title = "Test upload 1",
          description = "A video to test uploads.",
          tags = c("tag1", "tag2")
        ),
        status = yt_schema_video_status(
          privacy_status = "private"
        ),
        recording_date = "2023-04-18T15:10:00.000Z",
        client = NULL, token = yt_token
      )
    })
    expect_type(upload_id, "character")
    expect_length(upload_id, 1)

    expect_no_error({
      update_id <- yt_videos_update(
        video_id = upload_id,
        snippet = yt_schema_video_snippet(
          title = "Test upload 1",
          category_id = 22L,
          description = "A video to test updates.",
          tags = c("tag1")
        ),
        client = NULL, token = yt_token
      )
    })
    expect_identical(update_id, upload_id)

    expect_no_error({
      delete_id <- yt_videos_delete(
        video_id = update_id,
        client = NULL,
        token = yt_token
      )
    })
  })

  test_that("playlists are back to where we started", {
    skip_if_not(
      yt_has_client_envvars() && nchar(Sys.getenv("YOUTUBE_REFRESH_TOKEN"))
    )

    # I manually confirmed that this is the same as the original.
    playlist_id <- get_upload_playlist_id(client = NULL, token = yt_token)
    expect_snapshot({
      get_playlist_items(playlist_id, client = NULL, token = yt_token)
    })
  })
})
