SampleTextCorpus <- function(in.path, out.path, percent) {
    logdebug(paste0("sampling text corpus: ", in.path), logger = "sample")
    if (file.exists(out.path)) {
        msg <-
            paste0("skipping sampling for corpus due to its existence: path = ",
                   in.path)
        logdebug(msg, logger = "sample")
        return (out.path)
    }
    CreateDirs(dirname(out.path))
    con <- file(in.path, "rb", encoding = "UTF-8", blocking = FALSE)
    tryCatch({
        in.data <- readLines(con, skipNul = TRUE)
    },
    finally = {
        close(con)
    })
    # TODO: investigate more proper way of manipulating with files since some
    # non-UTF-8 encoded characters cause the situation when not all the
    # information are read properly from corpus (the particular case can be
    # taken from 15th line of 'en_US.twitter.txt' file)
    # steps to reproduce:
    # 1. in.data <- readLines(in.path, encoding = "UTF-8", skipNul = TRUE) --
    #    will read only 15 first lines and break for 'en_US.twitter.txt' corpus
    # 2. write(out.data, file = out.path) -- will complain about invalid
    #    characters
    # (hack) 3.45% of corpus data is lost because of forcing to process corpus
    #        as 'UTF-8'-encoded by using conversion facilities
    in.data.conv <- iconv(in.data, to = "UTF-8")
    out.data <-
        sample(in.data.conv, as.integer(percent * length(in.data) / 100))
    if (length(out.data) > 0) {
        writeLines(out.data, out.path)
    }
    if (!file.exists(out.path)) {
        msg <- paste0("unable to sample file: ", in.path)
        logerror(msg, logger = "sample")
        stop(msg)
    }
}

SampleTextCorpuses <- function(config, artifacts) {
    logdebug("sampling text corpuses", logger = "sample")
    tmp.path <- file.path(
        config$settings$layout$data$root,
        config$settings$layout$data$tmp,
        paste0("sample-", config$sample$percent / 100)
    )
    sapply(config$corpus$genres, function(genre) {
        in.path <- artifacts$corpus[[genre]]$raw.path
        out.path <- file.path(tmp.path, basename(in.path))
        SampleTextCorpus(in.path, out.path, config$sample$percent)
        artifacts$corpus[[genre]][["sample.path"]] <<- out.path
    })
    logdebug("finished sampling text corpuses", logger = "sample")
    artifacts
}