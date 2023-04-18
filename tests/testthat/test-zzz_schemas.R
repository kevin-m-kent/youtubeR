test_that("yt_video_snippet creates the expected structure", {
  expect_identical(
    yt_video_snippet(title = "title"),
    list(title = "title")
  )
})

test_that("yt_video_status creates the expected structure", {
  expect_identical(
    yt_video_status(embeddable = TRUE),
    list(embeddable = TRUE)
  )
})

test_that("yt_video_localization creates the expected structure", {
  expect_identical(
    yt_video_localization(title = "title"),
    list(title = "title")
  )
})
