test_that("browse_gc_credentials returns url", {
  # Force non-interactive mode for easier interactive testing.
  rlang::local_interactive(FALSE)

  expect_identical(
    browse_gc_credentials(),
    "https://console.cloud.google.com/apis/credentials"
  )
})

test_that("yt_has_client_envvars works", {
  withr::local_envvar(
    YOUTUBE_CLIENT_ID = NA,
    YOUTUBE_CLIENT_SECRET = NA
  )
  expect_false(yt_has_client_envvars())
  expect_true(yt_has_client_envvars("a", "a"))
  withr::local_envvar(
    YOUTUBE_CLIENT_ID = "an_id",
    YOUTUBE_CLIENT_SECRET = "a_secret"
  )
  expect_true(yt_has_client_envvars())
  expect_false(yt_has_client_envvars("", ""))
})

test_that("yt_construct_client constructs a client", {
  expect_snapshot(
    yt_construct_client("a", "b")
  )
  withr::local_envvar(
    YOUTUBE_CLIENT_ID = "an_id",
    YOUTUBE_CLIENT_SECRET = "a_secret"
  )
  expect_snapshot(
    yt_construct_client()
  )
})

test_that("yt_construct_client errors as expected", {
  expect_error(
    yt_construct_client("", ""),
    class = "missing_youtube_client"
  )

  withr::local_envvar(
    YOUTUBE_CLIENT_ID = NA,
    YOUTUBE_CLIENT_SECRET = NA
  )
  expect_error(
    yt_construct_client(),
    class = "missing_youtube_client"
  )
})

test_that("yt_authenticate works", {
  # Force non-interactive mode for easier interactive testing.
  rlang::local_interactive(FALSE)

  withr::local_envvar(
    YOUTUBE_CLIENT_ID = "client_id",
    YOUTUBE_CLIENT_SECRET = "client_secret",
    YOUTUBE_REFRESH_TOKEN = NA
  )

  expect_null(yt_authenticate())
})

with_mock_dir("../api/auth", {
  test_that("yt_authenticate works with refresh token environment variable", {
    skip_if_not(
      yt_has_client_envvars() && nchar(Sys.getenv("YOUTUBE_REFRESH_TOKEN"))
    )

    test_result <- yt_authenticate()
    expect_s3_class(test_result, "httr2_token")
    expect_identical(
      names(test_result),
      c("token_type", "access_token", "expires_at", "scope", "refresh_token")
    )
    expect_identical(test_result$token_type, "Bearer")
    expect_type(test_result$access_token, "character")
    expect_false(.is_expired(test_result$expires_at))
    expect_identical(
      test_result$scope, "https://www.googleapis.com/auth/youtube"
    )
    expect_identical(
      test_result$refresh_token,
      Sys.getenv("YOUTUBE_REFRESH_TOKEN")
    )
  })
})
