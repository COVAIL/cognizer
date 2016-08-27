cognizer
================

[![Build Status](https://travis-ci.org/ColumbusCollaboratory/cognizer.svg?branch=master)](https://travis-ci.org/ColumbusCollaboratory/cognizer)
[![AppVeyor Build Status](https://ci.appveyor.com/api/projects/status/github/ColumbusCollaboratory/cognizer?branch=master&svg=true)](https://ci.appveyor.com/project/ColumbusCollaboratory/cognizer)
[![codecov](https://codecov.io/gh/ColumbusCollaboratory/cognizer/branch/master/graph/badge.svg)](https://codecov.io/gh/ColumbusCollaboratory/cognizer)




R package to wrap function calls to IBM Watson services.

You must already have an active Bluemix ID to obtain credentials for a service; for more information, see [Registering for Bluemix](https://www.ibm.com/watson/developercloud/doc/getting_started/gs-bluemix.shtml#register).

In addition to an active Bluemix ID, you must already have service credentials from Bluemix for each Watson Service you will be using through cognizer. Please follow the following steps for “[Getting service credentials in Bluemix](https://www.ibm.com/watson/developercloud/doc/getting_started/gs-credentials.shtml)”.

#### **Install**

-    Some high-performance curl functions that cognizer depends on have not been pushed to CRAN, yet, so __you will need the development version of curl__:

    ``` r
    install.packages("devtools")
    install.packages("https://github.com/jeroenooms/curl/archive/master.tar.gz", repos = NULL)
    devtools::install_github("ColumbusCollaboratory/cognizer")
    ```

-   You'll probably also want to install the data packages used in the tests:

    ``` r
    install.packages(c("rmsfact", "testthat"))
    ```

#### **Authentication**

All Watson services use basic authentication in the form of api keys or username-password combinations. To start using cognizer functions, you will need to pass your authentication details to them as an argument. There are many ways to manage your passwords, and we do not want to impose any particular structure on this process. If no solution comes to mind, one approach is to use the R environment file to store your authentication details that can be easily and programmatically passed to the cognizer functions.

If you already have .Renviron file in your home directory, then you can add something like

``` r
SERVICE_API_KEY = "key"
```

and/or

``` r
SERVICE_USERNAME_PASSWORD = "username:password"
```

(Notice the use of `=` as opposed `<-` when storing environment variables.) If not, then you can run the following commands to create and edit the file by inserting the name and value pairs of the environment variables in the above format:

``` r
r_env <- file.path(normalizePath("~"), ".Renviron")
if (!file.exists(r_env)) file.create(r_env)
file.edit(r_env)
```

After restarting R, you can then access the values of environment variables with

``` r
Sys.getenv("API_SERVICE_NAME")
```

#### <a name="toc"></a>**cognizer Watson Services Examples:**

-   [Text Processing](#text)
    -   [Alchemy Language](#alchemy) [<sub><sub>-IBM Docs-</sub></sub>](http://www.ibm.com/watson/developercloud/alchemy-language.html)
        -   [Sentiment Analysis](#sentiment) [<sub><sub>-IBM Docs-</sub></sub>](http://www.ibm.com/watson/developercloud/alchemy-language/api/v1/?curl#sentiment)
        -   [Keyword Extraction](#keyword) [<sub><sub>-IBM Docs-</sub></sub>](http://www.ibm.com/watson/developercloud/alchemy-language/api/v1/?curl#keywords)
        -   [Emotion Analysis](#emotion) [<sub><sub>-IBM Docs-</sub></sub>](http://www.ibm.com/watson/developercloud/alchemy-language/api/v1/?curl#emotion_analysis)
        -   [Language Detection](#language) [<sub><sub>-IBM Docs-</sub></sub>](http://www.ibm.com/watson/developercloud/alchemy-language/api/v1/?curl#language)
        -   [Entity Extraction](#entity) [<sub><sub>-IBM Docs-</sub></sub>](http://www.ibm.com/watson/developercloud/alchemy-language/api/v1/?curl#entities)
        -   [Concept Tagging](#concept) [<sub><sub>-IBM Docs-</sub></sub>](http://www.ibm.com/watson/developercloud/alchemy-language/api/v1/?curl#concepts)
        -   [Relation Extraction](#relations) [<sub><sub>-IBM Docs-</sub></sub>](http://www.ibm.com/watson/developercloud/alchemy-language/api/v1/?curl#relations)
        -   [Taxonomy Classification](#taxonomy) [<sub><sub>-IBM Docs-</sub></sub>](http://www.ibm.com/watson/developercloud/alchemy-language/api/v1/?curl#taxonomy)
    -   [Language Translation](#translate) [<sub><sub>-IBM Docs-</sub></sub>](http://www.ibm.com/watson/developercloud/language-translation.html)
    -   [Personality Insights](#personality) [<sub><sub>-IBM Docs-</sub></sub>](http://www.ibm.com/watson/developercloud/personality-insights.html)
    -   [Tone Analyzer](#tone) [<sub><sub>-IBM Docs-</sub></sub>](http://www.ibm.com/watson/developercloud/tone-analyzer.html)
    -   [Text-to-Speech](#text-speech) [<sub><sub>-IBM Docs-</sub></sub>](http://www.ibm.com/watson/developercloud/text-to-speech.html)
-   [Image Visual Recognition](#image) [<sub><sub>-IBM Docs-</sub></sub>](http://www.ibm.com/watson/developercloud/visual-recognition.html)
    -   [Classification of Images](#image-classify) [<sub><sub>-IBM Docs-</sub></sub>](http://www.ibm.com/watson/developercloud/visual-recognition/api/v3/#classify_an_image)
    -   [Detect Faces in Image](#image-faces) [<sub><sub>-IBM Docs-</sub></sub>](http://www.ibm.com/watson/developercloud/visual-recognition/api/v3/#detect_faces)
    -   [Detect Text in Image](#image-text) [<sub><sub>-IBM Docs-</sub></sub>](http://www.ibm.com/watson/developercloud/visual-recognition/api/v3/#recognize_text)
-   [Audio Processing](#audio)
    -   [Speech-to-Text](#audio-text) [<sub><sub>-IBM Docs-</sub></sub>](http://www.ibm.com/watson/developercloud/speech-to-text.html)

### <a name="text"></a>Text Processing

#### <a name="alchemy"></a>Alchemy Language

##### <a name="sentiment"></a>Sentiment Analysis [<sub><sub><sub>-top-</sub></sub></sub>](#toc)

``` r
text <- c("Columbus, Ohio is Awesome!", "Looking forward to UseR2017 in Brussels!")
result <- text_sentiment(text, YOUR_API_KEY)
str(result)
## List of 2
##  $ :List of 5
##   ..$ status           : chr "OK"
##   ..$ usage            : chr "By accessing AlchemyAPI or using information generated by AlchemyAPI, you are agreeing to be bound by the AlchemyAPI Terms of U"| __truncated__
##   ..$ totalTransactions: chr "1"
##   ..$ language         : chr "english"
##   ..$ docSentiment     :List of 2
##   .. ..$ score: chr "0.736974"
##   .. ..$ type : chr "positive"
##  $ :List of 5
##   ..$ status           : chr "OK"
##   ..$ usage            : chr "By accessing AlchemyAPI or using information generated by AlchemyAPI, you are agreeing to be bound by the AlchemyAPI Terms of U"| __truncated__
##   ..$ totalTransactions: chr "1"
##   ..$ language         : chr "english"
##   ..$ docSentiment     :List of 2
##   .. ..$ score: chr "0.405182"
##   .. ..$ type : chr "positive"
```

##### <a name="keyword"></a>Keyword Extraction [<sub><sub><sub>-top-</sub></sub></sub>](#toc)

``` r
text <- c("Columbus, Ohio is Awesome!", "Looking forward to UseR2017 in Brussels!")
result <- text_keywords(text, YOUR_API_KEY)
str(result)
## List of 2
##  $ :List of 5
##   ..$ status           : chr "OK"
##   ..$ usage            : chr "By accessing AlchemyAPI or using information generated by AlchemyAPI, you are agreeing to be bound by the AlchemyAPI Terms of U"| __truncated__
##   ..$ totalTransactions: chr "1"
##   ..$ language         : chr "english"
##   ..$ keywords         :'data.frame':    2 obs. of  2 variables:
##   .. ..$ relevance: chr [1:2] "0.903313" "0.878148"
##   .. ..$ text     : chr [1:2] "Columbus" "Ohio"
##  $ :List of 5
##   ..$ status           : chr "OK"
##   ..$ usage            : chr "By accessing AlchemyAPI or using information generated by AlchemyAPI, you are agreeing to be bound by the AlchemyAPI Terms of U"| __truncated__
##   ..$ totalTransactions: chr "1"
##   ..$ language         : chr "english"
##   ..$ keywords         :'data.frame':    2 obs. of  2 variables:
##   .. ..$ relevance: chr [1:2] "0.987472" "0.877147"
##   .. ..$ text     : chr [1:2] "Brussels" "UseR2017"
```

##### <a name="emotion"></a>Emotion Analysis [<sub><sub><sub>-top-</sub></sub></sub>](#toc)

``` r
text <- c("Columbus, Ohio is Awesome!", "Looking forward to UseR2017 in Brussels!")
result <- text_emotion(text, YOUR_API_KEY)
str(result)
## List of 2
##  $ :List of 5
##   ..$ status           : chr "OK"
##   ..$ usage            : chr "By accessing AlchemyAPI or using information generated by AlchemyAPI, you are agreeing to be bound by the AlchemyAPI Terms of U"| __truncated__
##   ..$ totalTransactions: chr "1"
##   ..$ language         : chr "english"
##   ..$ docEmotions      :List of 5
##   .. ..$ anger  : chr "0.070822"
##   .. ..$ disgust: chr "0.051115"
##   .. ..$ fear   : chr "0.327703"
##   .. ..$ joy    : chr "0.69756"
##   .. ..$ sadness: chr "0.150018"
##  $ :List of 5
##   ..$ status           : chr "OK"
##   ..$ usage            : chr "By accessing AlchemyAPI or using information generated by AlchemyAPI, you are agreeing to be bound by the AlchemyAPI Terms of U"| __truncated__
##   ..$ totalTransactions: chr "1"
##   ..$ language         : chr "english"
##   ..$ docEmotions      :List of 5
##   .. ..$ anger  : chr "0.059402"
##   .. ..$ disgust: chr "0.077588"
##   .. ..$ fear   : chr "0.123658"
##   .. ..$ joy    : chr "0.760328"
##   .. ..$ sadness: chr "0.35755"
```

##### <a name="language"></a>Language Detection [<sub><sub><sub>-top-</sub></sub></sub>](#toc)

``` r
text <- c("Columbus, Ohio is Awesome!", "Mirando hacia adelante a UseR2017 en Bruselas!")
result <- text_language(text, YOUR_API_KEY)
str(result)
## List of 2
##  $ :List of 10
##   ..$ status         : chr "OK"
##   ..$ usage          : chr "By accessing AlchemyAPI or using information generated by AlchemyAPI, you are agreeing to be bound by the AlchemyAPI Terms of U"| __truncated__
##   ..$ url            : chr ""
##   ..$ language       : chr "english"
##   ..$ iso-639-1      : chr "en"
##   ..$ iso-639-2      : chr "eng"
##   ..$ iso-639-3      : chr "eng"
##   ..$ ethnologue     : chr "http://www.ethnologue.com/show_language.asp?code=eng"
##   ..$ native-speakers: chr "309-400 million"
##   ..$ wikipedia      : chr "http://en.wikipedia.org/wiki/English_language"
##  $ :List of 10
##   ..$ status         : chr "OK"
##   ..$ usage          : chr "By accessing AlchemyAPI or using information generated by AlchemyAPI, you are agreeing to be bound by the AlchemyAPI Terms of U"| __truncated__
##   ..$ url            : chr ""
##   ..$ language       : chr "spanish"
##   ..$ iso-639-1      : chr "es"
##   ..$ iso-639-2      : chr "spa"
##   ..$ iso-639-3      : chr "spa"
##   ..$ ethnologue     : chr "http://www.ethnologue.com/show_language.asp?code=spa"
##   ..$ native-speakers: chr "350 million"
##   ..$ wikipedia      : chr "http://en.wikipedia.org/wiki/Spanish_language"
```

##### <a name="entity"></a>Entity Extraction [<sub><sub><sub>-top-</sub></sub></sub>](#toc)

``` r
text <- c("Columbus, Ohio is Awesome!", "Looking forward to UseR2017 in Brussels!")
result <- text_entity(text, YOUR_API_KEY)
str(result)
## List of 2
##  $ :List of 6
##   ..$ status  : chr "OK"
##   ..$ usage   : chr "By accessing AlchemyAPI or using information generated by AlchemyAPI, you are agreeing to be bound by the AlchemyAPI Terms of U"| __truncated__
##   ..$ url     : chr ""
##   ..$ language: chr "english"
##   ..$ entities:'data.frame': 2 obs. of  3 variables:
##   .. ..$ count: chr [1:2] "1" "1"
##   .. ..$ text : chr [1:2] "Columbus" "Ohio"
##   .. ..$ type : chr [1:2] "GeopoliticalEntity" "GeopoliticalEntity"
##   ..$ model   : chr "ie-en-news"
##  $ :List of 6
##   ..$ status  : chr "OK"
##   ..$ usage   : chr "By accessing AlchemyAPI or using information generated by AlchemyAPI, you are agreeing to be bound by the AlchemyAPI Terms of U"| __truncated__
##   ..$ url     : chr ""
##   ..$ language: chr "english"
##   ..$ entities:'data.frame': 1 obs. of  3 variables:
##   .. ..$ count: chr "1"
##   .. ..$ text : chr "Brussels"
##   .. ..$ type : chr "GeopoliticalEntity"
##   ..$ model   : chr "ie-en-news"
```

##### <a name="concept"></a>Concept Tagging [<sub><sub><sub>-top-</sub></sub></sub>](#toc)

``` r
text <- "Columbus, Ohio is Awesome!"
result <- text_concept(text, YOUR_API_KEY)
str(result)
## List of 1
##  $ :List of 4
##   ..$ status  : chr "OK"
##   ..$ usage   : chr "By accessing AlchemyAPI or using information generated by AlchemyAPI, you are agreeing to be bound by the AlchemyAPI Terms of U"| __truncated__
##   ..$ language: chr "english"
##   ..$ concepts:'data.frame': 1 obs. of  8 variables:
##   .. ..$ text     : chr "Columbus, Ohio"
##   .. ..$ relevance: chr "0.911407"
##   .. ..$ website  : chr "http://www.columbus.gov/"
##   .. ..$ dbpedia  : chr "http://dbpedia.org/resource/Columbus,_Ohio"
##   .. ..$ freebase : chr "http://rdf.freebase.com/ns/m.01smm"
##   .. ..$ census   : chr "http://www.rdfabout.com/rdf/usgov/geo/us/oh/counties/franklin_county/columbus"
##   .. ..$ yago     : chr "http://yago-knowledge.org/resource/Columbus,_Ohio"
##   .. ..$ geonames : chr "http://sws.geonames.org/4509177/"
```

##### <a name="relations"></a>Relation Extraction [<sub><sub><sub>-top-</sub></sub></sub>](#toc)

``` r
text <- "Columbus, Ohio is Awesome!"
result <- text_relations(text, YOUR_API_KEY)
str(result)
## List of 1
##  $ :List of 4
##   ..$ status  : chr "OK"
##   ..$ usage   : chr "By accessing AlchemyAPI or using information generated by AlchemyAPI, you are agreeing to be bound by the AlchemyAPI Terms of U"| __truncated__
##   ..$ language: chr "english"
##   ..$ concepts:'data.frame': 1 obs. of  8 variables:
##   .. ..$ text     : chr "Columbus, Ohio"
##   .. ..$ relevance: chr "0.911407"
##   .. ..$ website  : chr "http://www.columbus.gov/"
##   .. ..$ dbpedia  : chr "http://dbpedia.org/resource/Columbus,_Ohio"
##   .. ..$ freebase : chr "http://rdf.freebase.com/ns/m.01smm"
##   .. ..$ census   : chr "http://www.rdfabout.com/rdf/usgov/geo/us/oh/counties/franklin_county/columbus"
##   .. ..$ yago     : chr "http://yago-knowledge.org/resource/Columbus,_Ohio"
##   .. ..$ geonames : chr "http://sws.geonames.org/4509177/"
```

##### <a name="taxonomy"></a>Taxonomy Classification [<sub><sub><sub>-top-</sub></sub></sub>](#toc)

``` r
text <- "Columbus, Ohio is Awesome!"
result <- text_taxonomy(text, YOUR_API_KEY)
str(result)
## List of 1
##  $ :List of 5
##   ..$ status           : chr "OK"
##   ..$ usage            : chr "By accessing AlchemyAPI or using information generated by AlchemyAPI, you are agreeing to be bound by the AlchemyAPI Terms of U"| __truncated__
##   ..$ totalTransactions: chr "1"
##   ..$ language         : chr "english"
##   ..$ taxonomy         :'data.frame':    3 obs. of  3 variables:
##   .. ..$ confident: chr [1:3] "no" "no" "no"
##   .. ..$ label    : chr [1:3] "/sports/bowling" "/law, govt and politics/law enforcement/highway patrol" "/technology and computing/consumer electronics/tv and video equipment/televisions/lcd tvs"
##   .. ..$ score    : chr [1:3] "0.19062" "0.157219" "0.154218"
```

#### <a name="translate"></a>Language Translate [<sub><sub><sub>-top-</sub></sub></sub>](#toc)

The following Web Services use IBM Bluemix Watson Services Username and Passwords as available on [Bluemix Credentials](https://www.ibm.com/watson/developercloud/doc/getting_started/gs-credentials.shtml) in a colon deliminated string. LANG\_TRANSLATE\_USERNAME\_PASSWORD is a username:password string as defined for each Bluemix Watson Services.

``` r
text <- c("Mirando hacia adelante a UseR2017 en Bruselas!")
result <- text_translate(text, LANG_TRANSLATE_USERNAME_PASSWORD)
str(result)
## List of 1
##  $ :List of 3
##   ..$ translations   :'data.frame':  1 obs. of  1 variable:
##   .. ..$ translation: chr "Looking forward to UseR2017 in Brussels."
##   ..$ word_count     : int 7
##   ..$ character_count: int 46
```

#### <a name="personality"></a>Personality Insights [<sub><sub><sub>-top-</sub></sub></sub>](#toc)

The following Web Services use IBM Bluemix Watson Services Username and Passwords as available on [Bluemix Credentials](https://www.ibm.com/watson/developercloud/doc/getting_started/gs-credentials.shtml) in a colon deliminated string. PERSONALITY\_USERNAME\_PASSWORD is a username:password string as defined for each Bluemix Watson Services.

``` r
text <- paste(replicate(1000, rmsfact::rmsfact()), collapse = ' ') #Ten Richard Stallman Facts used for Personality Insights.
result <- text_personality(text, PERSONALITY_USERNAME_PASSWORD)
str(result)
## List of 1
##  $ :List of 6
##   ..$ id            : chr "*UNKNOWN*"
##   ..$ source        : chr "*UNKNOWN*"
##   ..$ word_count    : int 13600
##   ..$ processed_lang: chr "en"
##   ..$ tree          :List of 3
##   .. ..$ id      : chr "r"
##   .. ..$ name    : chr "root"
##   .. ..$ children:'data.frame':  3 obs. of  3 variables:
##   .. .. ..$ id      : chr [1:3] "personality" "needs" "values"
##   .. .. ..$ name    : chr [1:3] "Big 5" "Needs" "Values"
##   .. .. ..$ children:List of 3
##   .. .. .. ..$ :'data.frame':    1 obs. of  5 variables:
##   .. .. .. .. ..$ id        : chr "Agreeableness_parent"
##   .. .. .. .. ..$ name      : chr "Agreeableness"
##   .. .. .. .. ..$ category  : chr "personality"
##   .. .. .. .. ..$ percentage: num 0.114
##   .. .. .. .. ..$ children  :List of 1
##   .. .. .. .. .. ..$ :'data.frame':  5 obs. of  6 variables:
##   .. .. .. .. .. .. ..$ id            : chr [1:5] "Openness" "Conscientiousness" "Extraversion" "Agreeableness" ...
##   .. .. .. .. .. .. ..$ name          : chr [1:5] "Openness" "Conscientiousness" "Extraversion" "Agreeableness" ...
##   .. .. .. .. .. .. ..$ category      : chr [1:5] "personality" "personality" "personality" "personality" ...
##   .. .. .. .. .. .. ..$ percentage    : num [1:5] 0.694 0.428 0.703 0.114 0.29
##   .. .. .. .. .. .. ..$ sampling_error: num [1:5] 0.0466 0.0594 0.0453 0.0812 0.0754
##   .. .. .. .. .. .. ..$ children      :List of 5
##   .. .. .. .. .. .. .. ..$ :'data.frame':    6 obs. of  5 variables:
##   .. .. .. .. .. .. .. .. ..$ id            : chr [1:6] "Adventurousness" "Artistic interests" "Emotionality" "Imagination" ...
##   .. .. .. .. .. .. .. .. ..$ name          : chr [1:6] "Adventurousness" "Artistic interests" "Emotionality" "Imagination" ...
##   .. .. .. .. .. .. .. .. ..$ category      : chr [1:6] "personality" "personality" "personality" "personality" ...
##   .. .. .. .. .. .. .. .. ..$ percentage    : num [1:6] 0.635 0.554 0.389 0.864 0.639 ...
##   .. .. .. .. .. .. .. .. ..$ sampling_error: num [1:6] 0.0417 0.0864 0.039 0.0535 0.0451 ...
##   .. .. .. .. .. .. .. ..$ :'data.frame':    6 obs. of  5 variables:
##   .. .. .. .. .. .. .. .. ..$ id            : chr [1:6] "Achievement striving" "Cautiousness" "Dutifulness" "Orderliness" ...
##   .. .. .. .. .. .. .. .. ..$ name          : chr [1:6] "Achievement striving" "Cautiousness" "Dutifulness" "Orderliness" ...
...
```

#### <a name="tone"></a>Tone Analyzer [<sub><sub><sub>-top-</sub></sub></sub>](#toc)

The following Web Services use IBM Bluemix Watson Services Username and Passwords as available on [Bluemix Credentials](https://www.ibm.com/watson/developercloud/doc/getting_started/gs-credentials.shtml) in a colon deliminated string. TONE\_USERNAME\_PASSWORD is a username:password string as defined for each Bluemix Watson Services.

``` r
text <- c("Columbus, Ohio is Awesome!")
result <- text_tone(text, TONE_USERNAME_PASSWORD)
str(result)
## List of 1
##  $ :List of 1
##   ..$ document_tone:List of 1
##   .. ..$ tone_categories:'data.frame':   3 obs. of  3 variables:
##   .. .. ..$ tones        :List of 3
##   .. .. .. ..$ :'data.frame':    5 obs. of  3 variables:
##   .. .. .. .. ..$ score    : num [1:5] 0.0708 0.0511 0.3277 0.6976 0.15
##   .. .. .. .. ..$ tone_id  : chr [1:5] "anger" "disgust" "fear" "joy" ...
##   .. .. .. .. ..$ tone_name: chr [1:5] "Anger" "Disgust" "Fear" "Joy" ...
##   .. .. .. ..$ :'data.frame':    3 obs. of  3 variables:
##   .. .. .. .. ..$ score    : num [1:3] 0 0 0
##   .. .. .. .. ..$ tone_id  : chr [1:3] "analytical" "confident" "tentative"
##   .. .. .. .. ..$ tone_name: chr [1:3] "Analytical" "Confident" "Tentative"
##   .. .. .. ..$ :'data.frame':    5 obs. of  3 variables:
##   .. .. .. .. ..$ score    : num [1:5] 0.24 0.571 0.694 0.308 0.401
##   .. .. .. .. ..$ tone_id  : chr [1:5] "openness_big5" "conscientiousness_big5" "extraversion_big5" "agreeableness_big5" ...
##   .. .. .. .. ..$ tone_name: chr [1:5] "Openness" "Conscientiousness" "Extraversion" "Agreeableness" ...
##   .. .. ..$ category_id  : chr [1:3] "emotion_tone" "language_tone" "social_tone"
##   .. .. ..$ category_name: chr [1:3] "Emotion Tone" "Language Tone" "Social Tone"
```

#### <a name="text-speech"></a>Text-to-Speech [<sub><sub><sub>-top-</sub></sub></sub>](#toc)

The following Web Services use IBM Bluemix Watson Services Username and Passwords as available on [Bluemix Credentials](https://www.ibm.com/watson/developercloud/doc/getting_started/gs-credentials.shtml) in a colon deliminated string. TEXT\_TO\_SPEECH\_USERNAME\_PASSWORD is a username:password string as defined for each Bluemix Watson Services.

``` r
text <- c("Columbus, Ohio is Awesome!")
text_audio(text, TEXT_TO_SPEECH_USERNAME_PASSWORD, directory = '.')
```

The .ogg audio file is written to the current directory.

You can listen to the example audio file in the repository: [1.ogg](1.ogg)

### <a name="image"></a>Image Visual Recognition

##### <a name="image-classify"></a>Classification of Image [<sub><sub><sub>-top-</sub></sub></sub>](#toc)

The following Web Services use IBM Bluemix Watson Services IMAGE\_API\_KEY specific to Image processsing.

``` r
image_face_path <- system.file("extdata/images_faces", package = "cognizer")
images <- list.files(image_face_path, full.names = TRUE)
image_classes <- image_classify(images, IMAGE_API_KEY)
str(image_classes)
## List of 2
##  $ :List of 3
##   ..$ custom_classes  : int 0
##   ..$ images          :'data.frame': 1 obs. of  2 variables:
##   .. ..$ classifiers:List of 1
##   .. .. ..$ :'data.frame':   1 obs. of  3 variables:
##   .. .. .. ..$ classes      :List of 1
##   .. .. .. .. ..$ :'data.frame': 1 obs. of  3 variables:
##   .. .. .. .. .. ..$ class         : chr "person"
##   .. .. .. .. .. ..$ score         : num 1
##   .. .. .. .. .. ..$ type_hierarchy: chr "/people"
##   .. .. .. ..$ classifier_id: chr "default"
##   .. .. .. ..$ name         : chr "default"
##   .. ..$ image      : chr "Einstein_laughing.jpg"
##   ..$ images_processed: int 1
##  $ :List of 3
##   ..$ custom_classes  : int 0
##   ..$ images          :'data.frame': 1 obs. of  2 variables:
##   .. ..$ classifiers:List of 1
##   .. .. ..$ :'data.frame':   1 obs. of  3 variables:
##   .. .. .. ..$ classes      :List of 1
##   .. .. .. .. ..$ :'data.frame': 1 obs. of  3 variables:
##   .. .. .. .. .. ..$ class         : chr "person"
##   .. .. .. .. .. ..$ score         : num 1
##   .. .. .. .. .. ..$ type_hierarchy: chr "/people"
##   .. .. .. ..$ classifier_id: chr "default"
##   .. .. .. ..$ name         : chr "default"
##   .. ..$ image      : chr "wkd_birthofinternet_1220-10.jpg"
##   ..$ images_processed: int 1
```

##### <a name="image-faces"></a>Detect Faces in Image [<sub><sub><sub>-top-</sub></sub></sub>](#toc)

The following Web Services use IBM Bluemix Watson Services IMAGE\_API\_KEY specific to Image processsing.

``` r
image_face_path <- system.file("extdata/images_faces", package = "cognizer")
images <- list.files(image_face_path, full.names = TRUE)
image_faces <- image_detectface(images, IMAGE_API_KEY)
str(image_faces)
## List of 2
##  $ :List of 2
##   ..$ images          :'data.frame': 1 obs. of  2 variables:
##   .. ..$ faces:List of 1
##   .. .. ..$ :'data.frame':   1 obs. of  4 variables:
##   .. .. .. ..$ age          :'data.frame':   1 obs. of  2 variables:
##   .. .. .. .. ..$ min  : int 65
##   .. .. .. .. ..$ score: num 0.671
##   .. .. .. ..$ face_location:'data.frame':   1 obs. of  4 variables:
##   .. .. .. .. ..$ height: int 250
##   .. .. .. .. ..$ left  : int 214
##   .. .. .. .. ..$ top   : int 105
##   .. .. .. .. ..$ width : int 231
##   .. .. .. ..$ gender       :'data.frame':   1 obs. of  2 variables:
##   .. .. .. .. ..$ gender: chr "MALE"
##   .. .. .. .. ..$ score : num 1
##   .. .. .. ..$ identity     :'data.frame':   1 obs. of  3 variables:
##   .. .. .. .. ..$ name          : chr "Alfred Einstein"
##   .. .. .. .. ..$ score         : num 0.953
##   .. .. .. .. ..$ type_hierarchy: chr "/people/alfred einstein"
##   .. ..$ image: chr "Einstein_laughing.jpg"
##   ..$ images_processed: int 1
##  $ :List of 2
##   ..$ images          :'data.frame': 1 obs. of  2 variables:
##   .. ..$ faces:List of 1
##   .. .. ..$ :'data.frame':   1 obs. of  3 variables:
##   .. .. .. ..$ age          :'data.frame':   1 obs. of  3 variables:
##   .. .. .. .. ..$ max  : int 44
##   .. .. .. .. ..$ min  : int 35
##   .. .. .. .. ..$ score: num 0.235
##   .. .. .. ..$ face_location:'data.frame':   1 obs. of  4 variables:
##   .. .. .. .. ..$ height: int 320
##   .. .. .. .. ..$ left  : int 26
##   .. .. .. .. ..$ top   : int 120
##   .. .. .. .. ..$ width : int 289
##   .. .. .. ..$ gender       :'data.frame':   1 obs. of  2 variables:
##   .. .. .. .. ..$ gender: chr "MALE"
##   .. .. .. .. ..$ score : num 0.971
##   .. ..$ image: chr "wkd_birthofinternet_1220-10.jpg"
##   ..$ images_processed: int 1
```

##### <a name="image-text"></a>Detect Text in Image [<sub><sub><sub>-top-</sub></sub></sub>](#toc)

The following Web Services use IBM Bluemix Watson Services IMAGE\_API\_KEY specific to Image processsing.

``` r
image_text_path <- system.file("extdata/images_text", package = "cognizer")
images <- list.files(image_text_path, full.names = TRUE)
image_text<- image_detecttext(images, IMAGE_API_KEY)
str(image_text)
## List of 1
##  $ :List of 2
##   ..$ images          :'data.frame': 1 obs. of  2 variables:
##   .. ..$ error:'data.frame': 1 obs. of  2 variables:
##   .. .. ..$ description: chr "An undefined server error occurred."
##   .. .. ..$ error_id   : chr "server_error"
##   .. ..$ image: chr "Did_that_billboard_just_change.jpg"
##   ..$ images_processed: int 0
```

### <a name="audio"></a>Audio Processing

##### <a name="audio-text"></a>Speech to Text [<sub><sub><sub>-top-</sub></sub></sub>](#toc)

The following Web Services use IBM Bluemix Watson Services Username and Passwords as available on [Bluemix Credentials](https://www.ibm.com/watson/developercloud/doc/getting_started/gs-credentials.shtml) in a colon deliminated string. SPEECH\_TO\_TEXT\_USERNAME\_PASSWORD is a username:password string as defined for each Bluemix Watson Services.

``` r
audio_path <- system.file("extdata/audio", package = "cognizer")
audios <- list.files(audio_path, full.names = TRUE)
audio_transcript <- audio_text(audios, SPEECH_TO_TEXT_USERNAME_PASSWORD)
str(audio_transcript)
## List of 1
##  $ :List of 2
##   ..$ results     :'data.frame': 1 obs. of  2 variables:
##   .. ..$ alternatives:List of 1
##   .. .. ..$ :'data.frame':   1 obs. of  2 variables:
##   .. .. .. ..$ confidence: num 0.954
##   .. .. .. ..$ transcript: chr "hello world "
##   .. ..$ final       : logi TRUE
##   ..$ result_index: int 0
```
