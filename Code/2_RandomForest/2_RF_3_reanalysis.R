####-------------------------------####
source('/home/bisik/Practical/R/fun_0_loadLibrary.R')
####-------------------------------####
source('/home/bisik/Practical/R/fun_2_3_apply_optimalRF.R')

stationInfo <- read.csv('/home/bisik/Practical/stationLatLon.csv')

outputDirReanalysis <- '/scratch-shared/bisik/Practical_NEW/reanalysis_TEST_3/reanalysis_flowdepth/'
dir.create(outputDirReanalysis, showWarnings = F, recursive = T)

# Define the date range
#start_date <- as.Date("1990-01-01")  # replace with the desired start date
#end_date <- as.Date("1995-01-01") 

#### reanalysis - predict residuals for test stations ####
#### all predictors
print('allpredictors: reading trained RF...')
optimal_ranger <- readRDS('/scratch-shared/bisik/Data/RF/train/trainedRF.rds')
print('calculation: initiated')

mclapply(1:nrow(stationInfo), key='allpredictors',apply_optimalRF, mc.cores=32)
