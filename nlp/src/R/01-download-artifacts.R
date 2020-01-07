ObtainOriginalTextCorpus <- function(corpus.uri, corpus.path) {
    CreateDirs(dirname(corpus.path))
    logdebug("start downloading original text corpus", logger="download")
    rc <- download.file(corpus.uri, corpus.path, method = "auto")
    if (rc != 0 || !file.exists(corpus.path)) {
        stop(paste0("unable to obtain original text corpus: ", toString(rc)))
    }
}

ConstructOriginalCorpusPath <- function(config) {
    layout.data <- config$settings$layout$data
    file.path(layout.data$root, layout.data$raw, config$corpus$name)
}

ConstructOriginalCorpusPaths <- function(config) {
    layout.data <- config$settings$layout$data
    corpus.paths <- lapply(config$corpus$genres, function(genre) {
        file.path(
            layout.data$root,
            layout.data$raw,
            "final",
            config$corpus$language,
            paste0(config$corpus$language, ".", genre, ".txt")
        )
    })
    names(corpus.paths) <- config$corpus$genres
    corpus.paths
}

ObtainOriginalCorpus <- function(config) {
    # check if original corpus exists
    orig.corpus.path <- ConstructOriginalCorpusPath(config)
    if (!file.exists(orig.corpus.path)) {
        ObtainOriginalTextCorpus(config$corpus$uri, orig.corpus.path)
    }
    # check if original corpus was unpacked
    orig.corpus.paths <- ConstructOriginalCorpusPaths(config)
    if (!all(sapply(orig.corpus.paths, file.exists))) {
        paths <- unzip(orig.corpus.path, exdir = dirname(orig.corpus.path))
        if (length(paths) <= 0) {
            stop("unable to unpack original text corpus")
        }
    }
    # move corpus files to expected location
    sapply(orig.corpus.paths, function(orig.path) {
        file.rename(orig.path,
                    file.path(dirname(orig.corpus.path), basename(orig.path)))
    })
}

ConstructCorpusPaths <- function(config) {
    layout.data <- config$settings$layout$data
    corpus.paths <- lapply(config$corpus$genres, function(genre) {
        file.path(
            layout.data$root,
            layout.data$raw,
            paste0(config$corpus$language, ".", genre, ".txt")
        )
    })
    names(corpus.paths) <- config$corpus$genres
    corpus.paths
}

ObtainCorpusData <- function(config) {
    corpus.paths <- ConstructCorpusPaths(config)
    # check if corpus files exist
    if (!all(sapply(corpus.paths, file.exists))) {
        # check if archive corpus files exist
        corpus.archive.paths <-
            lapply(corpus.paths, function(corp) {
                paste0(corp, ".zip")
            })
        if (!all(sapply(corpus.archive.paths, file.exists))) {
            # this branch is almost never going to happen
            ObtainOriginalCorpus(config)
        } else {
            # unpack archives
            sapply(corpus.archive.paths, function(corpus.path) {
                unzip(corpus.path, exdir = dirname(corpus.path))
            })
        }
    }
    corpus.paths
}

DownloadArtifacts <- function(config) {
    # corpus section
    artifacts <- list("corpus" = list())
    corpus.paths <- ObtainCorpusData(config)
    sapply(config$corpus$genres, function(genre) {
        artifacts$corpus[[genre]] <<- list("path" = corpus.paths[[genre]])
    })

    artifacts
}