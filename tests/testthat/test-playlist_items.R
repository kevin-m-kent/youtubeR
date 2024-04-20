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


# -----------
## jr added
# -----------

# 2024 - 04 - 16
# NO MOCK

# ------------------
#   get_channel_id
# ------------------
get_channel_id("jimrothstein")
# [1] "UClB5qWyXejlAwwkDAzJis-Q"

# ----------------
#   get_my_playlists
# ----------------
# TODO:   get all the playlists
library(tibblify)
test_that("get_my_playlists() works", {
  expect_no_error(z <- get_my_playlists())
  tibblify(z)
})


# ----------------------
#   get_playlist_items
# ----------------------
test_that("get_videos_for_playlistId() is working", {
            expect_no_error(
  playlistId = "PLbcglKxZP5PMU2rNPBpYIzLTgzd5aOHw2"
  z <- get_videos_for_playlistId(playlistId)
t <- tibblify(z)
dplyr::select(t, -publishedAt)
  )
})
