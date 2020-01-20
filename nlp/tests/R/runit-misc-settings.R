source("src/R/misc/settings.R")

test.Settings <- function() {
    settings <- Settings("root", "raw", "tmp")
    RUnit::checkEquals(GetRawDataPath(settings), file.path("root", "raw"))
    RUnit::checkEquals(GetTmpDataPath(settings), file.path("root", "tmp"))
}