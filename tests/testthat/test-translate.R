test_that("basic translation works", {
  # Korean to English
  korean <- system.file("extdata", "sample-korean.wav", package = "audrey")
  korean_output <- translate(korean, audio_lang = "Korean", output_dir = ".")

  expect_equal(korean_output[1], "Drink more milk healthily.")
  expect_equal(korean_output[2], "Depending on how much milk you drink, the effect may increase or decrease.")
})
