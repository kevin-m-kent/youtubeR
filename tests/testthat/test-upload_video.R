test_that("upload_video returns expected video ID with a mocked API", {

  # Read the mock response


  # Create a custom response object using the mock data
  mock_response_object <- function(req)  {

    browser()
    
    json_text <- readLines("mock_upload_response.json")
    mock_response <- jsonlite::fromJSON(paste(json_text, collapse = ""))
    
    httr2::response(
    status = 200,
    headers = list("Content-Type" = "application/json"),
    body = mock_response
  )
  }

  client <- list(client_id = "mockClientId", client_secret = "mockClientSecret")
  snippet <- list(title = "Test Video", description = "This is a test video.")
  video_path <- "test.txt"
  # Use the custom response object to mock the API call

  httr2::with_mock(mock_response_object,  upload_video(client, snippet, video_path))
}

)
