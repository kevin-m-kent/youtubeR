# Functions to create and validate objects used by the YouTube API.

#' Video snippet
#'
#' Basic details about a video, including title, description, uploader,
#' thumbnails and category.
#'
#' @param title (character scalar) The video's title.
#' @param description (character scalar) The video's description.
#' @param tags (character vector) A list of keyword tags associated with the
#'   video. Tags may contain spaces.
#' @param category_id (character scalar) The YouTube video category associated
#'   with the video.
#' @param default_language (character scalar) The language of the videos's
#'   default snippet.
#'
#' @return A list with any non-zero-length properties.
#' @export
#'
#' @examples
#' yt_schema_video_snippet()
#' yt_schema_video_snippet(title = "An example video", tags = c("a", "b"))
yt_schema_video_snippet <- function(title = character(),
                                    description = character(),
                                    tags = character(),
                                    category_id = character(),
                                    default_language = character()) {
  return(
    .compact(
      list(
        title = title,
        description = description,
        tags = tags,
        category_id = category_id,
        default_language = default_language
      )
    )
  )
}

#' Video status
#'
#' The status object contains information about the video's uploading,
#' processing, and privacy statuses.
#'
#' @param embeddable (logical) This value indicates if the video can be embedded
#'   on another website.
#' @param license (factor scalar) The video's license. values: youtube,
#'   creativeCommon
#' @param privacy_status (factor scalar) The video's privacy status. values:
#'   public, unlisted, private
#' @param public_stats_viewable (logical) This value indicates if the extended
#'   video statistics on the watch page can be viewed by everyone. Note that the
#'   view count, likes, etc will still be visible if this is disabled.
#' @param publish_at (datetime scalar) The date and time when the video is
#'   scheduled to publish. It can be set only if the privacy status of the video
#'   is private.
#' @param self_declared_made_for_kids (logical) Whether the video is made for
#'   kids.
#'
#' @return A list with any non-zero-length properties.
#' @export
#'
#' @examples
#' yt_schema_video_status()
#' yt_schema_video_status(embeddable = TRUE)
yt_schema_video_status <- function(embeddable = logical(),
                                   license = character(),
                                   privacy_status = character(),
                                   public_stats_viewable = logical(),
                                   publish_at = datetime(),
                                   self_declared_made_for_kids = logical()) {
  return(
    .compact(
      list(
        embeddable = embeddable,
        license = license,
        privacy_status = privacy_status,
        public_stats_viewable = public_stats_viewable,
        publish_at = publish_at,
        self_declared_made_for_kids = self_declared_made_for_kids
      )
    )
  )
}

#' Video localization
#'
#' Localized versions of certain video properties (e.g. title).
#'
#' @param description (character scalar) Localized version of the video's
#'   description.
#' @param title (character scalar) Localized version of the video's title.
#'
#' @return A list with any non-zero-length properties.
#' @export
#'
#' @examples
#' yt_schema_video_localization()
#' yt_schema_video_localization(description = "A description.")
yt_schema_video_localization <- function(description = character(),
                                         title = character()) {
  return(
    .compact(
      list(
        description = description,
        title = title
      )
    )
  )
}
