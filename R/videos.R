#' Get video processing details
#'
#' Retrieves the processing details for a vector of video IDs
#'
#' @param video_ids A character vector of video ids.
#' @inheritParams yt_call_api
#'
#' @return A list of processing status details. processingStatus is probably of
#'   most interest
#' @export
#'
#' @examplesIf yt_has_client_envvars() && interactive()
#' get_upload_playlist_id() |>
#'   get_playlist_items() |>
#'   get_video_processing_details()
get_video_processing_details <- function(video_ids,
                                         client = yt_construct_client(),
                                         cache_disk = getOption(
                                           "yt_cache_disk", FALSE
                                         ),
                                         cache_key = getOption(
                                           "yt_cache_key", NULL
                                         ),
                                         token = NULL) {
  result <- yt_call_api(
    endpoint = "videos",
    query = list(
      part = "processingDetails",
      id = .str2csv(video_ids)
    ),
    client = client,
    cache_disk = cache_disk,
    cache_key = cache_key,
    token = token
  )

  if (length(result$items)) {
    # HACK: Technically these could come back in a different order, or be
    # missing some. We should dig into res$items[[x]]$id to match up to
    # video_ids.
    names(result$items) <- video_ids
    return(purrr::map(result$items, purrr::pluck, "processingDetails"))
  } else {
    # QUESTION: Is this possible? Probably handle in the response processing?
    return(NULL) # nocov
  }
}

#' Insert video
#'
#' Inserts a new resource into this collection.
#'
#' @param video_path (character scalar) Path to a video file to upload.
#' @param snippet Basic details about a video, including title, description,
#'   uploader, thumbnails and category. See [yt_schema_video_snippet()] for
#'   details.
#' @param localizations A list of named localizations objects. The localizations
#'   object contains localized versions of the basic details about the video,
#'   such as its title and description. The name should be a valid language key,
#'   which is a [BCP-47](http://www.rfc-editor.org/rfc/bcp/bcp47.txt) language
#'   code. See [yt_schema_video_localization()] for details on the format for
#'   each localization.
#' @param status Basic details about a video category, such as its localized
#'   title. See [yt_schema_video_status()] for details.
#' @param recording_date (datetime scalar) The date and time when the video was
#'   recorded.
#' @inheritParams yt_call_api
#'
#' @return The id of the uploaded video.
#' @export
yt_videos_insert <- function(video_path,
                             snippet = yt_schema_video_snippet(),
                             localizations = list(),
                             status = yt_schema_video_status(),
                             recording_date = datetime(),
                             client = yt_construct_client(),
                             cache_disk = getOption("youtuberR.cache_disk",
                                                    FALSE),
                             cache_key = getOption("youtuberR.cache_key", NULL),
                             token = NULL) {
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
  result <- yt_call_api(
    endpoint = "videos",
    query = list(part = .format_used_names(body$metadata)),
    body = body,
    client = client,
    cache_disk = cache_disk,
    cache_key = cache_key,
    token = token,
    base_url = "upload"
  )

  return(result$id)
}

#' Update video
#'
#' Updates an existing resource.
#'
#' @param video_id (character scalar) The id parameter specifies the YouTube
#'   video ID for the resource that is being updated In a video resource, the id
#'   property specifies the video's ID.
#' @inheritParams yt_videos_insert
#'
#' @return The id of the updated video.
#' @export
yt_videos_update <- function(video_id,
                             snippet = yt_schema_video_snippet(),
                             localizations = list(),
                             status = yt_schema_video_status(),
                             recording_date = datetime(),
                             client = yt_construct_client(),
                             cache_disk = getOption("youtuberR.cache_disk",
                                                    FALSE),
                             cache_key = getOption("youtuberR.cache_key", NULL),
                             token = NULL) {
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
  result <- yt_call_api(
    endpoint = "videos",
    query = list(part = .format_used_names(body[names(body) != "id"])),
    body = body,
    method = "PUT",
    client = client,
    cache_disk = cache_disk,
    cache_key = cache_key,
    token = token
  )

  return(result$id)
}

#' Delete video
#'
#' Deletes a resource.
#'
#' @param video_id (character scalar) The id parameter specifies the YouTube
#'   video ID for the resource that is being deleted. In a video resource, the
#'   id property specifies the video's ID.
#' @inheritParams yt_call_api
#'
#' @return The id of the deleted video.
#' @export
yt_videos_delete <- function(video_id,
                             client = yt_construct_client(),
                             cache_disk = getOption("youtuberR.cache_disk",
                                                    FALSE),
                             cache_key = getOption("youtuberR.cache_key", NULL),
                             token = NULL) {
  result <- yt_call_api(
    endpoint = "videos",
    query = list(id = video_id),
    method = "DELETE",
    client = client,
    cache_disk = cache_disk,
    cache_key = cache_key,
    token = token
  )

  # QUESTION: Does this make sense? That ID isn't valid anymore. Maybe we SHOULD
  # return NULL?
  if (is.null(result)) {
    # This is the expectation so I'm treating this as not an error, and passing
    # through the video id.
    return(video_id)
  }

  # It shouldn't be possible for this to happen without some other error before
  # this, but be prepared in case it does.
  cli::cli_abort("Video delete failed.") # nocov
}
