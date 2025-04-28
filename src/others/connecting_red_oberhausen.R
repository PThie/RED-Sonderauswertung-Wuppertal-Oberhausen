connecting_red_oberhausen <- function(
    red_data = NULL,
    oberhausen_data = NULL
) {
    #' @title Connecting RED data with Oberhausen shapes
    #' 
    #' @description This function connects the RED data with the Oberhausen
    #' shapes.
    #' 
    #' @param red_data Data frame containing the cleaned RED data.
    #' @param oberhausen_data Data frame containing the cleaned Oberhausen shapes.
    #' 
    #' @return Data frame containing the connected RED data and Oberhausen shapes.
    #' @author Patrick Thiel

    #--------------------------------------------------
    # split data whether or not there is a coordinate given

    red_wo_coords <- red_data |>
        dplyr::filter(lon_utm == -9) |>
        sf::st_drop_geometry()

    red_w_coords <- red_data |>
        dplyr::filter(lon_utm != -9)

    #--------------------------------------------------
    # join housing data with Oberhausen shapes

    red_oberhausen <- sf::st_join(
        red_w_coords,
        oberhausen_data,
        largest = TRUE,
        left = TRUE
    )

    red_oberhausen <- sf::st_drop_geometry(red_oberhausen)

    #--------------------------------------------------
    # create empty variable of Oberhausen ID for those without coordinates

    red_wo_coords$ba_raum <- NA

    #--------------------------------------------------
    # combine both datasets again

    red_complete <- dplyr::bind_rows(
        red_oberhausen,
        red_wo_coords
    )
    
    #--------------------------------------------------
    # return

    return(red_complete)
}