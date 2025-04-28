reading_red_data <- function(
    file_data_path = NULL
) {
    #' @title Reading RED data
    #' 
    #' @description This function reads the RED data from the specified
    #' file path focusing on apartment rents.
    #' 
    #' @param file_data_path Path to the data file.
    #' 
    #' @return Data frame containing the RED data.
    #' @author Patrick Thiel

    #--------------------------------------------------
    # read data

    dta <- arrow::read_parquet(
        file_data_path
    )

    #--------------------------------------------------
    # return

    return(dta)
} 