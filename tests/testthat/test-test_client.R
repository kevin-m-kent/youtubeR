test_that("multiplication works", {

  Sys.setenv("YOUTUBE_CLIENT_ID" = "")
  expect_error(construct_client(), "YOUTUBE_CLIENT_ID environment variables must be set.")
})
