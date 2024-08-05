create_predictor_table <- function(i) {
  station_no <- stationInfo$cell_no_land[i]
  upstreamArea_point <- upstreamArea$area_pcr[i]
  print(station_no)
  
  ####-------pcr discharge-------####
  pcr <- read.csv(paste0(filePathDischarge, 'pcr_discharge_', station_no, '.csv')) %>%
    mutate(datetime = as.Date(datetime)) %>% mutate(pcr = pcr / upstreamArea_point * 0.0864)

  ####-------pcr state variables-------####
  pred <- read.csv(paste0(filePathStatevars, 'pcr_statevars_', station_no, '.csv')) %>%
    mutate(datetime = as.Date(datetime)) %>%
    select(-c('channelStorage', 'totLandSurfaceActuaET'))
    
    
  ####-------normalize statevars [-1 1] and join to pcr discharge-------####
  pred_norm <- pred %>% select(-datetime)
  pred_norm <- scale(pred_norm) %>%
    cbind(pred %>% select(datetime),.) %>%
    mutate(datetime=as.Date(datetime))
  pred_norm[is.na(pred_norm)] <- 0
  pred_table <- inner_join(pcr, pred_norm, by = 'datetime')
  
  write.csv(pred_table, paste0(outputDir, 'pcr_qstatevars_', station_no, '.csv'), row.names = FALSE)
}


