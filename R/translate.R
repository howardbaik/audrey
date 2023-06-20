#' Translate to English
#'
#' Convert audio spoken in a non-English language into English through translation.
#'
#' @inheritParams transcribe
#'
#' @return A message indicating whether the function was a success or failure
#' @export
#'
#' @examples
#' \dontrun{
#' # Korean to English
#' korean <- system.file("extdata", "sample-korean.wav", package = "audrey")
#' translate(korean, audio_lang = "Korean", output_dir = ".")
#'
#' # Japanese to English
#' japanese <- system.file("extdata", "sample-japanese.wav", package = "audrey")
#' translate(japanese, audio_lang = "Japanese", output_dir = ".")
#' }
#'
translate <- function(audio_file,
                      model_name = "small",
                      audio_lang,
                      output_dir,
                      output_format = "txt") {
  # Setup Whisper
  use_whisper()
  whisper_path <- getOption("path_to_whisper")
  # Arguments to model
  whisper_args <- paste0(audio_file, " ", "--model", " ", model_name, " ",
                         "--fp16 False", " ", "--language", " ", audio_lang, " ",
                         "--task translate", " ", "--output_dir", " ", output_dir, " ",
                         "--output_format", " ", output_format)
  # store error code (0 for success)
  res <- withr::with_path(process_whisper_path(whisper_path),
                          system2("whisper", whisper_args,
                                  # silence console output
                                  stdout = NULL))

  # figure out output file name
  audio_file_processed <- tools::file_path_sans_ext(basename(audio_file))
  output_name <- paste0(audio_file_processed, ".", output_format)

  if (res != 0) {
    cli::cli_alert_danger("Failed to translate speech in '{audio_file}'")
  } else {
    cli::cli_alert_success("Successfully translated {audio_lang} in '{audio_file}' to English")
    cli::cli_alert_info("Stored output in '{output_name}'")
  }
}
