####-------------------------------####
source('/home/bisik/Practical/R/fun_0_loadLibrary.R')
####-------------------------------####
source('/home/bisik/Practical/R/fun_2_2_trainRF.R')

outputDir <- '/scratch-shared/bisik/Practical_NEW/RF/train/'
dir.create(outputDir, showWarnings = F, recursive = T)

#-------train RF with tuned parameters on all available observations----------
#### all predictors ####
print('training: all predictors...')
train_data <- vroom(paste0('/home/bisik/Practical/rf_input/bigTable_allpredictors_filtered_2times.csv'),
                     show_col_types = F)
rf_input <- train_data %>% select(., -grdc_no, -cell_no_land, -datetime)
optimal_ranger <- trainRF(rf_input, num.trees=500, mtry=31, num.threads=48)

print('saving...')
saveRDS(optimal_ranger, paste0(outputDir,'trainedRF.rds'))                    
vi_df <- data.frame(names=names(optimal_ranger$variable.importance)) %>%
  mutate(importance=optimal_ranger$variable.importance)                     
write.csv(vi_df, paste0(outputDir,'varImportance.csv'), row.names=F)
