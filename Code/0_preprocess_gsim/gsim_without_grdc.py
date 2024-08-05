import pandas as pd

# Load the CSV files into DataFrames
gsim_df = pd.read_csv('/home/bisik/Practical/GSIM_metadata/GSIM_catalog/GSIM_catchment_characteristics.csv')
#gsim_df = pd.read_csv('/home/bisik/Practical/gsim_preprocess/station_to_pixel_mapping_gsim.csv')
grdc_df = pd.read_csv('/home/bisik/Practical/stationLatLon_grdc.csv')

# Rename the columns in gsim_df
gsim_df.rename(columns={'lat.org': 'lat', 'long.org': 'lon'}, inplace=True)

# Merge the DataFrames on 'lat' and 'lon' to identify the matching rows
merged_df = pd.merge(grdc_df, gsim_df, on=['lat', 'lon'], how='inner')

# Get the indices of matching rows in gsim_df (not merged_df)
matching_indices = gsim_df[gsim_df.set_index(['lat', 'lon']).index.isin(merged_df.set_index(['lat', 'lon']).index)].index

# Filter out the matching rows from gsim_df
filtered_gsim_df = gsim_df.drop(matching_indices)

# Save the filtered DataFrame to a new CSV file
filtered_gsim_df.to_csv('/home/bisik/Practical/gsim_preprocess/filtered_GSIM_catchment_characteristics.csv', index=False)
