
#' @title Process text with IBM Alchemy Language algorithms
#' @description \bold{text_sentiment}: Takes a vector of text and sends to Watson
#' services for various analyses. Requires basic authentication using api key.
#' @param text Character vector containing strings to be processed.
#' @param api_key Character scalar containing api key obtained from Watson services.
#' @param output_mode Character scalar specifying returned data structure.
#'   Alternative is xml.
#' @param show_source Intenger scalar specifying whether to send text
#'   string back or not.
#' @param keep_data Character scalar specifying whether to share your data with
#'   Watson services for the purpose of training their models.
#' @param callback Function that can be applied to responses to examine http status,
#'   headers, and content, to debug or to write a custom parser for content.
#'   The default callback parses content into a data.frame while dropping other
#'   response values to make the output easily passable to tidyverse packages like
#'   dplyr or ggplot2. For further details or debugging one can pass a fail or a
#'   more compicated function.
#' @return Data.frame containing parsed content in a tidy fashion.
#' @seealso Check \url{http://www.ibm.com/watson/developercloud/alchemy-language.html}
#'   for further documentation, and \url{https://alchemy-language-demo.mybluemix.net/?cm_mc_uid=70865809903714586773519&cm_mc_sid_50200000=1468266111}
#'   for a web demo.
#' @export
#' @importFrom magrittr '%>%'
#' @importFrom curl new_handle handle_setheaders handle_setopt handle_setform
#' @importFrom curl curl_escape multi_add multi_run form_file curl_download
text_sentiment <- function(
  text,
  api_key,
  output_mode = "json",
  show_source = 0,
  keep_data = "true",
  callback = NULL
) 
{  
  protocol <- "https://"
  service <- "gateway-a.watsonplatform.net/calls/text/TextGetTextSentiment?"
  parameters <- paste(
    c("apikey", "outputMode", "showSourceText"),
    c(api_key, output_mode, show_source),
    sep = "=",
    collapse = "&"
  )
  url <- paste0(protocol, service, parameters)
  text <- paste("text", curl_escape(text), sep = "=")
  
  done <- if (is.null(callback)) function(resp, index) {
    resps[[index]] <<- fromJSON(rawToChar(resp$content))
    invisible(NULL)
  } else callback
  fail <- function(resp, index) {
    resps[[index]] <<- resp
    invisible(NULL)
  }
  
  resps <- vector("list", length(text))
  invisible( 
    lapply( 
      seq_along(text),
      function(index) {
        if (is.null(callback)) formals(done)$index <- index
        formals(fail)$index <- index
        new_handle(url = url) %>%
          handle_setheaders("X-Watson-Learning-Opt-Out"= keep_data) %>%
          handle_setopt(postfields = text[index]) %>% 
          multi_add(done = done, fail = fail)
      } 
    )
  ) 

  multi_run()
  resps
}


#' @description \bold{text_keywords}: Keywords analysis extracts keywords from text, and
#'   can optionally provide their sentiment and/or associated knowledge graph.
#' @inheritParams text_sentiment
#' @param max_retrieve Integer scalar fixing the number of keywords to extract
#'   from text.
#' @param knowledge_graph Integer scalar indicating whether to grab a knowledge
#'   graph associated with keywords. This is an additional transaction.
#' @param sentiment Integer scalar indicating whether to infer sentiment of
#'   keywords, expressed as category and number. This is an additional transaction.
#' @export
#' @rdname text_sentiment
text_keywords <- function(
  text,
  api_key,
  output_mode = "json",
  show_source = 0,
  keep_data = "true",
  callback = NULL,
  max_retrieve = 50,
  knowledge_graph = 0,
  sentiment = 0
)
{
  protocol <- "https://"
  service <- "gateway-a.watsonplatform.net/calls/text/TextGetRankedKeywords?"
  parameters <- paste(
    c("apikey", "outputMode", "showSourceText",
      "maxRetrieve", "knowledgeGraph", "sentiment"),
    c(api_key, output_mode, show_source,
      max_retrieve, knowledge_graph, sentiment),
    sep = "=",
    collapse = "&"
  )
  url <- paste0(protocol, service, parameters)
  text <- paste("text", curl_escape(text), sep = "=")
  
  done <- if (is.null(callback)) function(resp, index) {
    resps[[index]] <<- fromJSON(rawToChar(resp$content))
    invisible(NULL)
  } else callback
  fail <- function(resp, index) {
    resps[[index]] <<- resp
    invisible(NULL)
  }
  
  resps <- vector("list", length(text))
  invisible( 
    lapply( 
      seq_along(text),
      function(index) {
        if (is.null(callback)) formals(done)$index <- index
        formals(fail)$index <- index
        new_handle(url = url) %>%
          handle_setheaders("X-Watson-Learning-Opt-Out"= keep_data) %>%
          handle_setopt(postfields = text[index]) %>% 
          multi_add(done = done, fail = fail)
      } 
    )
  ) 
  
  multi_run()
  resps
}


