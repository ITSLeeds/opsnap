#' Get Criminal Justice Codes
#' 
#' This function gets the criminal justice codes from the Criminal Justice Hub website.
#' See [www.criminaljusticehub.org.uk](https://www.criminaljusticehub.org.uk/jargon-buster/cjs-offence-code/)
#' 
#' @param u The URL of the Criminal Justice Hub website.
#' 
#' @export 
#' @examples
#' get_cjs_codes()
get_cjs_codes = function(
    u = paste0(
        "https://www.criminaljusticehub.org.uk/wp-content/uploads/",
        "2022/10/cjs-offence-index-sept-2022.ods"
    )
) {
    f = file.path(tempdir(), "cjs_codes.ods")
    message("Downloading CJS codes from ", u, " to ", f)
    utils::download.file(u, f, mode = "wb")
    cjs_codes = readODS::read_ods(f, sheet = 1)
    cjs_codes
}