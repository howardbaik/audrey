#' Transcribe in the original language
#'
#' Perform speech recognition by converting spoken language from audio file into
#' written text in its original language.
#'
#' @param audio_file Input audio file: `"m4a"`, `"mp3"`, `"webm"`, `"mp4"`,
#'   `"mpga"`, `"wav"`, or `"mpeg"`
#' @param model_name Name of the Whisper model. Models include:
#' * `"tiny.en"`, `"tiny"`
#' * `"base.en"`, `"base"`
#' * `"small.en"`, `"small"`
#' * `"medium.en"`, `"medium"`
#' * `"large-v1"`, `"large-v2"`, `"large"`
#' @param audio_lang Language spoken in audio. Specify `"None"` to perform
#'   language detection.
#' @param output_dir Directory to save the output.
#' @param output_format Desired format of the output file: `"txt"`, `"vtt"`,
#'   `"srt"`, `"tsv"`, `"json"`, or `"all"`.
#'
#' @details There are five model sizes, four with English-only versions,
#' offering speed and accuracy tradeoffs. The `.en` models for English speaking
#' audio tend to perform better, especially `tiny.en` and `base.en`.
#'
#' See ["Avaiable models and
#' languages"](https://github.com/openai/whisper#available-models-and-languages)
#' section in the README for the names of the available models and their
#' approximate memory requirements and relative speed.
#'
#' @return A character vector of text
#' @export
#'
#' @examples
#' \dontrun{
#' # English audio
#' english1 <- system.file("extdata", "sample-english1.mp3", package = "audrey")
#' english2 <- system.file("extdata", "sample-english2.mp3", package = "audrey")
#'
#' # "Other forms of moral economy are more informal"
#' transcribe(english1, output_dir = ".")
#'
#' # "It is so named because it was designed and
#' #  implemented in Dartmouth College"
#' transcribe(english2, output_dir = ".")
#'
#'
#' # Non-English audio
#' japanese <- system.file("extdata", "sample-japanese.wav", package = "audrey")
#' transcribe(japanese, audio_lang = "Japanese", output_dir = ".")
#'
#' korean <- system.file("extdata", "sample-korean.wav", package = "audrey")
#' transcribe(korean, audio_lang = "Korean", output_dir = ".")
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
  whisper_args <- paste0(audio_file, " ", "--model", " ",
                         model_name, " ", "--fp16 False", " ",
                         "--language", " ", audio_lang, " ",
                         "--output_dir", " ", output_dir, " ",
                         "--output_format", " ", output_format)
  # Run model and store error code (0 for success)
  res <- withr::with_path(process_whisper_path(whisper_path),
                          system2("whisper", whisper_args,
                                  # capture the output in a character vector
                                  stdout = TRUE))
  # remove timestamp from output
  res <- trimws(gsub("\\[.*?\\]", "", res))


  # figure out output file name
  audio_file_processed <- tools::file_path_sans_ext(basename(audio_file))
  output_name <- paste0(audio_file_processed, ".", output_format)

  # user message
  cli::cli_alert_success("Successfully transcribed speech in '{audio_file}'")
  cli::cli_alert_info("Stored the following output in '{output_name}'")

  res
}