#' @description \bold{text_emotion}: Emotion analysis of text infers
#'   scores for 7 basic emotions.
#' @inheritParams text_sentiment
#' @export
#' @rdname text_sentiment
text_emotion <- function(
  text,
  api_key,
  output_mode = "json",
  show_source = 0,
  keep_data = "true",
  callback = NULL
)
{
  protocol <- "https://"
  service <- "gateway-a.watsonplatform.net/calls/text/TextGetEmotion?"
  parameters <- paste(
    c("apikey", "outputMode", "showSourceText"),
    c(api_key, output_mode, show_source),
    sep = "=",
    collapse = "&"
  )
  url <- paste0(protocol, service, parameters)
  text <- paste("text", curl_escape(text), sep = "=")
  
  done <- if (is.null(callback)) function(resp, index) {
    resps[[index]] <<- fromJSON(rawToChar(resp$content))
    invisible(NULL)
  } else callback
  fail <- function(resp, index) {
    resps[[index]] <<- resp
    invisible(NULL)
  }
  
  resps <- vector("list", length(text))
  invisible( 
    lapply( 
      seq_along(text),
      function(index) {
        if (is.null(callback)) formals(done)$index <- index
        formals(fail)$index <- index
        new_handle(url = url) %>%
          handle_setheaders("X-Watson-Learning-Opt-Out"= keep_data) %>%
          handle_setopt(postfields = text[index]) %>% 
          multi_add(done = done, fail = fail)
      } 
    )
  ) 
  
  multi_run()
  resps
}


#' @description \bold{text_language}: Language detection infers
#'   language of the provided text. Works best with at least 100 words.
#' @inheritParams text_sentiment
#' @export
#' @rdname text_sentiment
text_language <- function(
  text,
  api_key,
  output_mode = "json",
  show_source = 0,
  keep_data = "true",
  callback = NULL
)
{
  protocol <- "https://"
  service <- "gateway-a.watsonplatform.net/calls/text/TextGetLanguage?"
  parameters <- paste(
    c("apikey", "outputMode", "showSourceText"),
    c(api_key, output_mode, show_source),
    sep = "=",
    collapse = "&"
  )
  url <- paste0(protocol, service, parameters)
  text <- paste("text", curl_escape(text), sep = "=")
  
  done <- if (is.null(callback)) function(resp, index) {
    resps[[index]] <<- fromJSON(rawToChar(resp$content))
    invisible(NULL)
  } else callback
  fail <- function(resp, index) {
    resps[[index]] <<- resp
    invisible(NULL)
  }
  
  resps <- vector("list", length(text))
  invisible( 
    lapply( 
      seq_along(text),
      function(index) {
        if (is.null(callback)) formals(done)$index <- index
        formals(fail)$index <- index
        new_handle(url = url) %>%
          handle_setheaders("X-Watson-Learning-Opt-Out"= keep_data) %>%
          handle_setopt(postfields = text[index]) %>% 
          multi_add(done = done, fail = fail)
      } 
    )
  ) 
  
  multi_run()
  resps
}


