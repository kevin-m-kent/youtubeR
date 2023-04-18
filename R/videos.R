#' Get video processing details
#'
#' Retrieves the processing details for a vector of video IDs
#'
#' @param video_ids A character vector of video ids.
#' @inheritParams .call_youtube_api
#'
#' @return A list of processing status details. processingStatus is probably of
#'   most interest
#' @export
#'
#' @examplesIf has_youtube_client_envvars() && interactive()
#' get_upload_playlist_id() |>
#'   get_playlist_items() |>
#'   get_video_processing_details()
get_video_processing_details <- function(video_ids, token = fetch_token()) {
  result <- .call_youtube_api(
    endpoint = "videos",
    query = list(
      part = "processingDetails",
      id = .str2csv(video_ids)
    ),
    token = token
  )

  # COMBAK: Clean this up. I like to convert names to snake_case, and we should
  # at least consider rectangling this data (although that might come in a
  # downstream package).

  if (length(result$items)) {
    # HACK: Technically these could come back in a different order, or be
    # missing some. We should dig into res$items[[x]]$id to match up to
    # video_ids.
    names(result$items) <- video_ids
    return(purrr::map(result$items, purrr::pluck, "processingDetails"))
  } else {
    return(NULL)
  }
}

#' Insert video
#'
#' Inserts a new resource into this collection.
#'
#' @param video_path (character scalar) Path to a video file to upload.
#' @param snippet Basic details about a video, including title, description,
#'   uploader, thumbnails and category. See [yt_video_snippet()] for details.
#' @param localizations A list of named localizations objects. The localizations
#'   object contains localized versions of the basic details about the video,
#'   such as its title and description. The name should be a valid language key,
#'   which is a [BCP-47](http://www.rfc-editor.org/rfc/bcp/bcp47.txt) language
#'   code. See [yt_video_localization()] for details on the format for each
#'   localization.
#' @param status Basic details about a video category, such as its localized
#'   title. See [yt_video_status()] for details.
#' @param recording_date (datetime scalar) The date and time when the video was
#'   recorded.
#' @inheritParams .call_youtube_api
#'
#' @return The id of the uploaded video.
#' @export
yt_videos_insert <- function(video_path,
                             snippet = yt_video_snippet(),
                             localizations = list(),
                             status = yt_video_status(),
                             recording_date = datetime(),
                             token = fetch_token()) {
  body <- list(
    metadata = list(
      snippet = snippet,
      localizations = localizations,
      status = status,
      recording_details = list(
        recording_date = recording_date
      )
    ),
    media = fs::path(video_path) # Signal that this is a file.
  )
  result <- .call_youtube_api(
    endpoint = "videos",
    query = list(part = .detect_parts(body$metadata)),
    body = body,
    base_url = "upload"
  )

  # COMBAK: Is it possible to get here with any empty result? If so, throw an
  # error more formally here.
  return(result$id)
}

#' Stringify the names of a list
#'
#' @param lst A named list object. This object will be compacted, and then the
#'   names of any remaining components will be returned, as a comma-separated
#'   list.
#'
#' @return A comma-separated character, such as "this,that".
#' @keywords internal
.detect_parts <- function(lst) {
  names(lst) <- snakecase::to_lower_camel_case(names(lst))
  return(.str2csv(names(.compact(lst))))
}

#' Update video
#'
#' Updates an existing resource.
#'
#' @param video_id (character scalar) The ID that YouTube uses to uniquely
#'   identify the video.
#' @inheritParams yt_videos_insert
#'
#' @return The id of the updated video.
#' @export
yt_videos_update <- function(video_id,
                             snippet = yt_video_snippet(),
                             localizations = list(),
                             status = yt_video_status(),
                             recording_date = datetime(),
                             token = fetch_token()) {
  # HACK: This body should be compared to the existing body for this video.
  # Missing pieces should be filled in from the existing body.

  body <- list(
    id = video_id,
    snippet = snippet,
    localizations = localizations,
    status = status,
    recording_details = list(
      recording_date = recording_date
    )
  )
  result <- .call_youtube_api(
    endpoint = "videos",
    query = list(part = .detect_parts(body[names(body) != "id"])),
    body = body,
    method = "PUT"
  )
}
