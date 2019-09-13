CreateDirs <- function(paths, message = "unable to create directory") {
    paths.to.create <- paths[which(!sapply(paths, dir.exists))]
    paths.create.rc <- sapply(paths.to.create, dir.create, recursive = TRUE)
    if (any(!paths.create.rc)) {
        stop(paste0(message, "::", paths.to.create[!paths.create.rc], "\n  "))
    }
}