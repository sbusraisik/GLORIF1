# GLORIF1

## Introduction
We create 30 arcmin resolution global streamflow data from the global hydrological model PCR-GLOBWB 2 ([Sutanudjaja et al., 2018](https://doi.org/10.5194/gmd-11-2429-2018)) using Random Forests Regression ([Breiman, 2001](https://doi.org/10.1023/A:1010933404324)), for the years 1979-2019.

This framework is an update of the method by [Magni et al., (2023)]([https://doi.org/10.1016/j.cageo.2021.105019](https://doi.org/10.2166/hydro.2023.217)) to a broader scale.


## Input data
Input data and outputs of the 30 arcmin run are available on Zenodo (Link)\
River discharge data was downloaded from the Global Runoff Data Centre ([GRDC](https://www.bafg.de/GRDC)). \
2286 stations with variable availability of observations were selected (min. area = 10 000 km<sup>2</sup>) \
River discharge data for validation was downloaded from The Global Streamflow Indices and Metadata Archive ([GSIM[https://doi.org/10.1594/PANGAEA.887470)\
1986 stations with variable availability of observations were selected (min. area = 10 000 km<sup>2</sup>) \
The selected stations can be found stationLatLon.csv (merged daily and monthly).

## Python module
For fast installation / update of necessary modules it is recommended to use the mamba package manager.\
Current dependencies: numpy, pandas, alive_progress, netCDF4, xarray, multiprocessing.

The python module is used to extract raw data into homogeneous .csv files.
- Extraction of GRDC discharge, either daily or monthly (from .txt)
- Extraction of GSIM discharge, monthly (from .mon)
- Filtering out the GRDC stations from GSIM data.
- Exraction of the station area and pcr_area info into one file.
- Extraction of PCR-GLOBWB upstream averaged parameters (from data/allpoints_catchAttr.csv into stationLatLon.csv)
- Extraction of PCR-GLOBWB upstream averaged meteo input and state variables (from .netCDF). 

## R module
The R module follows the post-processing phases described in **manuscript**.
Dependencies can be installed using fun_0_install_dependencies.R.
These are loaded at the beginning of each script using fun_0_load_library.R. 

### 0_preprocess_grdc
0. Upscales daily discharge to monthly, merges daily and monthly if a station has both, keeps upscaled daily if available at a timestep.
1. Merges stations from stationLatLon_daily.csv and stationLatLon_monthly.csv into stationLatLon.csv
2. Calculates % missing data for the modelled years (here 1979-2019).

### 0_preprocess_grdc
1. Turns observation discharge into flow depth for training
   
### 0_preprocess_gsim
gsim_without_grdc -> Filters out the GRDC stations from GSIM data.
gsim_area_filtering -> Filters the areas above 10 000 km<sup>2</sup>
1. Prepares all the GSIM discharge data from the stations that has at least 12 month of available data within the time range 1979-2019.
2. Calculates % missing data for the modelled years (here 1979-2019).

### 0_preprocess_predictors
0. Parameters: generates timeseries of static catchment attributes (.csv)
0. qMeteoStatevars: merges timeseries of meteo input and state variables (.csv)
1. Merge all predictors : merges Parameters and qMeteoStatevars (.csv)

### 1_correlation_analysis
bigTable : binds all stations predictor tables *allpredictors*

### 2_randomForest 
1. Tune -> Uses training table from 0 to tune Random Forest hyperparameters. 
2. Train / Testing -> Trains the RF algorithm by using the training table created in the preprocess using values from tuning process.
3. Reanalysis -> Creates new streamflow predictions for every pixel of the globe. 
4. Validation -> Calculates variable importance and KGE (before and after post-processing).

### 3_visualization
Used to visualize all modelling phases:
- Tuning Random Forest parameters. 
- Plot of variable importance with square-rooted mean decrease in impurity values of the top twenty variables. 
- KGE: boxplots of PCR-GLOBWB and GLORIF1. 
- KGE: global maps (PCR-GLOBWB vs. GLORIF1).
- KGE: cumulative distribution plots averaged for each configuration and location.
- Scattering plot of PCR-GLOBWB and GLORIF1 streamflow simulations.
