# rm(list = ls(all.names = TRUE)) # clean up workspace

CheckPackage <- function(packages) {
    packages.to.install <-
        setdiff(packages, rownames(installed.packages()))
    if (length(packages.to.install) > 0) {
        install.packages(packages.to.install)
    }
}

SetupDevEnvironment <- function() {
    CheckPackage("checkpoint")
    # checkpoint package asks for permission to create that folder if it doesn't
    # exist; let's allow to do so without asking
    # https://github.com/RevolutionAnalytics/checkpoint/blob/master/R/checkpoint_paths.R +62
    checkpoint.path <- "~/.checkpoint"
    if (!dir.exists(checkpoint.path)) {
        dir.create(checkpoint.path, recursive = TRUE)
    }
    if (!dir.exists(checkpoint.path)) {
        stop(paste0("unable to create directory with path: ", checkpoint.path))
    }
    checkpoint::checkpoint("2019-09-11", scanForPackages = FALSE)
    # install checkpoint one more time in checkpoint-ed environment in order to
    # avoid warnings from IDE
    CheckPackage(c("checkpoint", "pacman"))
}
SetupDevEnvironment()

source("src/R/00-utils.R")
source("src/R/01-download-artifacts.R")

pacman::p_load("config")
pacman::p_load("logging")

options(warn = 1) # 0 - no warns, 1 - warns, 2 - turn warns to errors

InitializeLogging <- function(config) {
    logReset()
    setLevel(config$level)
    if (config$console) {
        addHandler(writeToConsole)
    }
    if (config$file) {
        addHandler(writeToFile, file=config$filename)
    }
}

Main <- function() {
    config <- config::get()

    InitializeLogging(config$logging)

    logdebug("start downloading artifacts", logger="main")
    config$settings <-
        list(layout = list(data = list(root = "data", raw = "raw")))
    artifacts <- DownloadArtifacts(config)
    logdebug("finish downloading artifacts", logger="main")
}

Main()