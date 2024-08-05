#### processing ####
# 1. Read monthly (if exists) GRDC timeseries 
# 2. Shift obs values from the last day of the month to the first day of the same month

reanalyse_grdc_discharge <- function(i){ 
  station_no <- stationInfo$gsim.no[i]
  print(station_no)
  
  # Process only monthly data
  if(file.exists(paste0(gsimMonthlyDir, 'gsim_monthly_',station_no,'.csv'))){
    obsMonthly <- vroom(paste0(gsimMonthlyDir, 'gsim_monthly_',station_no, '.csv'), show_col_types=FALSE) %>%
      mutate(datetime=as.Date(datetime)) %>%
      replace_with_na(.,replace = list(obs = -999)) %>%
      replace_with_na(.,replace = list(calculated = -999))
    
    # Shift obs values from the last day of the month to the first day of the same month
    obsMonthly <- obsMonthly %>%
      mutate(datetime = as.Date(format(datetime, "%Y-%m-01")))
    
    # Merge with datesMonthly to extend the series, but keep only existing data from obsMonthly
    obsMonthlyExt <- merge(datesMonthly, obsMonthly, by="datetime", all.x=TRUE)
    
    # Cut the time series at the specified start and end dates
    obsMonthlyNew <- obsMonthlyExt[which(obsMonthlyExt$datetime >= as.Date(startDate) & obsMonthlyExt$datetime <= as.Date(endDateMonthly)),] %>% 
      mutate(datetime=as.Date(datetime))
    row.names(obsMonthlyNew) <- NULL
    
    #### Assign new monthly observations #### 
    obsReanalysis <- obsMonthlyNew %>% select(datetime, obs)
  } else {
    # If no monthly data exists, simply use datesMonthly without adding NA values
    obsReanalysis <- datesMonthly
    obsReanalysis$obs <- NA
  }
  
  # Write to disk
  write.csv(obsReanalysis, paste0(outputDir,'gsim_',station_no,'.csv'), row.names=FALSE)
}
