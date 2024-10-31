import pandas as pd

# Read the first CSV file containing 'grdc_no' and 'obs' columns
pcr_area_file_path = '/scratch-shared/bisik/Data/preprocess/allpoints_catchAttr.csv'
pcr_area_columns = ['lon','lat', 'area_pcr']  # Specify columns to read
pcr_area_df = pd.read_csv(pcr_area_file_path, usecols=pcr_area_columns)

# Calculate the average 'obs' value for each 'grdc_no'
#pcr_area_avg_df = pcr_area_df.groupby('grdc_no').mean().reset_index()

# Read the second CSV file containing 'grdc_no', 'longitude', and 'latitude' columns
lonlat_file_path = '/scratch-shared/bisik/Data/preprocess/station_pixel_mapping_grdc.csv'
lonlat_columns = ['grdc_no', 'lon', 'lat']  # Specify columns to read
lonlat_df = pd.read_csv(lonlat_file_path, usecols=lonlat_columns)

# Read the third CSV file containing 'area', 'grdc'
lonlat_grdc_file_path = '/home/2787849/reanalysis_test/Practical/stationLatLon_grdc.csv'
lonlat_grdc_columns = ['grdc_no','area']
lonlat_grdc_df = pd.read_csv(lonlat_grdc_file_path, usecols=lonlat_grdc_columns)

# Merge the two dataframes based on the 'grdc_no' column
merged_data = pd.merge(lonlat_grdc_df, lonlat_df, on='grdc_no')

# Exclude the 'grdc_no' column from the final merged dataframe
#merged_data_lanlot_grdc = merged_data.drop(columns=['grdc_no'])

#print(merged_data_lanlot_grdc.columns)

merged_data_areas = pd.merge (merged_data, pcr_area_df, on= ['lon', 'lat'])

print(merged_data_areas.columns)


# Save the merged dataframe to a new CSV file
merged_data_areas.to_csv('PCR_grdc_area.csv', index=False)
