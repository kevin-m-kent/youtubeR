# test-jim_get_videos.R
# PURPOSE:  place for jim to test, to be removed

#' Given a playlistId, return the videos.

testthat::test_that("retrieves videos", {
  playlistId <- "PLbcglKxZP5PMU2rNPBpYIzLTgzd5aOHw2"
  expect_no_error(
    get_videos_for_playlistId(playlistId)
  )
})

z <- get_videos_for_playlistId(playlistId)
library(tibblify)
tibblify(z)
