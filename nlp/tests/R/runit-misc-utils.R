source("src/R/misc/utils.R")

test.CreateDirs <- function() {
    RUnit::checkException(CreateDirs(c("/a/b/c", "/a/a/a")))
    RUnit::checkEquals(CreateDirs(c(tempdir(), tempdir())), NULL)
}