import pandas as pd
import os
import numpy as np
from alive_progress import alive_bar
import time

filePath = '/home/bisik/Practical/GSIM_indices/TIMESERIES/monthly/'
outputPath = '/home/bisik/Practical/gsim_preprocess/gsim_discharge_monthly_areafiltered_3/'
loc = pd.read_csv('/home/bisik/Practical/gsim_preprocess/station_to_pixel_mapping_gsim_areagrdcfiltered.csv')

if not os.path.exists(outputPath):
    os.makedirs(outputPath)

with alive_bar(len(loc), force_tty=True) as bar:
    
    for j in range(len(loc)):
        
        station_no = str(loc['gsim.no'][j])
        print (station_no)
        cell_no_land = str(int(loc['cell_no_land'][j]))  # Convert to int to remove .0 and then to string
        print(cell_no_land)

        # read discharge, values start from line 22 of .txt files idx[21]
        gsim_discharge = open(filePath + station_no + '.mon', encoding='unicode_escape')
        lines = gsim_discharge.readlines()

        # Skip header lines and create DataFrame
        df = pd.DataFrame(lines[21:])
        df = df[0].str.split(pat=',\t', expand=True)

        # Assign column names
        df.columns = ["date", "MEAN", "SD", "CV", "IQR", "MIN", "MAX", "MIN7", "MAX7", "n.missing", "n.available"]
        
        # Skip the first row which contains the header
        df = df.iloc[1:].copy()
        
        # Convert date and MEAN columns
        df['datetime'] = pd.to_datetime(df['date'], errors='coerce')
        df['obs'] = pd.to_numeric(df['MEAN'], errors='coerce')
        
        # Select relevant columns and save to CSV
        df = df[['datetime', 'obs']]
        output_filename = f'gsim_monthly_discharge_{cell_no_land}.csv'
        df.to_csv(os.path.join(outputPath, output_filename), index=False, float_format='%.3f', na_rep='NA')
        
        bar()
