CheckSettings <- function(object) {
    IsOk <- function(name, container) {
        errors <- character()
        if (!(name %in% names(container))) {
            msg <- paste0("Settings layout must have section '", name, "'")
            errors <- c(errors, msg)
        }
        if (is.null(container[[name]]) || container[[name]] == "") {
            msg <- paste0("Settings layout section '",
                          name,
                          "' must be non-empty")
            errors <- c(errors, msg)
        }
        errors
    }
    errors <- c(character(), IsOk("data", object@layout))
    for (name in c("root", "raw", "tmp")) {
        errors <- c(errors, IsOk(name, object@layout$data))
    }
    if (length(errors) == 0) {
        TRUE
    } else {
        errors
    }
}

setClass("Settings",
         representation(layout = "list"),
         prototype(layout = list(data = list(
             root = "data",
             raw = "raw",
             tmp = "tmp"
         ))),
         validity = CheckSettings)

setGeneric("GetTmpDataPath", valueClass = "character", function(object) {
    standardGeneric("GetTmpDataPath")
})
setMethod("GetTmpDataPath", signature(object = "Settings"), function(object) {
    file.path(object@layout$data$root, object@layout$data$tmp)
})
setGeneric("GetRawDataPath", valueClass = "character", function(object) {
    standardGeneric("GetRawDataPath")
})
setMethod("GetRawDataPath", signature(object = "Settings"), function(object) {
    file.path(object@layout$data$root, object@layout$data$raw)
})

Settings <- function(data.folder.name,
                     data.raw.folder.name,
                     data.tmp.folder.name) {
    if (is.null(data.folder.name) &&
        is.null(data.raw.folder.name) &&
        is.null(data.tmp.folder.name)) {
        new("Settings")
    } else {
        new("Settings", layout = list(
            data = list(
                root = data.folder.name,
                raw = data.raw.folder.name,
                tmp = data.tmp.folder.name
            )
        ))
    }
}