download_and_read = function(u, remove_nas = TRUE) {
    tmp = file.path(tempdir(), basename(u))
    if (!file.exists(tmp)) {
        utils::download.file(u, tmp, mode = "wb")
    }
    suppressMessages({
        d = readxl::read_excel(tmp)
    })
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
    dplyr::filter(!offence == "N/A")
}

op_plot_offence = function(d) {
  ggplot2::ggplot(d) +
    ggplot2::geom_bar(ggplot2::aes(x = offence)) +
    # Make x labels vertical
    ggplot2::theme(axis.text.x = ggplot2::element_text(angle = 90, hjust = 1))
}

op_geocode = function(d, region = "West Yorkshire") {
    d_locations_string = d |>
        dplyr::pull(location)
    d_locations_string = paste(d_locations_string, region, sep = ", ")
        
    d_locations = lapply(d_locations_string, FUN = stplanr::geo_code)
    
    d_locations_lengths = sapply(d_locations, function(x) {
        length(x)
    })
    d_is_geo = d_locations_lengths > 0
    d_with_geo = d[d_is_geo, ]
    d_locations = d_locations[d_is_geo]
    
    d_point = lapply(d_locations, function(x) {
        sf::st_point(matrix(x, ncol = 2))
    })
    d_sfc = sf::st_sfc(d_point) |>
        sf::st_sf(crs = "EPSG:4326")
    d_sf = sf::st_sf(
        d_with_geo,
        geometry = d_sfc |> sf::st_geometry()
    )
    
    return(d_sf)
}