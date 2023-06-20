
<!-- README.md is generated from README.Rmd. Please edit that file -->

# audrey

<!-- badges: start -->
<!-- badges: end -->

audrey serves as a client to [OpenAI
Whisper](https://github.com/openai/whisper), a general-purpose speech
recognition model.

## Installation

You can install the development version of audrey from
[GitHub](https://github.com/) with:

``` r
# install.packages("devtools")
devtools::install_github("howardbaek/audrey")
```

## Usage

### `transcribe()`

Convert the input audio file into written text using speech recognition,
while preserving the language of the original audio:

``` r
transcribe("sample-english.mp3", output_dir = ".")
```

### `translate()`

Provide an English translation of the input audio file that is
originally spoken in a non-English language:

``` r
# Korean to English
translate("sample-korean.mp3", audio_lang = "Korean", output_dir = ".")
```

## Acknowledgements

- OpenAI Whisper model
- Source of audio files: <https://commonvoice.mozilla.org/en/datasets>
