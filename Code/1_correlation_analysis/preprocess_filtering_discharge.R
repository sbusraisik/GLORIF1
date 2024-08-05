library(ggplot2)
library(dplyr)

# Load the data using read.table for whitespace delimited data
df1 <- read.csv("/home/bisik/Practical/rf_input/bigTable_allpredictors_final_2.csv")
df2 <-read.csv("/home/bisik/Practical/stationLatLon_grdc.csv")


selected_columns <- df1 %>%
  select(obs, pcr, grdc_no)
head(selected_columns)


# Calculate the 95th percentile of the absolute differences
difference_threshold <- selected_columns %>%
  mutate(difference = abs(obs - pcr)) %>%
  summarise(threshold = quantile(difference, 0.95)) %>%
  pull(threshold)

print(paste("The 95th percentile threshold for differences is:", difference_threshold))

# Identify grdc_no with differences exceeding the 95th percentile threshold
grdc_to_exclude <- selected_columns %>%
  filter(abs(obs - pcr) > difference_threshold) %>%
  distinct(grdc_no)


# Exclude those grdc_no from the dataframe
final_predictors_table <- df1 %>%
  filter(!grdc_no %in% grdc_to_exclude$grdc_no)
write.csv(final_predictors_table, "/home/bisik/Practical/rf_input/bigTable_allpredictors_final_NEW.csv", row.names = FALSE)

final_stationLatLon <- df2 %>%
  filter(!grdc_no %in% grdc_to_exclude$grdc_no)
write.csv(final_stationLatLon, "/home/bisik/Practical/stationLatLon_filtered_95.csv", row.names = FALSE)


