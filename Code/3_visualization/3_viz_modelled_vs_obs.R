library(dplyr)
library(ggplot2)

# Read the cell_no_land values
#cat("Reading station_to_pixel_mapping.csv...\n")
#cell_no_land <- read.csv('/home/bisik/Practical/filtered_station_to_pixel_mapping.csv') %>% select(cell_no_land, grdc_no)
#cat("Done reading station_to_pixel_mapping.csv.\n")

cat("Reading station_to_pixel_mapping_gsim_areagrdcfiltered_12monhts.csv...\n")
cell_no_land <- read.csv('/scratch-shared/bisik/Data/preprocess/preprocess_gsim/gsim_12months_missing_excluded.csv') %>% select(cell_no_land, gsim.no)
cat("Done reading gsim_12months_missing_excluded.csv.\n")

# Generate file paths
cat("Generating file paths...\n")
rf_data_files <- paste0('/scratch-shared/bisik/Data/output/reanalysis_discharge/pcr_rf_reanalysis_monthly_30arcmin_', cell_no_land$cell_no_land, '.csv')
prediction_files <- paste0('/scratch-shared/bisik/Data/validation_data/gsim_discharge/gsim_', cell_no_land$gsim.no, '.csv') #for GSIM validation
#prediction_files <- paste0('/scratch-shared/bisik/predictors/grdc_discharge/grdc_', cell_no_land$grdc_no, '.csv') #for  GRDC validation
cat("File paths generated.\n")

# Initialize empty lists to store means
rf_means <- c()
prediction_means <- c()

# Calculate means for rf_data files
cat("Calculating means for rf_data files...\n")
for (file in rf_data_files) {
  cat("Processing file:", file, "\n")
  if (file.exists(file)) {
    data <- read.csv(file)
    if ("pcr_corrected" %in% colnames(data)) {
      rf_means <- c(rf_means, mean(data$pcr_corrected, na.rm = TRUE))
    } else {
      warning(paste("Column 'pcr_corrected' does not exist in", file))
    }
  } else {
    warning(paste("The file", file, "does not exist."))
  }
}
cat("Done calculating means for rf_data files.\n")

# Calculate means for prediction files
cat("Calculating means for prediction files...\n")
for (file in prediction_files) {
  cat("Processing file:", file, "\n")
  if (file.exists(file)) {
    data <- read.csv(file)
    if ("obs" %in% colnames(data)) {
      prediction_means <- c(prediction_means, mean(data$obs, na.rm = TRUE))
    } else {
      warning(paste("Column 'obs' does not exist in", file))
    }
  } else {
    warning(paste("The file", file, "does not exist."))
  }
}
cat("Done calculating means for prediction files.\n")

# Create a data frame combining the means
cat("Creating data frame...\n")
plot_data <- data.frame(Observed_Mean = prediction_means, Modeled_Mean = rf_means)
cat("Data frame created.\n")


# Create a scatter plot with different colors for the datasets
cat("Creating scatter plot...\n")
max_value <- max(c(plot_data$Observed_Mean, plot_data$Modeled_Mean), na.rm = TRUE)

plot <- ggplot(plot_data, aes(x = Observed_Mean, y = Modeled_Mean)) +
  geom_point(color = 'steelblue', alpha = 0.5) +  # Change point color
  geom_abline(intercept = 0, slope = 1, color = 'darkred', linetype = 'dashed') +  # Change line color
  labs(title = "Observed vs Modeled Mean Streamflow",
       x = "Observed Mean Streamflow (m3/s)",
       y = "Modeled Mean Streamflow (m3/s)") +
  theme_minimal() +  # Use a minimal theme
  theme(plot.title = element_text(hjust = 0.5)) +  # Center the plot title
  scale_x_log10(limits = c(1, max_value)) +  # Logarithmic scale for x-axis with limits
  scale_y_log10(limits = c(1, max_value)) +  # Logarithmic scale for y-axis with limits
  coord_fixed(ratio = 1)  # Ensure equal aspect ratio

cat("Scatter plot created.\n")

# Ensure the directory exists before saving the plot
output_dir <- "/home/bisik/Practical/viz"
if (!dir.exists(output_dir)) {
  dir.create(output_dir, recursive = TRUE)
}

# Save the plot
cat("Saving plot...\n")
ggsave(file.path(output_dir, "obs_vs_model_mean_streamflow_GSIM_nofilter_logscale.pdf"), plot, width = 8, height = 6)
cat("Plot saved to", file.path(output_dir, "obs_vs_model_mean_streamflow_GSIM_nofilter_logscale.pdf"), "\n")

