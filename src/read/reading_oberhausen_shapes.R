reading_oberhausen_shapes <- function(
    file_data_path = NULL
) {
    #' @title Reading Oberhausen shapes
    #' 
    #' @description This function reads the Oberhausen shapes from the specified
    #' file path.
    #' 
    #' @param file_data_path Path to the data file.
    #' 
    #' @return Spatial data frame containing the Oberhausen shapes.
    #' @author Patrick Thiel

    #--------------------------------------------------
    # read data

    dta <- sf::st_read(
        file_data_path
    )

    #--------------------------------------------------
    # return

    return(dta)
}