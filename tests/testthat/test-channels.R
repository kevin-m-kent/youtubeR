# Tests built against the R4DS Online Learning Community org's YouTube channel.
# If you're not using the mock, be sure to set up a YOUTUBE_TOKEN for that
# channel.
with_mock_dir("../api/channel", {
  test_that("get_my_channel_detail_playlist_ids works", {
    expect_identical(
      get_my_channel_detail_playlist_ids(),
      list(likes = "LL", uploads = "UUCaChdLMTYMxyawR_Qf-kYA")
    )
  })

  test_that("get_upload_playlist_id works", {
    expect_identical(
      get_upload_playlist_id(),
      "UUCaChdLMTYMxyawR_Qf-kYA"
    )
  })
})
