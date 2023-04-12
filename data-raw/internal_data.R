# We'll save some API properties as internal data to make them easier to
# reference in functions.


base_url <- "https://www.googleapis.com/youtube/v3/"


# Save to internal data -------------------------------------------------------

usethis::use_data(
  base_url,
  internal = TRUE,
  overwrite = TRUE
)


# Clean up ---------------------------------------------------------------------

rm(
  base_url
)
