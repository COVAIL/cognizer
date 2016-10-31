
context("Checking image processing functions")


api_key <- Sys.getenv("IMAGE_API_KEY")
image_face_path <- system.file("extdata/images_faces", package = "cognizer")
images <- list.files(image_face_path, full.names = TRUE)
test_that(
  "image classifications returns successfully",
  {
    if (identical(api_key, "")) skip("no authentication provided")
    test <- image_classify(images, api_key)
    expect_is(test, "list")
  }
)
test_that(
  "image classifications handles errors successfully",
  {
    if (identical(api_key, "")) skip("no authentication provided")
    test <- image_classify(images, substr(api_key, 1, 8))
    expect_is(test, "list")
  }
)


test_that(
  "image face detection returns successfully",
  {
    if (identical(api_key, "")) skip("no authentication provided")
    test <- image_detectface(images, api_key)
    expect_is(test, "list")
  }
)
test_that(
  "image face detection handles errors successfully",
  {
    if (identical(api_key, "")) skip("no authentication provided")
    test <- image_detectface(images, substr(api_key, 1, 8))
    expect_is(test, "list")
  }
)


image_text_path <- system.file("extdata/images_text", package = "cognizer")
images <- list.files(image_text_path, full.names = TRUE)
test_that(
  "image text detection returns successfully",
  {
    if (identical(api_key, "")) skip("no authentication provided")
    test <- image_detecttext(images, api_key)
    expect_is(test, "list")
  }
)
test_that(
  "image text detection handles errors successfully",
  {
    if (identical(api_key, "")) skip("no authentication provided")
    test <- image_detecttext(images, substr(api_key, 1, 8))
    expect_is(test, "list")
  }
)
