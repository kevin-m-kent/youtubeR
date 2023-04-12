#' Get my channel detail playlist ids
#'
#' Get ids of playlists that contain details about the content of a channel.
#'
#' @param token A `YOUTUBE_TOKEN`.
#'
#' @return The *contentDetails* object encapsulates information about the
#'   channel's content.
#' | **Property** | **Class** | **Description** |
#' |:-------------|:----------|:----------------|
#' | watchHistory | character | The ID of the playlist that contains the channel's watch history. Use the playlistItems.insert and playlistItems.delete to add or remove items from that list. |
#' | likes | character | The ID of the playlist that contains the channel's liked videos. Use the playlistItems.insert and playlistItems.delete to add or remove items from that list. |
#' | favorites | character | The ID of the playlist that contains the channel's favorite videos. Use the playlistItems.insert and playlistItems.delete to add or remove items from that list. |
#' | watchLater | character | The ID of the playlist that contains the channel's watch later playlist. Use the playlistItems.insert and playlistItems.delete to add or remove items from that list. |
#' | uploads | character | The ID of the playlist that contains the channel's uploaded videos. Use the videos.insert method to upload new videos and the videos.delete method to delete previously uploaded videos. |
#' @export
#'
#' @examplesIf has_youtube_client_envvars() && interactive()
#' get_my_channel_details()
get_my_channel_detail_playlist_ids <- function(token = fetch_token()) {
  # TODO: Wrap all this boilerplate stuff into an internal .call_youtube
  # function.
  req <- httr2::request(base_url) |>
    httr2::req_auth_bearer_token(token) |>
    httr2::req_url_path_append("channels") |>
    httr2::req_url_query(
      part = "contentDetails",
      mine = TRUE
    )

  res <- req |>
    httr2::req_perform() |>
    httr2::resp_body_json()

  # For now I'm just doing one quick "well that's weird" check. We should make
  # this somewhat more robust.
  if (length(res$items) != 1) { # nocov start
    cli::cli_abort(
      "Expected 1 channels$items, got {length(res$items)}.",
      class = "unexpected_channelitems_length"
    )
  } # nocov end

  return(res$items[[1]]$contentDetails$relatedPlaylists)
}

#' Get Playlist Ids
#'
#' Retrieves the upload playlist ids.
#'
#' @param client an httr2 oauth2 client for the google api
#' @param token_url google's oauth2 token url
#' @param auth_url google's oauth2 auth url
#' @param scope token scope, default is youtube
#'
#' @return list of playlist ids for uploads
#' @export
#'
#' @examplesIf has_youtube_client_envvars() && interactive()
#' get_upload_playlist_id()
get_upload_playlist_id <- function(token = fetch_token()) {
  return(
    get_my_channel_detail_playlist_ids()$uploads
  )
}
