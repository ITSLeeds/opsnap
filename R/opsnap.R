download_and_read = function(u, remove_nas = TRUE) {
    tmp = tempfile(fileext = ".xlsx")
    utils::download.file(u, tmp, mode = "wb")
    d = readxl::read_excel(tmp)
    names(d) = clean_names(names(d))
    d = select_columns(d)
    d = d |> filter_nas()
    return(d)
}

clean_names = function(x) {
  x |>
    gsub("REPORTER TRANSPORT ", "", x = _) |>
    gsub("OFFENDER VEHICLE ", "", x = _) |>
    gsub("OFF ", "", x = _) |>
    gsub("DATE OF SUBMISSION", "DATE", x = _) |>
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

op_plot_offence = function(d) {
  d |>
    ggplot::ggplot() +
    ggplot::geom_bar(ggplot2::aes(x = offence)) +
    # Make x labels vertical
    ggplot::theme(axis.text.x = element_text(angle = 90, hjust = 1))
}
