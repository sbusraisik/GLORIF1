# function to apply a trained RF to unseen data
# it writes complete tables and stores KGE

# key = qstatevars, allpredictors
apply_optimalRF <- function(i, key){
    
    station_no <- stationInfo$cell_no_land[i]
    print(station_no)
    
    pcr_discharge <- read.csv(paste0('/scratch-shared/bisik/Data/predictors/pcr_flowdepth/pcr_discharge_',
                                     station_no, '.csv')) %>% mutate(datetime=as.Date(datetime))
    
    if(sum(pcr_discharge$pcr==0)){
      
      pcr_reanalysis <- pcr_discharge %>% rename(pcr_corrected=pcr) %>%
                            mutate(datetime=as.Date(datetime))
      write.csv(pcr_reanalysis, paste0(outputDirReanalysis, 'pcr_rf_reanalysis_monthly_30arcmin_',
                                       station_no, '.csv'), row.names=F)
      
    }
    else{
      
      test_data <- read.csv(paste0('/scratch-shared/bisik/pcr_allpredictors/pcr_allpredictors_',
                                   station_no, '.csv')) #%>% select (datetime,pcr,precipitation,temperature,referencePotET)
                               
                                     
      pcr_reanalysis <- test_data %>% 
        # predict discharge with trained RF
        mutate(pcr_corrected = predict(optimal_ranger, test_data, num.threads=NULL) %>% predictions()) %>%
        # if pcr_corrected < 0 -> pcr_corrected=0
        mutate(pcr_corrected = replace(pcr_corrected, pcr_corrected<0,0)) %>% 
        # select datetime, pcr_corrected (pcr uncalib can be found in scratch/6574882/pcr_discharge)
        select(., c('datetime', 'pcr_corrected')) %>% 
        # format
        mutate(datetime=as.Date(datetime))
      colnames(pcr_reanalysis) <- c('datetime','pcr_corrected')
      
      write.csv(pcr_reanalysis, paste0(outputDirReanalysis, 'pcr_rf_reanalysis_monthly_30arcmin_',
                                       station_no, '.csv'), row.names=F)
      
    }
}
