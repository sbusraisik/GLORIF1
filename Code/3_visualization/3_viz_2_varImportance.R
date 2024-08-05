# Load necessary libraries
library(ggplot2)
library(dplyr)
library(tidyr)
library(stringr)

# Define directories and create the output directory
outputDir <- '/home/bisik/Practical/viz/varImportance/'
dir.create(outputDir, showWarnings = FALSE, recursive = TRUE)

# Define static variables
static <- c('airEntry1', 'airEntry2', 'aqThick', 'aridityIdx', 'bankArea',
            'bankDepth', 'bankWidth', 'demAverage', 'forestFraction',
            'groundwaterDepth', 'KSat1', 'KSat2', 'kSatAquifer', 
            'recessionCoeff', 'resWC1', 'resWC2', 'satWC1', 'satWC2', 
            'slopeLength', 'specificYield', 'storage1', 'storage2', 
            'storDepth1', 'storDepth2', 'tanSlope', 'catchment', 
            'poreSize1', 'poreSize2', 'percolationImp')

# Define file path for the single CSV file
filePathRF <- '/scratch-shared/bisik/Practical_NEW/train_NEW_95_filtered/varImportance.csv'

# Read in the variable importance data
viSetup <- read.csv(filePathRF)

# Ensure the column names match the expected names (e.g., "names", "importance")
colnames(viSetup) <- c("names", "importance")

# Rename 'pcr' to 'pcrFlowDepth'
index <- which(viSetup$names %in% c('pcr'))
viSetup[index, 1] <- 'pcrFlowDepth'

# Prepare plot data
plotData <- viSetup %>% 
  slice_max(n = 20, order_by = importance) %>%
  mutate(sqrt_importance = sqrt(importance)) %>%
  select(names, sqrt_importance)

# Assign predictor types
plotData <- plotData %>%
  mutate(predictorType = case_when(
    names %in% c('precipitation', 'temperature', 'referencePotET') ~ 'Meteorological input',
    names %in% static ~ 'Catchment attributes',
    TRUE ~ 'State variables and fluxes'
  ))

# Define plot colors and title
plotData$predictorType <- factor(plotData$predictorType, levels = c('State variables and fluxes', 'Meteorological input', 'Catchment attributes'))
colors <- c('#008080', "#e66464", "#E69F00") 
#pTitle <- "Variable Importance Plot"

# Create the plot
viPlot <- ggplot(plotData) +
  geom_col(aes(reorder(names, sqrt_importance), sqrt_importance, fill = predictorType), position = 'dodge') +
  coord_flip() +
  theme_light() +
  labs(x = NULL, y = "Square Root of Importance") +
  scale_fill_manual(values = colors, drop = FALSE) +
  theme(
    axis.text.y = element_text(size = 28),
    axis.text.x = element_text(size = 28),
    title = element_text(size = 28),
    legend.title = element_blank(),
    legend.key.size = unit(1, 'cm'),
    legend.text = element_text(size = 28),
    legend.spacing.x = unit(0.5, 'cm')
  )

# Save the plot
ggsave(paste0(outputDir, 'variable_importance_plot_NEWATTEMPT_9.pdf'), viPlot, height = 18, width = 20, units = 'in', dpi = 300)
