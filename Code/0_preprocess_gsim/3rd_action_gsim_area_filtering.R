library(ggplot2)
library(dplyr)

df2 <- read.csv("/home/bisik/Practical/gsim_preprocess/filtered_GSIM_catchment_characteristics.csv")

selected_columns <- df2 %>%
  select(lon, lat, area.est, gsim.no)


# Identify gsim.no smaller than 2500 square kilometers (too small cacthments)
gsim.no_to_exclude <- selected_columns %>%
  filter(area.est < 10000) %>%
  distinct(gsim.no)

head(gsim.no_to_exclude)

# Exclude those gsim.no from the dataframe
final_df <- df2 %>%
  filter(!gsim.no %in% gsim.no_to_exclude$gsim.no) 


head(final_df)

# Save the final dataframe to CSV
write.csv(final_df, "/scratch-shared/bisik/Data/preprocess/preprocess_gsim/gsim_area_excluded.csv", row.names = FALSE)

