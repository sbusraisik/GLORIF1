create_predictor_table <- function(i){
  
  station_no <- stationInfo$cell_no_land[i]
  upstreamArea_point <- upstreamArea$area_pcr[i]
  print(station_no)
    
    pcr <- read.csv(paste0(filePathDischarge, 'pcr_discharge_', station_no, '.csv')) %>%
       mutate(datetime=as.Date(datetime)) %>% mutate(pcr=pcr/upstreamArea_point*0.0864)
  
    #obs <- read.csv(paste0(filePathDischargeGRDC, 'grdc_', station_no, '.csv')) %>%
    #  mutate(datetime=as.Date(datetime)) %>% mutate(obs=obs/upstreamArea_point*0.0864)
    
  
  write.csv(pcr, paste0(outputDir, 'pcr_discharge_',
                               station_no, '.csv'), row.names = F)
}
