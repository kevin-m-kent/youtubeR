#' Call the YouTube API
#'
#' If you use this function, please [open an issue in the youtubeR GitHub
#' repository](https://github.com/kevin-m-kent/youtubeR/issues) describing your
#' use case. We intend to wrap all endpoints such that this function will not be
#' necessary for users.
#'
#' @inheritParams .yt_req_auth
#' @param endpoint The path to an endpoint. Optionally, a list with the path
#'   plus variables to [glue::glue()] into the path.
#' @param query An optional list of parameters to pass in the query portion of
#'   the request.
#' @param body An optional list of parameters to pass in the body portion of the
#'   request.
#' @param method If the method is something other than GET or POST, supply it.
#'   Case is ignored.
#' @param base_url Which family of URLs to use. Almost everything will use the
#'   default basic URL.
#'
#' @return The result of the call.
#' @export
yt_call_api <- function(endpoint,
                        query = NULL,
                        body = NULL,
                        method = NULL,
                        client = yt_construct_client(),
                        cache_disk = getOption("yt_cache_disk", FALSE),
                        cache_key = getOption("yt_cache_key", NULL),
                        token = NULL,
                        base_url = c(
                          "basic", "upload", "resumable_upload"
                        )) {
  request <- .prepare_request(
    endpoint = endpoint,
    query = query,
    body = body,
    method = method,
    client = client,
    cache_disk = cache_disk,
    cache_key = cache_key,
    token = token,
    base_url = base_url
  )
  response <- httr2::req_perform(request)

  return(.parse_response(response))
}

#' Combine request pieces
#'
#' @inheritParams yt_call_api
#'
#' @return A request ready to perform.
#' @keywords internal
.prepare_request <- function(endpoint,
                             query = NULL,
                             body = NULL,
                             method = NULL,
                             client = yt_construct_client(),
                             cache_disk = getOption("yt_cache_disk", FALSE),
                             cache_key = getOption("yt_cache_key", NULL),
                             token = NULL,
                             base_url = c(
                               "basic", "upload", "resumable_upload"
                             )) {
  base_url <- rlang::arg_match(base_url)
  base_url <- .base_url[[base_url]]
  request <- httr2::request(base_url)
  endpoint <- rlang::exec(glue::glue, !!!endpoint)
  request <- httr2::req_url_path_append(request, endpoint)

  if (!is.null(query)) {
    query <- .remove_missing(query)
    if (length(query)) {
      names(query) <- snakecase::to_lower_camel_case(names(query))
      request <- httr2::req_url_query(request, !!!query)
    }
  }
  if (!is.null(body)) {
    body <- .remove_missing(body)
    body <- .prepare_body(body)
    if (length(body)) {
      request <- .add_body(request, body)
    }
  }
  if (!is.null(method)) {
    request <- httr2::req_method(request, method)
  }

  return(
    .yt_req_auth(
      request = request,
      client = client,
      cache_disk = cache_disk,
      cache_key = cache_key,
      token = token
    )
  )
}

#' Remove missing arguments
#'
#' @param arg_list A list of arguments, each of which should be wrapped in
#'   `rlang::maybe_missing()`.
#'
#' @return The list without missing parameters.
#' @keywords internal
.remove_missing <- function(arg_list) {
  arg_present <- !purrr::map_lgl(
    arg_list,
    rlang::is_missing
  )
  # QUESTION: I *think* I can simplify this now since we auto-set the body type.
  # Experiment to see if this ever fails.
  if (all(class(arg_list) == "list")) {
    return(arg_list[arg_present])
  } else { # nocov start
    stop("In the .remove_missing piece you thought you could remove.")
    return(
      structure(
        arg_list[arg_present],
        # Preserve special classes!
        class = class(arg_list)
      )
    )
  } # nocov end
}

#' Add the body to the request
#'
#' @inheritParams yt_call_api
#' @param request The rest of the request.
#'
#' @return The request with the body appropriately added.
#' @keywords internal
.add_body <- function(request, body) {
  UseMethod(".add_body", body)
}


#' @export
.add_body.multipart <- function(request, body) {
  return(
    httr2::req_body_multipart(
      request,
      !!!unclass(body)
    )
  )
}

#' @export
.add_body.json <- function(request, body) {
  return(
    httr2::req_body_json(
      request,
      data = unclass(body)
    )
  )
}

#' Prepare the body of a call
#'
#' @param body An object to use as the body of the request. If any component of
#'   the body is a path, pass it through [fs::path()] or otherwise give it the
#'   class "fs_path" to indicate that it is a path.
#' @inheritParams .prepare_body_part
#'
#' @return A prepared body list object with a "json" or "multipart" subclass.
#' @keywords internal
.prepare_body <- function(body,
                          mime_type = NULL) {
  # COMBAK: We should probably do some sort of recursive map to make sure all
  # names at depth are in camelCase.

  body <- .compact(body)
  if (rlang::is_named(body)) {
    names(body) <- snakecase::to_lower_camel_case(names(body))
  }
  if (purrr::some(body, function(x) inherits(x, "fs_path"))) {
    body <- purrr::map(body, .prepare_body_part, mime_type)
    class(body) <- c("multipart", "list")
    return(body)
  } else {
    class(body) <- c("json", "list")
    return(body)
  }
}

#' Prepare a multipart body part
#'
#' @param body_part One piece of a multipart body.
#' @param mime_type A character scalar indicating the mime type of any files
#'   present in the body. Some APIs are ok leaving this at NULL for them to
#'   guess.
#'
#' @return A character or raw vector to post.
#' @keywords internal
.prepare_body_part <- function(body_part, mime_type = NULL) {
  if (rlang::is_named(body_part)) {
    names(body_part) <- snakecase::to_lower_camel_case(names(body_part))
  }
  if (inherits(body_part, "fs_path")) {
    return(curl::form_file(body_part, type = mime_type))
  }
  return(curl::form_data(
    jsonlite::toJSON(body_part, auto_unbox = TRUE),
    type = "application/json"
  ))
}