#' @description \bold{text_entity}: Entity analysis extracts names of people,
#'   products, places from the provided text. Additional arguments can provide
#'   sentiment, knowledge graphs and quotations related to inferred entities.
#' @inheritParams text_keywords
#' @param model Character scalar specifying one of three models which will extract
#'   entities. Alternatives are 'ie-es-news',  'ie-ar-news' or a custom model.
#' @param coreference Integer scalar specifying whether to resolve coreferences into
#'   detected entities.
#' @param disambiguate Integer scalar specifying whether to disambiguate
#'   detected entities.
#' @param linked_data Integer scalar specifying whether to include links for
#'   related data.
#' @param quotations Integer scalar specifying whether to include quotes related
#'   to detected entities.
#' @param structured_entity Integer scalar specifying whether to extract structured
#'   entities, such as Quantity, EmailAddress, TwitterHandle, Hashtag, and IPAddress.
#' @export
#' @rdname text_sentiment
text_entity <- function(
  text,
  api_key,
  output_mode = "json",
  show_source = 0,
  keep_data = "true",
  callback = NULL,
  max_retrieve = 50,
  knowledge_graph = 0,
  sentiment = 0,
  model = "ie-en-news",
  coreference = 1,
  disambiguate = 1,
  linked_data = 1,
  quotations = 0,
  structured_entity = 1
)
{
  protocol <- "https://"
  service <- "gateway-a.watsonplatform.net/calls/text/TextGetRankedNamedEntities?"
  parameters <- paste(
    c("apikey", "outputMode", "showSourceText", "maxRetrieve", "knowledgeGraph",
      "sentiment", "model", "coreference", "disambiguate", "linkedData",
      "quotations", "structuredEntities"),
    c(api_key, output_mode, show_source, max_retrieve, knowledge_graph, sentiment,
      model, coreference, disambiguate, linked_data, quotations, structured_entity),
    sep = "=",
    collapse = "&"
  )
  url <- paste0(protocol, service, parameters)
  text <- paste("text", curl_escape(text), sep = "=")
  
  done <- if (is.null(callback)) function(resp, index) {
    resps[[index]] <<- fromJSON(rawToChar(resp$content))
    invisible(NULL)
  } else callback
  fail <- function(resp, index) {
    resps[[index]] <<- resp
    invisible(NULL)
  }
  
  resps <- vector("list", length(text))
  invisible( 
    lapply( 
      seq_along(text),
      function(index) {
        if (is.null(callback)) formals(done)$index <- index
        formals(fail)$index <- index
        new_handle(url = url) %>%
          handle_setheaders("X-Watson-Learning-Opt-Out"= keep_data) %>%
          handle_setopt(postfields = text[index]) %>% 
          multi_add(done = done, fail = fail)
      } 
    )
  ) 
  
  multi_run()
  resps
}

#' @description \bold{text_concept}: Concept analysis infers categories based on
#'  the text, but that are not necessarily in the text. Additional arguments can
#'   provide sentiment and/or knowledge graphs related to inferred concepts.
#' @inheritParams text_entity
#' @rdname text_sentiment
#' @export
text_concept <- function(
  text,
  api_key,
  output_mode = "json",
  show_source = 0,
  keep_data = "true",
  callback = NULL,
  max_retrieve = 8,
  knowledge_graph = 0,
  linked_data = 1
)
{
  protocol <- "https://"
  service <- "gateway-a.watsonplatform.net/calls/text/TextGetRankedConcepts?"
  parameters <- paste(
    c("apikey", "outputMode", "showSourceText",
      "maxRetrieve", "knowledgeGraph", "linkedData"),
    c(api_key, output_mode, show_source,
      max_retrieve, knowledge_graph, linked_data),
    sep = "=",
    collapse = "&"
  )
  url <- paste0(protocol, service, parameters)
  text <- paste("text", curl_escape(text), sep = "=")
  
  done <- if (is.null(callback)) function(resp, index) {
    resps[[index]] <<- fromJSON(rawToChar(resp$content))
    invisible(NULL)
  } else callback
  fail <- function(resp, index) {
    resps[[index]] <<- resp
    invisible(NULL)
  }
  
  resps <- vector("list", length(text))
  invisible( 
    lapply( 
      seq_along(text),
      function(index) {
        if (is.null(callback)) formals(done)$index <- index
        formals(fail)$index <- index
        new_handle(url = url) %>%
          handle_setheaders("X-Watson-Learning-Opt-Out"= keep_data) %>%
          handle_setopt(postfields = text[index]) %>% 
          multi_add(done = done, fail = fail)
      } 
    )
  ) 
  
  multi_run()
  resps
}


#' @description \bold{text_relations}: Relation analysis infers associations among
#'   entities.
#' @inheritParams text_entity
#' @export
#' @rdname text_sentiment
text_relations <- function(
  text,
  api_key,
  output_mode = "json",
  show_source = 0,
  keep_data = "true",
  callback = NULL,
  model = "ie-en-news"
)
{
  protocol <- "https://"
  service <- "gateway-a.watsonplatform.net/calls/text/TextGetRankedConcepts?"
  parameters <- paste(
    c("apikey", "outputMode", "showSourceText", "model"),
    c(api_key, output_mode, show_source, model),
    sep = "=",
    collapse = "&"
  )
  url <- paste0(protocol, service, parameters)
  text <- paste("text", curl_escape(text), sep = "=")
  
  done <- if (is.null(callback)) function(resp, index) {
    resps[[index]] <<- fromJSON(rawToChar(resp$content))
    invisible(NULL)
  } else callback
  fail <- function(resp, index) {
    resps[[index]] <<- resp
    invisible(NULL)
  }
  
  resps <- vector("list", length(text))
  invisible( 
    lapply( 
      seq_along(text),
      function(index) {
        if (is.null(callback)) formals(done)$index <- index
        formals(fail)$index <- index
        new_handle(url = url) %>%
          handle_setheaders("X-Watson-Learning-Opt-Out"= keep_data) %>%
          handle_setopt(postfields = text[index]) %>% 
          multi_add(done = done, fail = fail)
      } 
    )
  ) 
  
  multi_run()
  resps
}


