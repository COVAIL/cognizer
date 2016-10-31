
context("Checking audio processing functions")


userpwd <- Sys.getenv("SPEECH_TO_TEXT_USERNAME_PASSWORD")
audio_path <- system.file("extdata/audio", package = "cognizer")
audios <- list.files(audio_path, full.names = TRUE)
test_that(
  "image classifications returns successfully",
  {
    if (identical(userpwd, "")) skip("no authentication provided")
    test <- audio_text(audios, userpwd)
    expect_is(test, "list")
  }
)

test_that(
  "image classification handles errors properly",
  {
    if (identical(userpwd, "")) skip("no authentication provided")
    test <- audio_text(audios, substr(userpwd, 1, 10))
    expect_is(test, "list")
  }
)

