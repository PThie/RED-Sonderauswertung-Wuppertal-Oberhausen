#--------------------------------------------------
# description

# This file is the main file that orchestrates the other coding files. It
# controls the data pipeline and defines the global settings.

###################################################
# PIPELINE SETTINGS
###################################################

#--------------------------------------------------
# load libraries

suppressPackageStartupMessages({
    library(targets)
    library(renv)
    library(dplyr)
    library(here)
    library(tarchetypes)
    library(fst)
    library(docstring)
    library(crew)
    library(glue)
    library(cli)
    library(gdata)
    library(qs)
    library(sf)
    library(data.table)
    library(arrow)
    library(stringr)
    library(autometric)
    library(kableExtra)
})

#--------------------------------------------------
# working directory

setwd(here())

#--------------------------------------------------
# load configurations

source(
    file.path(
        here::here(),
        "src",
        "helpers",
        "config.R"
    )
)

#--------------------------------------------------
# Pipeline settings

# target options
controller <- crew_controller_local(
    name = "worker",
    workers = 3,
    seconds_idle = 10,
    options_metrics = crew_options_metrics(
        path = file.path(
            config_paths()[["logs_path"]],
            "worker_metrics",
            "worker_metrics_history"
        ),
        seconds_interval = 1
    )
)

tar_option_set(
    resources = tar_resources(
        fst = tar_resources_fst(compress = 50)
    ),
    seed = 1,
    garbage_collection = TRUE,
    memory = "transient",
    controller = controller,
    retrieval = "worker",
    storage = "worker"
)

#--------------------------------------------------
# load R scripts

sub_directories <- list.dirs(
    config_paths()[["src_path"]],
    full.names = FALSE,
    recursive = FALSE
)

for (sub_directory in sub_directories) {
    if (sub_directory != "helpers") { 
        lapply(
            list.files(
                file.path(
                    config_paths()[["src_path"]],
                    sub_directory
                ),
                pattern = "\\.R$",
                full.names = TRUE,
                ignore.case = TRUE
            ),
            source
        )
    } else {
        files <- list.files(
            file.path(
                config_paths()[["src_path"]],
                sub_directory
            ),
            pattern = "\\.R$",
            full.names = TRUE,
            ignore.case = TRUE
        )
        files <- files[
            stringr::str_detect(
                files,
                "config.R$"
            ) == FALSE
        ]
        lapply(files, source)
    }
}

###################################################
# ACTUAL PIPELINE
###################################################

#--------------------------------------------------
# reading data

targets_reading <- rlang::list2(
    tar_file_read(
        oberhausen_shapes,
        file.path(
            config_paths()[["data_path"]],
            "raw",
            "oberhausen_shapes",
            "BA-Raeume.gpkg"
        ),
        reading_oberhausen_shapes(!!.x)
    ),
    tar_file_read(
        red_rents_data,
        file.path(
            config_paths()[["red_data_path"]],
            "WM_allVersions_ohneText.parquet"
        ),
        reading_red_data(!!.x)
    )
)

#--------------------------------------------------
# processing

targets_processing <- rlang::list2(
    tar_qs(
        oberhausen_cleaned,
        cleaning_oberhausen_shapes(
            oberhausen_data = oberhausen_shapes
        )
    ),
    tar_qs(
        red_data_cleaned,
        cleaning_red_data(
            red_data = red_rents_data
        )
    ),
    tar_fst(
        red_connected,
        connecting_red_oberhausen(
            red_data = red_data_cleaned,
            oberhausen_data = oberhausen_cleaned
        )
    ),
    tar_fst(
        red_anonymized,
        anonymizing_SUF(
            red_data = red_connected
        )
    )
)

#--------------------------------------------------
# pipeline stats

targets_pipeline_stats <- rlang::list2(
	tar_file(
		pipeline_stats,
		helpers_monitoring_pipeline(),
		cue = tar_cue(mode = "always")
	),
    tar_target(
        worker_stats,
        reading_worker_stats(),
        cue = tar_cue(mode = "always")
    )
)

#--------------------------------------------------
# combine all target branches

rlang::list2(
    targets_reading,
    targets_processing,
    targets_pipeline_stats
)