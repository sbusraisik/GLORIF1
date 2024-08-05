library('ggh4x')
library('dplyr')
library('ggplot2')
library('tidyr')

outputDir <- paste0('/home/bisik/Practical/viz/')
dir.create(outputDir, showWarnings = FALSE, recursive = TRUE)

sc <- scale_color_manual(values=c("#E69F00", "#56B4E9", "#009E73", "#CC79A7"))

# Increase the base plot text size considerably
plot_text <- 20

outputDir <- paste0('/home/bisik/Practical/viz/tuningPlots/')
dir.create(outputDir, showWarnings = FALSE, recursive = TRUE)

# Path to the specific CSV file
tuning_dir <- paste0('/scratch-shared/bisik/predictors/tune_NEW/')
mtry_file <- read.csv(paste0(tuning_dir, 'hyper_grid_ntrees_10-900.csv'))

mtry_tuning <- mtry_file %>% arrange(., mtry)

mtryPlotData <- mtry_tuning %>% pivot_longer(cols = OOB_RMSE)
mtryPlotData <- mtryPlotData %>% select(-ntrees)

mtryPlot <- ggplot(mtryPlotData, aes(x = mtry, y = value)) +
  geom_line(linewidth = 2.2) +
  geom_point(size = 4.5, alpha = 1, show.legend = FALSE) +
  sc +  # Color scale
  ylab('OOB RMSE (m/d)\n') +
  #labs(title = 'Mtry Tuning Plot') +
  theme(
    plot.title = element_text(hjust = 0.5, size = plot_text * 1.2, face = 'bold'),  # Further increase title size
    axis.title.y = element_text(size = plot_text * 1.2),  # Further increase y-axis title size
    axis.text.y  = element_text(size = plot_text * 1.3),  # Further increase y-axis text size
    axis.title.x = element_text(size = plot_text * 1.2),  # Further increase x-axis title size
    axis.text.x  = element_text(size = plot_text * 1.3)   # Further increase x-axis text size
  )

# Reduce the size of the figure
ggsave(paste0(outputDir, 'tuningPlot_height_NEW3plot.pdf'), mtryPlot, height=13, width=15, units='in', dpi=600)