#' @description \bold{text_taxonomy}: Taxonomy analysis infers hierarchical relations
#'   among entities upto 5 levels deep.
#' @inheritParams text_entity
#' @export
#' @rdname text_sentiment
text_taxonomy <- function(
  text,
  api_key,
  output_mode = "json",
  show_source = 0,
  keep_data = "true",
  callback = NULL,
  max_retrieve = 50,
  knowledge_graph = 0,
  sentiment = 0,
  model = "ie-en-news",
  coreference = 1,
  disambiguate = 1,
  linked_data = 1,
  quotations = 0,
  structured_entity = 1
)
{
  protocol <- "https://"
  service <- "gateway-a.watsonplatform.net/calls/text/TextGetRankedTaxonomy?"
  parameters <- paste(
    c("apikey", "outputMode", "showSourceText", "maxRetrieve", "knowledgeGraph",
      "sentiment", "model", "coreference", "disambiguate", "linkedData",
      "quotations", "structuredEntities"),
    c(api_key, output_mode, show_source, max_retrieve, knowledge_graph, sentiment,
      model, coreference, disambiguate, linked_data, quotations, structured_entity),
    sep = "=",
    collapse = "&"
  )
  url <- paste0(protocol, service, parameters)
  text <- paste("text", curl_escape(text), sep = "=")
  
  done <- if (is.null(callback)) function(resp, index) {
    resps[[index]] <<- fromJSON(rawToChar(resp$content))
    invisible(NULL)
  } else callback
  fail <- function(resp, index) {
    resps[[index]] <<- resp
    invisible(NULL)
  }
  
  resps <- vector("list", length(text))
  invisible( 
    lapply( 
      seq_along(text),
      function(index) {
        if (is.null(callback)) formals(done)$index <- index
        formals(fail)$index <- index
        new_handle(url = url) %>%
          handle_setheaders("X-Watson-Learning-Opt-Out"= keep_data) %>%
          handle_setopt(postfields = text[index]) %>% 
          multi_add(done = done, fail = fail)
      } 
    )
  ) 
  
  multi_run()
  resps
}

#' @title IBM Language Translation API.
#' @description Translates text from Arabic, French,
#'   Portuguese or Spanish to English. Requires basic authentication using
#'   username and password.
#' @param text Character vector.
#' @param userpwd Character scalar that contains 'username:password' string.
#' @param model_id Character scalar formated as 'source-target-domain'.
#'   Source language (Arabic, Brazilian Portuguese, English, French, Italian,
#'   or Spanish), target language (Arabic, Brazilian Portuguese, English, French,
#'   Italian, or Spanish) and domain of text (conversational, news, patent).
#'   Check IBM documentation for other language mappings.
#' @param accept Character scalar that specifies response format. Alternative is
#'   text/plain.
#' @param keep_data Character scalar specifying whether to share your data with
#'   Watson services for the purpose of training their models.
#' @param callback Function that can be applied to responses to examine http status,
#'   headers, and content, to debug or to write a custom parser for content.
#'   The default callback parses content into a data.frame while dropping other
#'   response values to make the output easily passable to tidyverse packages like
#'   dplyr or ggplot2. For further details or debugging one can pass a fail or a
#'   more compicated function.
#' @return Data.frame containing parsed content in a tidy fashion.
#' @seealso Check \url{http://www.ibm.com/watson/developercloud/language-translation.html}
#'   for further documentation, and \url{https://language-translator-demo.mybluemix.net/}
#'   for a web demo.
#' @export
text_translate <- function(
  text,
  userpwd,
  keep_data = "true",
  callback = NULL,
  model_id = "es-en-conversational",
  accept = "application/json"
)
{
  protocol <- "https://"
  service <- "gateway.watsonplatform.net/language-translator/api/v2/translate?"
  parameters <- paste("model_id", model_id, sep = "=")
  url <- paste0(protocol, service, parameters)
  text <- paste("text", curl_escape(text), sep = "=")
  
  done <- if (is.null(callback)) function(resp, index) {
    resps[[index]] <<- fromJSON(rawToChar(resp$content))
    invisible(NULL)
  } else callback
  fail <- function(resp, index) {
    resps[[index]] <<- resp
    invisible(NULL)
  }
  
  resps <- vector("list", length(text))
  invisible(
    lapply(
      seq_along(text),
      function(index) {
        if (is.null(callback)) formals(done)$index <- index
        formals(fail)$index <- index
        new_handle(url = url) %>%
          handle_setopt("userpwd" = userpwd, "postfields" = text[index]) %>%
          handle_setheaders(
            "X-Watson-Learning-Opt-Out"= keep_data,
            "Accept" = accept
          ) %>%
          multi_add(done = done, fail = fail)
      }
    )
  )

  multi_run()
  resps
}

