#' Parse the returned response
#'
#' @param response A raw response returned from the YouTube api.
#'
#' @return A `youtube_response` `list` object.
#' @keywords internal
.parse_response <- function(response) {
  httr2::resp_check_status(response)

  if (httr2::resp_status(response) == 204) {
    # Official "no content" response.
    return(NULL)
  }

  response <- httr2::resp_body_json(response)

  # COMBAK: Add robust error checking to make sure that parsed properly.

  # COMBAK: Clean this up. I like to convert names to snake_case, and we should
  # at least consider rectangling this data (although that might come in a
  # downstream package).

  return(.new_youtube_response(response))
}

#' Construct a youtube_response
#'
#' @param response_data The `data` portion of a response from
#'   `httr2::resp_body_json()`.
#'
#' @return An object with additional class "youtube_response", or `NULL`.
#' @keywords internal
.new_youtube_response <- function(response_data) {
  if (is.null(response_data)) {
    return(NULL) # nocov
  } else {
    return(
      structure(
        response_data,
        class = c("youtube_response", class(response_data))
      )
    )
  }
}
