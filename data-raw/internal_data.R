# We'll save some API properties as internal data to make them easier to
# reference in functions.


.base_url <- "https://youtube.googleapis.com/"
.base_url <- paste0(
  base_url,
  c("", "upload/", "resumable/upload/"),
  "youtube/v3"
)
names(.base_url) <- c(
  "basic",
  "upload",
  "resumable_upload"
)

# Save to internal data -------------------------------------------------------

usethis::use_data(
  .base_url,
  internal = TRUE,
  overwrite = TRUE
)


# Clean up ---------------------------------------------------------------------

rm(
  .base_url
)