#' @title IBM personality analysis of text
#' @description Analyze your text along the Big 5 dimensions of personality.
#' @inheritParams text_translate
#' @param raw_scores Character scalar showing whether to include only normalized
#'   statistics or also raw statistics.
#' @param consumption_preferences Character scalar showing whether to 
#'   return consumption preferences
#' @param csv_headers Character scalar showing whether to return column labels when
#'   Accept-Content is set to 'text/csv'.
#' @param version Character scalar giving date that specifies the algorithm that went
#'   operational on or before the date. Future dates select the most recent algorithm.
#' @param content_type Character scalar setting input data type header. Alternatives
#'   are 'application/json; charset=utf-8' and 'text/html; charset=ISO-8859-1'.
#' @param content_language Character scalar setting input language. Alternatives are
#'   'ar' (Arabic), 'es' (Spanish), 'ja' (Japanese).
#' @param accept_language Character scalar setting output langauge. Alternatives are
#'   'ar' (Arabic), 'de' (German), 'es' (Spanish), 'fr' (French), 'it' (Italian),
#'   'ja' (Japanese), 'ko' (Korean), 'pt-br' (Brazilian Portuguese),
#'   'zh-cn' (Simplified Chinese), 'zh-tw' (Traditional Chinese).
#' @return List containing parsed content.
#' @seealso Check \url{http://www.ibm.com/watson/developercloud/doc/personality-insights/}
#'   for further documentation, and \url{https://personality-insights-livedemo.mybluemix.net/}
#'   for a web demo.
#' @export
text_personality <- function(
  text,
  userpwd,
  keep_data = "true",
  callback = NULL,
  model_id = "es-en-conversational",
  raw_scores = "false",
  consumption_preferences = "false",
  csv_headers = "false",
  version = "2020-01-01",
  content_type = "text/plain; charset=utf-8",
  content_language = "en",
  accept = "application/json",
  accept_language = "en"
)
{
  protocol <- "https://"
  service <- "gateway.watsonplatform.net/personality-insights/api/v3/profile?"
  parameters <- paste(
    c("model_id", "raw_scores", "csv_headers"),
    c(model_id, raw_scores, csv_headers),
    sep = "=",
    collapse = "&"
  )
  url <- paste0(protocol, service, parameters)

  done <- if (is.null(callback)) function(resp, index) {
    resps[[index]] <<- fromJSON(rawToChar(resp$content))
    invisible(NULL)
  } else callback
  fail <- function(resp, index) {
    resps[[index]] <<- resp
    invisible(NULL)
  }
  
  resps <- vector("list", length(text))
  invisible(
    lapply(
      seq_along(text),
      function(index) {
        if (is.null(callback)) formals(done)$index <- index
        formals(fail)$index <- index
        new_handle(url = url) %>%
          handle_setopt("userpwd" = userpwd, "postfields" = text[index]) %>%
          handle_setheaders(
            "X-Watson-Learning-Opt-Out"= keep_data,
            "Content-Type" = content_type,
            "Content-Language" = content_language,
            "Accept" = accept,
            "Accept-Language" = accept_language
          ) %>%
          multi_add(done = done, fail = fail)
      }
    )
  )

  multi_run()
  resps
}



