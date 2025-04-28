anonymizing_SUF <- function(
    red_data = NULL
) {
    #' @title Anonymizing RED data for Oberhausen
    #' 
    #' @description This function anonymizes the RED data for Oberhausen by
    #' removing sensitive variables.
    #' 
    #' @param red_data Data frame containing the connected RED data and
    #' Oberhausen shapes.
    #' 
    #' @return Data frame containing the anonymized RED data.
    #' @author Patrick Thiel

    #--------------------------------------------------
    # remove sensitive variables

    red_data <- red_data |>
        dplyr::select(
            -c(
                "ergg_1km",
                "lon_utm",
                "lat_utm",
                "lat_gps",
                "lon_gps",
                "geox",
                "geoy",
                "strasse",
                "ort",
                "hausnr",
                "koid",
                "laid",
                "skid_id",
                "sc_id",
                "ident",
                "merge_gid",
                "is24_stadt_kreis"
            )
        )

    #--------------------------------------------------
    # return

    return(red_data)
}