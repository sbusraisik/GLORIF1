source('/home/bisik/Practical/R/fun_0_loadLibrary.R')

#### create big table with all predictors to execute corranalysis ####
filePathPreds <- '/scratch-shared/bisik/predictors/pcr_allpredictors_training/'
fileListPreds <- list.files(filePathPreds)
filenames <- paste0(filePathPreds, fileListPreds)

# Function to read, modify each file, and append filename info as new columns
read_and_modify <- function(file_name) {
  parts <- strsplit(basename(file_name), "_|\\.")[[1]]
  grdc_no <- parts[3]
  cell_no_land <- parts[4]
  
  # Read the file using vroom
  data <- vroom(file_name, show_col_types = FALSE)
  
  # Add extracted parts as new columns
  data$grdc_no <- grdc_no
  data$cell_no_land <- cell_no_land
  
  return(data)
}

print('reading all tables...')
all_tables <- mclapply(filenames, read_and_modify, mc.cores = 24)

print('binding...')
bigTable <- do.call(rbind, all_tables)

# Ensure 'grdc_no' and 'cell_no_land' are in the desired positions
bigTable <- bigTable[, c('grdc_no', 'cell_no_land', setdiff(names(bigTable), c('grdc_no', 'cell_no_land')))]

bigTable <- na.omit(bigTable)

print('writing to disk...')
write.csv(bigTable, '/home/2787849/reanalysis_test/Practical/bigTable_allpredictors_final_2.csv', row.names = FALSE)
