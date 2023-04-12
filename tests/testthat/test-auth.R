test_that("browse_gc_credentials returns url", {
  # Force non-interactive mode for easier interactive testing.
  rlang::local_interactive(FALSE)

  expect_identical(
    browse_gc_credentials(),
    "https://console.cloud.google.com/apis/credentials"
  )
})

test_that("has_youtube_client_envvars works", {
  withr::local_envvar(
    YOUTUBE_CLIENT_ID = NA,
    YOUTUBE_CLIENT_SECRET = NA
  )
  expect_false(has_youtube_client_envvars())
  expect_true(has_youtube_client_envvars("a", "a"))
  withr::local_envvar(
    YOUTUBE_CLIENT_ID = "an_id",
    YOUTUBE_CLIENT_SECRET = "a_secret"
  )
  expect_true(has_youtube_client_envvars())
  expect_false(has_youtube_client_envvars("", ""))
})

test_that("construct_client constructs a client", {
  expect_snapshot(
    construct_client("a", "b")
  )
  withr::local_envvar(
    YOUTUBE_CLIENT_ID = "an_id",
    YOUTUBE_CLIENT_SECRET = "a_secret"
  )
  expect_snapshot(
    construct_client()
  )
})

test_that("construct_client errors as expected", {
  expect_error(
    construct_client("", ""),
    class = "missing_youtube_client"
  )

  withr::local_envvar(
    YOUTUBE_CLIENT_ID = NA,
    YOUTUBE_CLIENT_SECRET = NA
  )
  expect_error(
    construct_client(),
    class = "missing_youtube_client"
  )
})

test_that("fetch_token works", {
  # Force non-interactive mode for easier interactive testing.
  rlang::local_interactive(FALSE)

  withr::local_envvar(
    YOUTUBE_CLIENT_ID = "client_id",
    YOUTUBE_CLIENT_SECRET = "client_secret",
    YOUTUBE_TOKEN = "youtube_token"
  )

  expect_identical(
    fetch_token(),
    "youtube_token"
  )

  withr::local_envvar(
    YOUTUBE_CLIENT_ID = "client_id",
    YOUTUBE_CLIENT_SECRET = "client_secret",
    YOUTUBE_TOKEN = NA
  )

  expect_identical(
    fetch_token(),
    ""
  )
})
