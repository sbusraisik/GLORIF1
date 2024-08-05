####-------------------------------####
source('/home/bisik/Practical/R/fun_0_loadLibrary.R')
####-------------------------------####

stationInfo <- read.csv('/home/bisik/Practical/stationLatLon.csv')

#pcr-globwb time series 1979-2019
filePathDischarge <- '/scratch-shared/bisik/predictors/pcr_discharge/'
filePathStatevars <- '/scratch-shared/bisik/predictors/pcr_statevars/'

upstreamArea <- read.csv('/scratch-shared/bisik/predictors/preprocess/upstream_area.txt', sep = "" , header = F)
colnames(upstreamArea) <- c('lon', 'lat', 'area_pcr')
upstreamArea$area_pcr <- upstreamArea$area_pcr / 1000000 # m2 to km2

outputDir <- '/scratch-shared/bisik/predictors/pcr_qstatevars/'
dir.create(outputDir, showWarnings = FALSE, recursive = TRUE)

# datetime as pcr-globwb run
startDate <- '1979-01-01'
endDate <- '2019-12-31'
dates <- seq(as.Date("1979-01-01"), as.Date("2019-12-31"), by = "month")

source('/home/bisik/Practical/R/fun_0_preprocess_pcr_qstatevars.R')
mclapply(1:nrow(stationInfo), create_predictor_table, mc.cores = 48)
