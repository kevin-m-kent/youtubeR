library(httptest2)

# When we're in capture mode, clear out previous captures.
if (Sys.getenv("YOUTUBE_API_TEST_MODE") == "capture") {
  if (Sys.getenv("YOUTUBE_TOKEN") == "") {
    stop(
      "No YOUTUBE_TOKEN available, cannot capture results. \n",
      "Unset YOUTUBE_API_TEST_MODE to use the mocked calls."
    )
  }
  unlink(test_path("api"), recursive = TRUE)
}
