download_and_read = function(u, remove_nas = TRUE) {
    tmp = tempfile(fileext = ".xlsx")
    download.file(u, tmp, mode = "wb")
    d = readxl::read_excel(tmp)
    names(d) = clean_names(names(d))
    d = select_columns(d)
    d = d |> filter_nas()
    return(d)
}

clean_names = function(x) {
  x |>
    gsub("REPORTER TRANSPORT ", "", .) |>
    gsub("OFFENDER VEHICLE ", "", .) |>
    gsub("OFF ", "", .) |>
    gsub("DATE OF SUBMISSION", "DATE", .) |>
    tolower()
}

select_columns = function(d) {
  names_remove = stringr::str_detect(names(d), "\\.\\.")
  d = d[, !names_remove]
}

filter_nas = function(d) {
  d |>
    dplyr::filter(offence == "N/A")
}