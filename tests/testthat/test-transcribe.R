test_that("basic speech recognition works", {
  english1 <- system.file("extdata", "sample-english1.mp3", package = "audrey")
  english1_output <- transcribe(english1, output_dir = ".")

  english2 <- system.file("extdata", "sample-english2.mp3", package = "audrey")
  english2_output <- transcribe(english2, output_dir = ".")

  expect_equal(english1_output, "Other forms of moral economy are more informal.")
  expect_equal(english2_output, "It is so named because it was designed and implemented at Dartmouth College.")
})
