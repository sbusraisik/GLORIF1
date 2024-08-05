#### processing ####
calculate_missing <- function(i){ 
  
  station_no <- stationInfo$gsim.no[i]
  print(station_no)
  
  gsim <- read.csv(paste0(gsimDir,'gsim_', station_no,'.csv'))
  
  # Define the date range
  startDate <- '1979-04-01'
  endDate <- '2019-12-01'
  
  # Filter data within the date range
  obs <- gsim %>% filter(datetime >= startDate & datetime <= endDate) %>% 
    select(-datetime)
  
  # Calculate missing percentage
  missings <- apply(obs, 2, function(x) sum(is.na(x)))
  missing_perc <- round((missings / nrow(obs)) * 100, 2)
  
  # Check if there are at least 12 monthly timesteps with data
  gsim$month <- format(as.Date(gsim$datetime), "%Y-%m")
  monthly_counts <- gsim %>% group_by(month) %>% summarise(count = sum(!is.na(obs))) # Replace `obs` with the actual column name for flow data
  
  if (nrow(filter(monthly_counts, count > 0)) < 12){
    missing_perc[] <- 100
  }
  
  return(missing_perc)
}
