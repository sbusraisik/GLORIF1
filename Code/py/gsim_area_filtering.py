import pandas as pd

# Load the CSV file
df2 = pd.read_csv("/home/bisik/Practical/gsim_preprocess/filtered_GSIM_catchment_characteristics.csv")

# Select relevant columns
selected_columns = df2[['lon', 'lat', 'area.est', 'gsim.no']]

# Identify gsim.no with area.est smaller than 2500 square kilometers (too small catchments)
gsim_no_to_exclude = selected_columns[selected_columns['area.est'] < 10000]['gsim.no'].unique()

# Exclude those gsim.no from the dataframe
final_df = df2[~df2['gsim.no'].isin(gsim_no_to_exclude)]

# Display the first few rows of the final dataframe
print(final_df.head())

# Save the final dataframe to CSV
final_df.to_csv("/scratch-shared/bisik/Data/preprocess/preprocess_gsim/gsim_area_excluded.csv", index=False)
