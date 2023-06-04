#' Point to local whisper Unix Executable File (.exe)
#'
#' Function to set an option that points to the local whisper Executable File
#' \code{whisper}.
#'
#' @param path path to the local whisper Executable File
#'
#' @details List of possible file path locations for the local whisper
#'   Executable File
#' \describe{
#'    \item{Linux}{/usr/bin/whisper, /usr/local/bin/whisper}
#'    \item{Mac}{/opt/homebrew/Caskroom/miniforge/base/bin/whisper}
#'    \item{Windows}{C:\\Program Files\\whisper}
#' }
#'
#' @return Returns nothing, function sets the option variable
#'   \code{path_to_whisper}.
#' @export
#'
#' @examples \dontrun{
#' set_whisper_path("~/your/path/to/whisper")
#' }
set_whisper_path <- function(path) {
  stopifnot(is.character(path))

  if (!file.exists(path)) stop(paste0("Cannot find ", "\"", path,"\""), call. = FALSE)
  options("path_to_whisper" = path)
}

# Prepare to use whisper by checking if it exists locally.
# Check option "path_to_whisper". If it's NULL, call find_whisper(), which
# will try to determine the local path to Executable File "whisper". If
# find_whisper() is successful, the path to "whisper" will be assigned to option
# "path_to_whisper", otherwise an error is thrown.
use_whisper <- function() {
  whisper_path <- getOption("path_to_whisper")

  if (is.null(whisper_path)) {
    whisper_path <- find_whisper()
    set_whisper_path(whisper_path)
  }
}

# Returns the local path to "whisper". Search is performed by looking in the known
# file locations for the current OS. If OS is not Linux, OSX, or Windows, an
# error is thrown. If path to "whisper" is not found, an error is thrown.
find_whisper <- function() {
  user_os <- Sys.info()["sysname"]
  if (!user_os %in% names(whisper_paths_to_check)) {
    stop(whisper_path_missing, call. = FALSE)
  }

  whisper_path <- NULL
  for (path in whisper_paths_to_check[[user_os]]) {
    if (file.exists(path)) {
      whisper_path <- path
      break
    }
  }

  if (is.null(whisper_path)) {
    stop(whisper_path_missing, call. = FALSE)
  }

  whisper_path
}

# Returns the path to the directory that contains "whisper"
process_whisper_path <- function(path) {
  gsub("/whisper$", "", path)
}


# List obj containing known locations of "whisper"
whisper_paths_to_check <- list(
  "Linux" = c("/usr/bin/tts",
              "/usr/local/bin/tts"),
  "Darwin" = c("/opt/homebrew/Caskroom/miniforge/base/bin/tts"),
  "Windows" = c("C:\\Program Files\\tts")
)

# Error message thrown if coqui "tts" cannot be found
whisper_path_missing <- paste(
  "Whisper required for robust Speech-to-Text generation.",
  "Cannot determine file path to whisper",
  "To download whisper, visit: https://github.com/openai/whisper#setup \n",
  "If you've already downloaded the software, use function",
  "'set_whisper_path(path = \"your/path/to/whisper\")' to point R to your local whisper Executable File"
)