#' @title IBM Tone Analyzer of Text
#' @description Infers three types of tone - emotion, language, social - from the
#'   whole text or at sentense level.
#' @inheritParams text_translate
#' @param content_type Characte scalar specifying the HTTP header with type of text
#'   and its encoding.
#' @param version Character scalar that specifies the data of most recent version of
#'   the algorithm.
#' @param tones Character scalar that allows selecting one the three possible tones:
#'   emotion, language, social.
#' @param sentences Character scalar specifying whether to do analysis at the
#'   sentence level.
#' @return Data.frame containing parsed content in a tidy fashion.
#' @seealso Check \url{http://www.ibm.com/watson/developercloud/doc/tone-analyzer/}
#'   for further documentation, and \url{https://tone-analyzer-demo.mybluemix.net/?cm_mc_uid=70865809903714586773519&cm_mc_sid_50200000=1468424667}
#'   for a web demo.
#' @export
text_tone <- function(
  text,
  userpwd,
  keep_data = "true",
  callback = NULL,
  content_type = "text/plain; charset=utf-8",
  version = "2016-05-19",
  tones = "",
  sentences = "true"
)
{
  protocol <- "https://"
  service <- "gateway.watsonplatform.net/tone-analyzer/api/v3/tone?"
  parameters <- paste(
    c("version", "tones", "sentences"),
    c(version, tones, sentences),
    sep = "=",
    collapse = "&"
  )
  url <- paste0(protocol, service, parameters)

  done <- if (is.null(callback)) function(resp, index) {
    resps[[index]] <<- fromJSON(rawToChar(resp$content))
    invisible(NULL)
  } else callback
  fail <- function(resp, index) {
    resps[[index]] <<- resp
    invisible(NULL)
  }
  
  resps <- vector("list", length(text))
  invisible(
    lapply(
      seq_along(text),
      function(index) {
        if (is.null(callback)) formals(done)$index <- index
        formals(fail)$index <- index
        new_handle(url = url) %>%
          handle_setopt("userpwd" = userpwd, "postfields" = text[index]) %>%
          handle_setheaders(
            "X-Watson-Learning-Opt-Out"= keep_data,
            "Content-Type" = content_type
          ) %>%
          multi_add(done = done, fail = fail)
      }
    )
  )

  multi_run()
  resps
}




#' @title IBM Text-to-speech API.
#' @description Synthesizes an audio record from text.
#' @inheritParams text_sentiment
#' @param userpwd Character scalar that contains 'username:password' string.
#' @param directory Character scalar specifying directory for storing audio files.
#' @param voice Character scalar setting language and voice model for the synthesized
#'   voice. Many models are available: de-DE_BirgitVoice, de-DE_DieterVoice,
#'   en-GB_KateVoice, en-US_LisaVoice, en-US_MichaelVoice, es-ES_EnriqueVoice,
#'   es-ES_LauraVoice, es-US_SofiaVoice, fr-FR_ReneeVoice, it-IT_FrancescaVoice,
#'   ja-JP_EmiVoice, pt-BR_IsabelaVoice.
#' @param accept Characte scalar specifying format for the audio. Alternatives are
#'   audio/wav ,audio/flac, audio/l16, audio/basic.
#' @return Audio file with selected format is saved into selected directory. The name
#'   is based on integer representation of UTF time and a number of characters of the
#'   processed text.
#' @return Logical scalar is returned invisibly.
#' @seealso Check \url{http://www.ibm.com/watson/developercloud/text-to-speech.html}
#'   for further documentation, and \url{https://text-to-speech-demo.mybluemix.net/}
#'   for a web demo.
#' @export
text_audio <- function(
  text,
  userpwd,
  keep_data = "true",
  directory,
  voice = "en-US_AllisonVoice",
  accept = "audio/ogg;codecs=opus"
)
{
  protocol <- "https://"
  service <- "stream.watsonplatform.net/text-to-speech/api/v1/synthesize?"
  parameters <- paste("voice", voice, sep = "=", collapse = "&")
  url <- paste0(protocol, service, parameters)

  format <- substr(accept, 7, 9)
  invisible(
    lapply(
      seq_along(text),
      function(index) {
        file_name <- paste0(index, ".", format)
        path <- file.path(directory, file_name)
        handle <- new_handle(url = url) %>%
          handle_setopt(
            "userpwd" = userpwd,
            "postfields" = toJSON(list(text = text[index]), auto_unbox = TRUE),
            "failonerror" = 0
          ) %>%
          handle_setheaders(
            "X-Watson-Learning-Opt-Out"= keep_data,
            "Content-Type" = "application/json",
            "Accept" = accept
          )
          curl_download(url, path, handle = handle)
      }
    )
  )
  invisible(TRUE)
}

