# - Figure out output_dir and output_format arguments in command
# 'ouput_dir' can be either "./folder_name" OR "folder_name"
# 'output_format' can be either 'txt', 'vtt', 'srt', 'tsv', 'json', 'all'

# - Find out the audio input file types
# m4a, mp3, webm, mp4, mpga, wav, mpeg

whisper <- function(audio_file,
                    model_name,
                    audio_lang,
                    output_dir,
                    output_format) {
  use_whisper()
  whisper_path <- getOption("path_to_whisper")

  whisper_args <- paste0(audio_file, " ", "--model", " ", model_name, " ",
                         "--fp16 False", " ", "--language", " ", audio_lang, " ",
                         "--output_dir", " ", output_dir, " ", "--output_format", " ", output_format)
  # store error code (0 for success)
  res <- withr::with_path(process_whisper_path(whisper_path),
                          system2("whisper", whisper_args,
                                  # silence console output
                                  stdout = NULL))
  if (res != 0) {
    cli::cli_alert_danger("Failed to transcribe speech in '{audio_file}'")
  } else {
    cli::cli_alert_success("Successfully transcribed speech in '{audio_file}'")
  }
}
