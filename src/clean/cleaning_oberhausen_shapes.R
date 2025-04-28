cleaning_oberhausen_shapes <- function(
    oberhausen_data = NULL
) {
    #' @title Cleaning Oberhausen shapes
    #' 
    #' @description This function preprocesses the Oberhausen shapes.
    #' 
    #' @param oberhausen_data Spatial data frame containing the Oberhausen
    #' shapes.
    #' 
    #' @return Spatial data frame containing the cleaned Oberhausen shapes.
    #' @author Patrick Thiel
    
    #--------------------------------------------------
    # rename columns

    oberhausen_prep <- oberhausen_data |>
        dplyr::rename(
            ba_raum = BA.Raum
        )

    sf::st_geometry(oberhausen_prep) <- "geometry"

    #--------------------------------------------------
    # convert to UTM

    oberhausen_prep <- sf::st_transform(
        oberhausen_prep,
        crs = config_globals()[["utmcrs"]]
    )

    #--------------------------------------------------
    # return

    return(oberhausen_prep)
}