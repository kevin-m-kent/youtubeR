#' Get my channel detail playlist ids
#'
#' Get ids of playlists that contain details about the content of a channel.
#'
#' @inheritParams .call_youtube_api
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
  res <- .call_youtube_api(
    endpoint = "channels",
    query = list(
      part = "contentDetails",
      mine = TRUE
    ),
    token = token
  )

  # For now I'm just doing one quick "well that's weird" check. We should make
  # this more robust.
  if (length(res$items) != 1) { # nocov start
    cli::cli_abort(
      "Expected 1 channel$items, got {length(res$items)}.",
      class = "unexpected_items_length"
    )
  } # nocov end


  return(res$items[[1]]$contentDetails$relatedPlaylists)
}

#' Get Playlist Ids
#'
#' Retrieves the upload playlist ids.
#'
#' @inheritParams .call_youtube_api
#'
#' @return list of playlist ids for uploads
#' @export
#'
#' @examplesIf has_youtube_client_envvars() && interactive()
#' get_upload_playlist_id()
get_upload_playlist_id <- function(token = fetch_token()) {
  return(get_my_channel_detail_playlist_ids()$uploads)
}
