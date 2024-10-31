####-------------------------------####
source('/home/bisik/Practical/R/fun_0_loadLibrary.R')
####-------------------------------####

# set directories 
gsimMonthlyDir <- '/home/bisik/Practical/gsim_preprocess/gsim_discharge_monthly_areafiltered_2/'

outputDir <- '/home/bisik/Practical/gsim_preprocess/gsim_discharge_monthly_areafiltered_2_timefiltered/'
dir.create(outputDir, showWarnings = FALSE, recursive = TRUE)

stationInfo <- read.csv('/home/bisik/Practical/gsim_preprocess/station_to_pixel_mapping_gsim_areagrdcfiltered.csv')

# datetime as pcr-globwb run
startDate <- '1979-01-01'
endDateMonthly <- '2019-12-01'

# Generate sequence of dates for the first day of each month
datesMonthly <- as.data.frame(seq(as.Date(startDate), as.Date(endDateMonthly), by="months"))
colnames(datesMonthly) <- 'datetime'

source('/home/bisik/Practical/gsim_preprocess/fun_1_preprocess_gsim.R')
lapply(1:nrow(stationInfo), reanalyse_grdc_discharge)
