download_and_read = function(u) {
    tmp = tempfile(fileext = ".xlsx")
    download.file(u, tmp, mode = "wb")
    readxl::read_excel(tmp)
}