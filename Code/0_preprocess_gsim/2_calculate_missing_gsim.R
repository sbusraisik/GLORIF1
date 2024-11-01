####-------------------------------####
source('/home/bisik/Practical/R/fun_0_loadLibrary.R')
####-------------------------------####

# Set directories 
gsimDir <- '/home/bisik/Practical/gsim_preprocess/gsim_discharge_monthly_areafiltered_2_timefiltered/'
stationInfo <- read.csv('/scratch-shared/bisik/Data/preprocess/preprocess_gsim/gsim_area_excluded.csv')

# Define the date range
startDate <- '1979-04-01'
endDate <- '2019-12-01'

# Load the calculate_missing function
source('/home/bisik/Practical/R/fun_2_calculate_missing_gsim.R')

# Apply the calculate_missing function to each station
missing_list <- lapply(1:nrow(stationInfo), calculate_missing)

missing_col <- do.call(rbind, missing_list) 
colnames(missing_col) <- 'miss'
summary(missing_col)

stationInfo <- cbind(stationInfo, missing_col) 
stationInfo <- stationInfo %>% filter(miss < 100)

write.csv(stationInfo, '/scratch-shared/bisik/Data/preprocess/preprocess_gsim/gsim_12months_missing_excluded.csv', row.names = FALSE)
