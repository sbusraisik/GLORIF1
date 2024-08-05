####-------------------------------####
source('/home/bisik/Practical/R/fun_0_loadLibrary.R')
####-------------------------------####

outputDir <- '/home/bisik/Practical/viz/'
dir.create(outputDir, showWarnings = F, recursive = T)

# Define file paths
#uncalibrated_file <- '/scratch-shared/bisik/Practical_NEW/reanalysis_NEW_95_filtered/validation_NEW_Areafiltered/kge_results_grdc_pcr_validation.csv' #grdc validated pcr
uncalibrated_file <- '/scratch-shared/bisik/Practical_NEW/reanalysis_NEW_95_filtered/validation/KGE_results_PCR_GSIM_validation.csv' #gsim validated pcr
calibrated_file <- '/scratch-shared/bisik/Practical_NEW/reanalysis_NEW_95_filtered/validation/KGE_results_RF_GSIM_validation.csv' #gsim validated RF Predictions
#calibrated_file <- '/scratch-shared/bisik/Practical_NEW/reanalysis_NEW_95_filtered/validation_NEW_Areafiltered/kge_results_grdc_discharge.csv' #grdc validated RF predictions

# Read uncalibrated data
rf.eval.uncalibrated <- read.csv(uncalibrated_file) %>%
  select(cell_no_land, KGE, KGE_r, KGE_alpha, KGE_beta) %>%
  mutate(setup = factor('pcrpredictions'))

# Read calibrated data
rf.eval <- read.csv(calibrated_file) %>%
  select(cell_no_land, KGE, KGE_r, KGE_alpha, KGE_beta) %>%
  mutate(setup = factor('rfpredictions'))

# Combine the uncalibrated and calibrated data
allData <- rbind(rf.eval.uncalibrated, rf.eval)

# Summarize the data
plotData <- allData %>%
  group_by(cell_no_land, setup) %>%
  summarise(mean_KGE = mean(KGE), mean_KGE_r = mean(KGE_r), mean_KGE_a = mean(KGE_alpha), mean_KGE_b = mean(KGE_beta))

# Define plot levels and colors
plotLevels <- c('pcrpredictions', 'rfpredictions')
colors <- c('#E69F00', '#56B4E9')

# Set factor levels for setup
plotData$setup <- factor(plotData$setup, levels = plotLevels)

# Plot all ECDF
plot_text_size <- 30 
plot <- ggplot(plotData, aes(mean_KGE, color = setup)) +
  stat_ecdf(geom = 'step', linewidth = 2) +
  coord_cartesian(xlim = c(-5, 1)) +
  labs(title = 'ECDF of KGE (GSIM validation)', y = 'ECDF', x = 'KGE') +
  scale_color_manual(values = colors) +
  theme(plot.title = element_text(size = plot_text_size),
        axis.title.y = element_text(size = plot_text_size),
        axis.text.y = element_text(size = plot_text_size - 5),
        axis.title.x = element_text(size = plot_text_size),
        axis.text.x = element_text(size = plot_text_size - 5),
        panel.border = element_rect(linetype = 1, fill = NA),
        legend.position = 'bottom',
        legend.title = element_blank(),
        legend.key.size = unit(1, 'cm'),
        legend.text = element_text(size = plot_text_size + 10),
        strip.text = element_text(size = plot_text_size))

ggsave(paste0(outputDir, 'ECDF_results_GSIM_validation.pdf'), plot, height = 20, width = 20, units = 'in', dpi = 600)
