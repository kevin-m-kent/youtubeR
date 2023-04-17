test_that("datetime produces a proper placeholder", {
  test_result <- datetime()
  expect_length(test_result, 0)
  expect_s3_class(test_result, c("POSIXct", "POSIXt"))
})

test_that(".compact compacts nested lists", {
  simple <- list(a = 1, b = character())
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
