#' Transcribe in the original language
#'
#' Transcribe speech in audio files (Speech recognition).
#'
#' @param audio_file Input audio file: `"m4a"`, `"mp3"`, `"webm"`, `"mp4"`, `"mpga"`, `"wav"`, or `"mpeg"`
#' @param model_name Name of the Whisper model. Models include:
#' * `"tiny.en"`, `"tiny"`
#' * `"base.en"`, `"base"`
#' * `"small.en"`, `"small"`
#' * `"medium.en"`, `"medium"`
#' * `"large-v1"`, `"large-v2"`, `"large"`
#' @param audio_lang Language spoken in audio. Specify `"None"` to perform language detection.
#' @param output_dir Directory to save the output.
#' @param output_format Desired format of the output file: `"txt"`, `"vtt"`, `"srt"`, `"tsv"`, `"json"`, or `"all"`.
#'
#' @details
#' There are five model sizes, four with English-only versions, offering speed and accuracy tradeoffs. The `.en` models for
#' English speaking audio tend to perform better, especially `tiny.en` and `base.en`.
#'
#' See [Avaiable models and languages](https://github.com/openai/whisper#available-models-and-languages) for the
#' names of the available models and their approximate memory requirements and relative speed.
#'
#' @return A message indicating whether the function was a success or failure
#' @export
#'
#' @examples
#' \dontrun{
#' # English audio
#' transcribe("sample-english.mp3", output_dir = ".")
#'
#' # Non-English audio
#' transcribe("sample-japanese.mp3", audio_lang = "Japanese", output_dir = ".")
#' }
#'
transcribe <- function(audio_file,
                       model_name = "small",
                       audio_lang = "English",
                       output_dir,
                       output_format = "txt") {
  # Setup Whisper
  use_whisper()
  whisper_path <- getOption("path_to_whisper")
  # Arguments to model
  whisper_args <- paste0(audio_file, " ", "--model", " ", model_name, " ",
                         "--fp16 False", " ", "--language", " ", audio_lang, " ",
                         "--output_dir", " ", output_dir, " ", "--output_format", " ", output_format)
  # Run model and store error code (0 for success)
  res <- withr::with_path(process_whisper_path(whisper_path),
                          system2("whisper", whisper_args,
                                  # silence console output
                                  stdout = NULL))

  # Figure out output file name
  audio_file_processed <- tools::file_path_sans_ext(basename(audio_file))
  output_name <- paste0(audio_file_processed, ".", output_format)

  if (res != 0) {
    cli::cli_alert_danger("Failed to transcribe speech in '{audio_file}'")
  } else {
    cli::cli_alert_success("Successfully transcribed speech in '{audio_file}'")
    cli::cli_alert_info("Stored output in '{output_name}'")
  }
}
