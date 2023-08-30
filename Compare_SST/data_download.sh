data_link='https://data.remss.com/SST/daily/mw/v05.1/netcdf/2023/20230427120000-REMSS-L4_GHRSST-SSTfnd-MW_OI-GLOB-v02.0-fv05.1.nc'
#data_link='https://coastwatch.noaa.gov/pub/socd2/coastwatch/sst_blended/sst5km/night/ghrsst/2023/20230427000000-OSPO-L4_GHRSST-SSTfnd-Geo_Polar_Blended_Night-GLOB-v02.0-fv01.0.nc'


directory='MW_SST'
#directory='NOAA_SST'

wget $data_link -P $directory --no-check-certificate


