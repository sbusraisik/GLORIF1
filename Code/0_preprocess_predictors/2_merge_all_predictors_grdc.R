####-------------------------------####
source('/home/bisik/Practical/R/fun_0_loadLibrary.R')
####-------------------------------####

# Load station information
stationInfo <- read.csv('/home/bisik/Practical/station_pixel_mapping.csv')

# Define file paths
grdcPath <- '/scratch-shared/bisik/Data/predictors/grdc_predictors/'
pcrPath <- '/scratch-shared/bisik/Data/predictors/pcr_allpredictors/'
outputDir <- '/scratch-shared/bisik/Data/training/'

# Ensure the output directory exists
if (!dir.exists(outputDir)) {
  dir.create(outputDir, recursive = TRUE)
}

# Function to process each station
process_station <- function(station) {
  grdc_no <- station$grdc_no
  cell_no_land <- station$cell_no_land

  # Construct file names
  grdc_file_path <- paste0(grdcPath, 'grdc_predictors_', grdc_no, '.csv')
  pcr_file_path <- paste0(pcrPath, 'pcr_allpredictors_', cell_no_land, '.csv')
  output_file_path <- paste0(outputDir, 'pcr_allpredictors_', grdc_no, '_',cell_no_land, '.csv')

  # Check if both files exist
  if (!file.exists(grdc_file_path) || !file.exists(pcr_file_path)) {
    message(paste("Files not found for GRDC:", grdc_file_path, "or PCR:", pcr_file_path))
    return(invisible(NULL))
  }

  # Read data
  grdc_data <- read.csv(grdc_file_path)
  pcr_data <- read.csv(pcr_file_path)

  # Rename the column if present
  if ("grdc_no" %in% names(pcr_data)) {
    names(pcr_data)[names(pcr_data) == "grdc_no"] <- "cell_no_land"
  }

  # Merge data
  merged_data <- inner_join(grdc_data, pcr_data, by = "datetime")
  
  # Check if the merged data is not empty
  if (nrow(merged_data) == 0) {
    message(paste("No matching data to merge for:", grdc_file_path, "and", pcr_file_path))
    return(invisible(NULL))
  }

  # Write output
  write.csv(merged_data, output_file_path, row.names = FALSE)
  message(paste("Processed and saved merged file:", output_file_path))
}

# Apply function to all rows in stationInfo
invisible(lapply(split(stationInfo, seq(nrow(stationInfo))), process_station))

message("All processing completed.")
