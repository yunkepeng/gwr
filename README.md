# Examples for gwr
# Description
The code gwr provides a function to extract site-based values (given latitude, longitude and elevations) from gridded climate station data, including WFDEI, CRU and some others (still on development), based on an existing package "spgwr". This can be done in daily or monthly average, and encompassing temperature, precipitations, radiations etc. Here we considered elevation as the (only) explanatory variable, and then setting a specific bandwidth (default:1.06) to extract site values from gridded data. 

Here bandwidth, in simple words, defined as the distance of area we want to focus that surrounded the site. ArcGIS-GWR tool has defined this as: "GWR constructs a separate equation for every feature in the dataset incorporating the dependent and explanatory variables of features within the bandwidth of each target feature". We selected 1.06 as a reasonably accepted value, if attempting to extract a site from a 0.5° * 0.5° gridded data. 

For detailed information of gwr please check description here: https://pro.arcgis.com/en/pro-app/tool-reference/spatial-statistics/geographically-weighted-regression.htm

Comparing with the conventional method (e.g. extract sites directly from raster in ArcGIS), This method shows an advantage when focusing on a small-scale study, for example in an elevational gradient transect. Because the elevation should be necessarily considered as an explanatory variable to make such an interpolation. This method has been recently used in Peng et al. 2020 New Phytologist (https://nph.onlinelibrary.wiley.com/doi/abs/10.1111/nph.16447).

# Use
1. Install package ncdf4, spgwr and raster.

2. Download nc file for coordinates of all grid (WFD-land-lat-long-z.nc) and an example Shortwave radiation file (SWdown_daily_WFD_196001.nc) in github.

3. Using ncdf4 to convert nc file in useful dataframe.
  - First, input WFD-land-lat-long-z.nc for coordinates of all grid (n = 67420 for lat,lon,z - here is 67420 rather than 720*360 because NA values have been omitted in advance)
  - Second, input SWdown_daily_WFD_196001.nc for example Shortwave radiation file (n = 67420 for 31 days average within one month, as an example, here is 1960/01).
  *Two nc file above can be originall downloaded at WFDEI.
  - Last, Combine first and second data, which forms a dataframe 67420 (grid) *34 (lat, lon, z, 31 days)
  
4. Input site we would like to extract

5. Start implementing GWR
  - First (very important), unlike select the whole global grid in gwr, we are only interested in site ± 1.5 degrees grid. As mentioned earlier, the bandwidth is 1.06, so subsetting site ± 1.5 degree grids for extraction is pretty enough. Therefore the first step here is to subset grids, as this will largely save our work if focusing on mulitiple sites.
  - Convert the "dataframe-based" gridded data above to (real) "grids".  
  - Set coordinates for both sites and grids, which makes sure it can be inputted in gwr
  - Running gwr, and within this, set bandwidth = 1.06. 
  
  
 # Future
This is just an initial attempt to get this method public available. It can also been well used in CRU, but note that the total numbers of grid is different between CRU and WFDEI (here n = 67420 after removing NA, but CRU may have more grids...) So please download relevant coordinates and elevations for CRU separately, and then repeating this analysis.

Some other data such as FLUXNET is still under development. 
