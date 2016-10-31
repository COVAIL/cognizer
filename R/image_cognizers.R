

#' @title IBM Watson Image Classifier
#' @description \bold{image_classify}: Uses default classifier to determine the object
#'   catagory in the image.
#' @param images Character vector (list) of paths to images or to .zip files containing
#'   upto 100 images.
#' @param api_key Character scalar containing api key obtained from Watson services.
#' @param keep_data Character scalar specifying whether to share your data with
#'   Watson services for the purpose of training their models.
#' @param callback Function that can be applied to responses to examine http status,
#'   headers, and content, to debug or to write a custom parser for content.
#'   The default callback parses content into a data.frame while dropping other
#'   response values to make the output easily passable to tidyverse packages like
#'   dplyr or ggplot2. For further details or debugging one can pass a fail or a
#'   more compicated function.
#' @param type Character scalar specifying image format. Alternative is "image/png".
#' @param version Character scalar giving version of api to use.
#' @param accept_language Character scalar specifying the output language.
#' @param batch_size Integer scalar giving the number of images in a given path. This
#'   is used when images are zipped together. Check IBM docs for maximum number in a
#'   single zip file.
#' @return List of parsed responses.
#' @export
image_classify <- function(
  images,
  api_key,
  keep_data = "true",
  callback = NULL,
  type = "image/jpeg",
  version = "2016-05-20",
  accept_language = "en",
  batch_size = 1
)
{
  protocol <- "https://"
  service <- "gateway-a.watsonplatform.net/visual-recognition/api/v3/classify?"
  parameters <- paste(
    c("api_key", "version"),
    c(api_key, version),
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

  resps <- vector("list", length(images))
  invisible(
    lapply(
      seq_along(images),
      function(index) {
        if (is.null(callback)) formals(done)$index <- index
        formals(fail)$index <- index
        form <- form_file(images[index], type)
        new_handle(url = url) %>%
          handle_setheaders(
            "X-Watson-Learning-Opt-Out"= keep_data,
            "Accept-Language" = accept_language
          ) %>%
          handle_setform(image_file = form) %>%
          multi_add(done = done, fail = fail)
      }
    )
  )

  multi_run()
  resps
}



#' @title IBM Watson Face Detection Algorithm
#' @description \bold{image_detectface}: Uses default algorithm to detect
#'   a face in the image and provide its coordinates.
#' @inheritParams image_classify
#' @return List of parsed responses.
#' @export
#' @rdname image_classify
image_detectface <- function(
  images,
  api_key,
  keep_data = "true",
  callback = NULL,
  type = "image/jpeg",
  version = "2016-05-20",
  batch_size = 1
)
{
  protocol <- "https://"
  service <- "gateway-a.watsonplatform.net/visual-recognition/api/v3/detect_faces?"
  parameters <- paste(
    c("api_key", "version"),
    c(api_key, version),
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
  
  resps <- vector("list", length(images))
  invisible(
    lapply(
      seq_along(images),
      function(index) {
        if (is.null(callback)) formals(done)$index <- index
        formals(fail)$index <- index
        form <- form_file(images[index], type)
        new_handle(url = url) %>%
          handle_setheaders("X-Watson-Learning-Opt-Out"= keep_data) %>%
          handle_setform(images_file = form) %>%
          multi_add(done = done, fail = fail)
      }
    )
  )

  multi_run()
  resps
}


#' @title IBM Watson Text-in-image Detection Algorithm
#' @description \bold{image_detecttext}: Uses default algorithm to detect
#'   text in the image.
#' @inheritParams image_classify
#' @return List of parsed responses.
#' @export
#' @rdname image_classify
image_detecttext <- function(
  images,
  api_key,
  keep_data = "true",
  callback = NULL,
  type = "image/jpeg",
  version = "2016-05-20",
  batch_size = 1
)
{
  protocol <- "https://"
  service <- "gateway-a.watsonplatform.net/visual-recognition/api/v3/recognize_text?"
  parameters <- paste(
    c("api_key", "version"),
    c(api_key, version),
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
  
  resps <- vector("list", length(images))
  invisible(
    lapply(
      seq_along(images),
      function(index) {
        if (is.null(callback)) formals(done)$index <- index
        formals(fail)$index <- index
        form <- form_file(images[index], type)
        new_handle(url = url) %>%
          handle_setheaders("X-Watson-Learning-Opt-Out"= keep_data) %>%
          handle_setform(images_file = form) %>%
          multi_add(done = done, fail = fail)
      }
    )
  )

  multi_run()
  resps
}
