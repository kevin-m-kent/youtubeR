test_that("datetime produces a proper placeholder", {
  test_result <- datetime()
  expect_length(test_result, 0)
  expect_s3_class(test_result, c("POSIXct", "POSIXt"))
})

test_that(".compact compacts nested lists", {
  simple <- list(a = 1, b = character(), c = list())
  complex <- list(
    a = list(),
    b = simple,
    c = letters
  )
  expect_identical(
    .compact(simple),
    list(a = 1)
  )
  expect_identical(
    .compact(complex),
    list(
      b = .compact(simple),
      c = letters
    )
  )
})

test_that(".str2csv smushes strings", {
  expect_identical(
    .str2csv(c("a", "b")),
    "a,b"
  )
})

test_that(".format_used_names extracts what we expect", {
  simple <- list(first_thing = 1, second_thing = character(), third = list())
  complex <- list(
    outer_first_thing = list(),
    outer_second_thing = simple,
    outer_third = letters
  )
  expect_identical(
    .format_used_names(simple),
    "firstThing"
  )
  expect_identical(
    .format_used_names(complex),
    "outerSecondThing,outerThird"
  )
})
