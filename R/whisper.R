# TODO:
# - Figure out output_dir and output_format arguments in command
# - Forumate out error/success message
# - Find out the audio input file types

whisper <- function(audio_file,
                    exec_path,
                    model_name,
                    output_dir,
                    output_format) {
  whisper_args <- paste0(audio_file, " ", "--model", " ", model_name, " ",
                         "--fp16 False", " ", "--language", " ", audio_lang, " ",
                         "--output_dir", " ", output_dir, " ", "--output_format", " ", output_format)
  # store error code (0 for success)
  res <- withr::with_path("/opt/homebrew/Caskroom/miniforge/base/bin",
                          system2("whisper", whisper_args,
                                  # silence console output
                                  stdout = NULL))
  if (res != 0) {
    # some error message
  } else {
    # some success message
  }
}
