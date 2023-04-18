#' Datetime vectors
#'
#' Create an object of type "POSIXct". This function is used to provide a
#' length-0 placeholder value in function definitions.
#'
#' @return A length-0 POSIXct object.
#' @export
#'
#' @examples
#' datetime()
datetime <- function() {
  return(as.POSIXct(integer()))
}

#' Discard empty elements
#'
#' Discard empty elements in nested lists.
#'
#' @param lst A (nested) list to filter.
#' @param depth The current recursion depth.
#' @param max_depth The maximum recursion depth.
#'
#' @return The list, minus empty elements and branches.
#' @keywords internal
.compact <- function(lst, depth = 1, max_depth = 20) {
  if (is.list(lst) && depth <= max_depth) {
    lst <- purrr::map(
      lst, .compact,
      depth = depth + 1,
      max_depth = max_depth
    )
  }
  return(purrr::compact(lst))
}

#' Smush a string to a comma-separated list
#'
#' @param string A character vector to smush.
#'
#' @return A character scalar like "this,that".
#' @keywords internal
.str2csv <- function(string) {
  return(paste(string, collapse = ","))
}

#' Stringify the names of a list
#'
#' @param lst A named list object. This object will be compacted, and then the
#'   names of any remaining components will be returned, as a comma-separated
#'   list.
#'
#' @return A comma-separated character, such as "this,that".
#' @keywords internal
.format_used_names <- function(lst) {
  names(lst) <- snakecase::to_lower_camel_case(names(lst))
  return(.str2csv(names(.compact(lst))))
}
