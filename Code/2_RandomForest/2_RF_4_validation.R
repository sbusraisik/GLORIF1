####-------------------------------####
source('/home/bisik/Practical/R/fun_0_loadLibrary.R')
####-------------------------------####
source('/home/bisik/Practical/R/fun_2_2_trainRF.R')
source('/home/bisik/Practical/R/fun_2_3_apply_optimalRF_validation_GRDC_PCR.R')

# Paths
#predictions_dir <- '/scratch-shared/bisik/Practical_NEW/reanalysis_NEW_95_filtered/reanalysis_discharge/' # for predictors
predictions_dir <- '/scratch-shared/bisik/predictors/pcr_discharge/' # for pcr discharge
validation_file <- '/scratch-shared/bisik/predictors/grdc_discharge/' # for validation based on grdc discharge
#validation_dir <- '/home/bisik/Practical/gsim_preprocess/gsim_discharge_areafiltered_2_timefiltered/' # for validation based on gsim discharge
mapping_file <- '/home/bisik/Practical/station_to_pixel_mapping_3.csv'

# Load the mapping file
station_to_pixel_mapping <- read.csv(mapping_file)

# Process all mappings
results <- lapply(1:nrow(station_to_pixel_mapping), function(i) {
  process_mapping(station_to_pixel_mapping[i, ])
})

# Filter out NULL results
results <- do.call(rbind, results[!sapply(results, is.null)])

# Save results
outputDir <- '/scratch-shared/bisik/Practical_NEW/reanalysis_NEW_95_filtered/validation_NEW_Areafiltered/'
dir.create(outputDir, showWarnings = F, recursive = T)
write.csv(results, paste0(outputDir, 'kge_results_grdc_pcr_validation.csv'), row.names = F)
