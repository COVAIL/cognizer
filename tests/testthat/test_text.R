
context("Checking text processing functions")


api_key <- Sys.getenv("ALCHEMY_API_KEY")
text_path <- system.file(
  "extdata/text",
  "text_examples.txt",
  package = "cognizer"
)
text <- readLines(text_path)
test_that(
  "sentiment analysis returns successfully",
  {
  if (identical(api_key, "")) skip("no authentication provided")
  test <- text_sentiment(text, api_key)
  expect_is(test, "list")
  }
)

test_that(
  "keyword analysis returns successfully",
  {
    if (identical(api_key, "")) skip("no authentication provided")
    test <- text_keywords(text, api_key)
    expect_is(test, "list")
  }
)

test_that(
  "emotion analysis returns successfully",
  {
    if (identical(api_key, "")) skip("no authentication provided")
    test <- text_emotion(text, api_key)
    expect_is(test, "list")
  }
)


test_that(
  "language detection returns successfully",
  {
    if (identical(api_key, "")) skip("no authentication provided")
    test <- text_language(text, api_key)
    expect_is(test, "list")
  }
)


test_that(
  "entity extraction returns successfully",
  {
    if (identical(api_key, "")) skip("no authentication provided")
    test <- text_entity(text, api_key)
    expect_is(test, "list")
  }
)


test_that(
  "concept extraction returns successfully",
  {
    if (identical(api_key, "")) skip("no authentication provided")
    test <- text_concept(text, api_key)
    expect_is(test, "list")
  }
)


userpwd <- Sys.getenv("LANG_TRANSLATE_USERNAME_PASSWORD")
text <- "hola amigo"
test_that(
  "language translation returns successfully",
  {
    if (identical(userpwd, "")) skip("no authentication provided")
    test <- text_translate(text, userpwd)
    expect_is(test, "list")
  }
)

userpwd <- Sys.getenv("PERSONALITY_USERNAME_PASSWORD")
text <- paste(replicate(1000, rmsfact::rmsfact()), collapse = ' ')
test_that(
  "personality insight returns successfully",
  {
    if (identical(userpwd, "")) skip("no authentication provided")
    test <- text_personality(text, userpwd)
    expect_is(test, "list")
  }
)


userpwd <- Sys.getenv("TONE_USERNAME_PASSWORD")
test_that(
  "tone analyzer returns successfully",
  {
    if (identical(userpwd, "")) skip("no authentication provided")
    test <- text_tone(text, userpwd)
    expect_is(test, "list")
  }
)


userpwd <- Sys.getenv("TEXT_TO_SPEECH_USERNAME_PASSWORD")
text <- "hello world"
test_that(
  "text to speech synthesizer returns successfully",
  {
    if (identical(userpwd, "")) skip("no authentication provided")
    tmp <- tempdir()
    on.exit(unlink(tmp))
    test <- text_audio(text, userpwd, directory = tmp)
  }
)
