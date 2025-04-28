exporting_red_data <- function(
    red_data = NULL
) {
    #' @title Exporting RED data
    #' 
    #' @description This function exports the RED data for Oberhausen.
    #' 
    #' @param red_data Data frame containing the connected RED data and
    #' Oberhausen shapes.
    #' 
    #' @return Data frame containing the exported RED data.
    #' @author Patrick Thiel

    #--------------------------------------------------
    # export

    data.table::fwrite(
        red_data,
        file.path(
            config_paths()[["data_path"]],
            "processed",
            "rents_oberhausen_prepared.csv"
        ),
        na = NA,
        sep = ";"
    )

    #--------------------------------------------------
    # return

    return(red_data)
}