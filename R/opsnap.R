download_and_read = function(u, remove_nas = TRUE, dir = "raw_data/west-yorkshire", filter_nas = FALSE) {
    tmp = file.path(dir, basename(u))
    if (!file.exists(tmp)) {
        utils::download.file(u, tmp, mode = "wb")
    }
    suppressMessages({
        d = readxl::read_excel(tmp)
    })
    names(d) = clean_names(names(d))
    d = select_columns(d)
    if (filter_nas) {
        d = filter_nas(d)
    }
    return(d)
}

clean_names = function(x) {
  x |>
    gsub("REPORTER TRANSPORT ", "", x = _) |>
    gsub("OFFENDER VEHICLE ", "", x = _) |>
    gsub("OFF ", "", x = _) |>
    gsub("OFFENCE ", "", x = _) |>
    gsub(toupper("recommended disposal at point of triage"), "disposal", x = _) |>
    gsub("DATE OF SUBMISSION", "DATE", x = _) |>
    tolower()
}

select_columns = function(d) {
  names_remove = stringr::str_detect(names(d), "\\.\\.")
  d = d[, !names_remove]
}

filter_offence_nas = function(d) {
  d |>
    dplyr::filter(!offence == "N/A") |>
    dplyr::filter(!is.na(offence))
}

filter_location_nas = function(d) {
  d |>
    dplyr::filter(!location == "N/A") |>
    dplyr::filter(!is.na(location))
}

op_plot_offence = function(d) {
  ggplot2::ggplot(d) +
    ggplot2::geom_bar(ggplot2::aes(x = offence)) +
    # Make x labels vertical
    ggplot2::theme(axis.text.x = ggplot2::element_text(angle = 90, hjust = 1))
}

op_geocode = function(d, region = "West Yorkshire", method = "google") {
    address = d |>
        dplyr::pull(location)
    address = paste(address, region, sep = ", ")
    d_locations_unique = unique(address)
    n_locations = length(d_locations_unique)
    percent_duplicated = 1 - n_locations / length(address)
    message(
        "Number of unique locations: ", n_locations,
        "\nPercent duplicated: ", (percent_duplicated * 100) |> round(2),
        "%"
    )
        
    # d_locations = lapply(address, FUN = stplanr::geo_code)

    d_locations = tidygeocoder::geocode(tibble(address), address = address, method = method)
    
    # d_locations_lengths = sapply(d_locations, function(x) {
    #     length(x)
    # })
    # d_is_geo = d_locations_lengths > 0
    # d_with_geo = d[d_is_geo, ]
    # d_locations = d_locations[d_is_geo]
    
    # d_point = lapply(d_locations, function(x) {
    #     sf::st_point(matrix(x, ncol = 2))
    # })
    # d_sfc = sf::st_sfc(d_point) |>
    #     sf::st_sf(crs = "EPSG:4326")
    # d_sf = sf::st_sf(
    #     d_with_geo,
    #     geometry = d_sfc |> sf::st_geometry()
    # )
    
    return(d_locations)
}