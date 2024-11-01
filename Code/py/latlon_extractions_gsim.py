import pandas as pd
import numpy as np
import os

output_directory = '/scratch-shared/bisik/Data/preprocess/preprocess_gsim/'
output_file = 'station_pixel_mapping_gsim.csv'
output_path = os.path.join(output_directory, output_file)

# Ensure the directory exists
os.makedirs(output_directory, exist_ok=True)

def near(array, value):
    """
    Find the index of the value closest to the given value in an array.
    """
    idx = (np.abs(array - value)).argmin()
    return idx

def assign_station_to_pixel(gsim_csv, pixel_latlon_csv, output_csv):
    # Load GSIM data, which contains grdc_no and geographical coordinates
    gsim_data = pd.read_csv(gsim_csv)
    print("GSIM Columns:", gsim_data.columns)  # Debug: Print column names

    # Load pixel data, which contains cell_no_land, lat, and lon
    pixels = pd.read_csv(pixel_latlon_csv)
    print("Pixel Columns:", pixels.columns)  # Debug: Print column names

    # Prepare a list to store the nearest pixel information for each GRDC station
    results = []

    for index, gsim in gsim_data.iterrows():
        gsim_lat = gsim['lat']
        gsim_lon = gsim['lon']
        gsim_no = gsim['gsim.no']

        # Find the nearest pixel
        distances = np.sqrt((pixels['lat'] - gsim_lat) ** 2 + (pixels['lon'] - gsim_lon) ** 2)
        nearest_pixel_index = distances.idxmin()

        # Debugging statement to check the type and value of nearest_pixel_index
        print(f"Nearest pixel index: {nearest_pixel_index}, Type: {type(nearest_pixel_index)}")

        # Ensure nearest_pixel_index is an integer
        nearest_pixel_index = int(nearest_pixel_index)

        nearest_pixel = pixels.iloc[nearest_pixel_index]

        # Store the result
        result = {
            'gsim.no': gsim_no,
            'cell_no_land': nearest_pixel['cell_no_land'],
            'lat': nearest_pixel['lat'],
            'lon': nearest_pixel['lon']
        }
        results.append(result)

    # Convert results to DataFrame
    results_df = pd.DataFrame(results)

    # Save results to CSV
    results_df.to_csv(output_csv, index=False)

# Example usage
assign_station_to_pixel(
    gsim_csv='/scratch-shared/bisik/Data/preprocess/preprocess_gsim/gsim_area_excluded.csv',
    pixel_latlon_csv='/scratch-shared/bisik/Data/preprocess/preprocess_grdc/stationLatLon_PCR.csv',
    output_csv=output_path
)
