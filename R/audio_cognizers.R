
#' @title IBM Watson Audio Transcriber
#' @description Convert your audio to transcripts with optional keyword
#'   detection and profanity cleaning.
#' @param audios Character vector (list) of paths to images or to .zip files containing
#'   upto 100 images.
#' @param userpwd Character scalar containing username:password for the service.
#' @param keep_data Character scalar specifying whether to share your data with
#'   Watson services for the purpose of training their models.
#' @param callback Function that can be applied to responses to examine http status,
#'   headers, and content, to debug or to write a custom parser for content.
#'   The default callback parses content into a data.frame while dropping other
#'   response values to make the output easily passable to tidyverse packages like
#'   dplyr or ggplot2. For further details or debugging one can pass a print or a
#'   more compicated function.
#' @param model Character scalar specifying language and bandwidth model. Alternatives
#'   are ar-AR_BroadbandModel, en-UK_BroadbandModel, en-UK_NarrowbandModel,
#'   en-US_NarrowbandModel, es-ES_BroadbandModel, es-ES_NarrowbandModel,
#'   fr-FR_BroadbandModel, ja-JP_BroadbandModel, ja-JP_NarrowbandModel,
#'   pt-BR_BroadbandModel, pt-BR_NarrowbandModel, zh-CN_BroadbandModel,
#'   zh-CN_NarrowbandModel.
#' @param continuous Logical scalar specifying whether to return after a first
#'   end-of-speech incident (long pause) or to wait to combine results.
#' @param inactivity_timeout Integer scalar giving the number of seconds after which
#'   the result is returned if no speech is detected.
#' @param keywords List of keywords to be detected in the speech stream.
#' @param keywords_threshold Double scalar from 0 to 1 specifying the lower bound on
#'   confidence to accept detected keywords in speech.
#' @param max_alternatives Integer scalar giving the maximum number of alternative
#'   transcripts to return.
#' @param word_alternatives_threshold Double scalar from 0 to 1 giving lower bound
#'   on confidence of possible words.
#' @param word_confidence Logical scalar indicating whether to return confidence for
#'   each word.
#' @param timestamps Logical scalar indicating whether to return time alignment for
#'   each word.
#' @param profanity_filter Logical scalar indicating whether to censor profane words.
#' @param smart_formatting Logical scalar indicating whether dates, times, numbers, etc.
#'   are to be formatted nicely in the transcript.
#' @param content_type Character scalar showing format of the audio file. Alternatives
#'   are audio/flac, audio/l16;rate=n;channels=k (16 channel limit),
#'   audio/wav (9 channel limit), audio/ogg;codecs=opus,
#'   audio/basic (narrowband models only).
#' @return List of parsed responses.
#' @export
audio_text <- function(
  audios,
  userpwd,
  keep_data = "true",
  callback = NULL,
  model = "en-US_BroadbandModel",
  continuous = FALSE,
  inactivity_timeout = 30,
  keywords = list(),
  keywords_threshold = NA,
  max_alternatives = 1,
  word_alternatives_threshold = NA,
  word_confidence = FALSE,
  timestamps = FALSE,
  profanity_filter = TRUE,
  smart_formatting = FALSE,
  content_type = "audio/wav")
{
  protocol <- "https://"
  service <- "stream.watsonplatform.net/speech-to-text/api/v1/recognize?"
  parameters <- paste("model", model, sep = "=")
  url <- paste0(protocol, service, parameters)
  metadata <- toJSON(
    auto_unbox = TRUE,
    list(
      "part_content_type" = content_type,
      "data_parts_count" = 1,
      "continuous" = continuous,
      "inactivity_timeout" = inactivity_timeout,
      "keywords" = keywords,
      "keywords_threshold" = keywords_threshold,
      "max_alternatives" = max_alternatives,
      "word_alternatives_threshold" = word_alternatives_threshold,
      "word_confidence" = word_confidence,
      "timestamps" = timestamps,
      "profanity_filter" = profanity_filter,
      "smart_formatting" = smart_formatting
    )
  )

  done <- if (is.null(callback))  function(resp, index) {
    txt <- rawToChar(resp$content)
    if (resp$status_code != 200) {
      error_msg <<- suppressWarnings(read_xml(txt, as_html = TRUE)) %>% 
        xml_child %>% 
        xml_text 
      cat(sprintf("Request %s failed: %s\n", index, error_msg))
      resps[[index]] <<- error_msg
      return(invisible(NULL))
    } 
    resps[[index]] <<- fromJSON(txt)
    invisible(NULL)
  } else callback
  fail <- function(resp, index) {
    cat(sprintf("Request %s failed: %s\n", index, resp))
    resps[[index]] <<- resp
  }

  resps <- vector("list", length(audios))
  invisible(
    lapply(
      seq_along(audios),
      function(index) {
        if (is.null(callback)) formals(done)$index <- index
        formals(fail)$index <- index
        form <- form_file(audios[index], content_type)
        new_handle(url = url) %>%
          handle_setopt("userpwd" = userpwd) %>%
          handle_setheaders(
            "X-Watson-Learning-Opt-Out"= keep_data,
            "Content-Type" = "multipart/form-data",
            "Transfer-Encoding" = "chunked"
          ) %>%
          handle_setform(metadata = metadata, upload = form) %>%
          multi_add(done = done, fail = fail)
      }
    )
  )

  multi_run()
  resps
}
