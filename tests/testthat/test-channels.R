# Tests built against the youtubeR Package Tests YouTube channel. If you're not
# using the mock, be sure to set up a YOUTUBE_TOKEN for that channel.
with_mock_dir("../api/channel", {
  test_that("get_my_channel_detail_playlist_ids works", {
    expect_identical(
      get_my_channel_detail_playlist_ids(),
      list(likes = "LL", uploads = "UUAcp8fc_2JAtBpRdfYYOqzA")
    )
  })

  test_that("get_upload_playlist_id works", {
    expect_identical(
      get_upload_playlist_id(),
      "UUAcp8fc_2JAtBpRdfYYOqzA"
    )
  })
})
