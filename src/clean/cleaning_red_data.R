cleaning_red_data <- function(
    red_data = NULL
) {
    #' @title Cleaning RED data
    #' 
    #' @description This function cleans the RED data for Oberhausen.
    #' 
    #' @param red_data Data frame containing the original RED data.
    #' 
    #' @return Data frame containing the cleaned RED data.
    #' @author Patrick Thiel

    #--------------------------------------------------
    # restrict to 2020-2024 (as requested)

    red_data_prep <- red_data |>
        dplyr::filter(ejahr >= 2020 & ejahr <= 2024)

    #--------------------------------------------------
    # restrict to Oberhausen (as requested)

    red_oberhausen <- red_data_prep |>
        dplyr::filter(gid2019 == 5119000)

    #--------------------------------------------------
    # check non-emptiness

    tar_assert_nonempty(
        red_oberhausen,
        msg = glue::glue(
            "!!! WARNING: ",
            "The RED data for Oberhausen is empty!",
            " (Error code: crd#1)"
        )
    )

    #--------------------------------------------------
    # set as spatial feature

    red_oberhausen <- red_oberhausen |>
        sf::st_as_sf(
            coords = c("lon_utm", "lat_utm"),
            crs = config_globals()[["utmcrs"]],
            remove = FALSE
        )

    #--------------------------------------------------
    # return

    return(red_oberhausen)
}