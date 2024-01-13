import sys
import xarray as xr
import numpy as np
from netCDF4 import Dataset

print(sys.argv[1],sys.argv[2])
date = sys.argv[1]
time = sys.argv[2]

root = "/home/jturner/false_low_clouds_2023/Model/Model_flc_v2_data/"
region = "Georges_Bank"

#---Opening the GFS file
gfs_file = root+"time_"+time+"/"+date+"/gfs.t"+time+".pgrb2.0p25.f000"
gfs_ds = xr.open_dataset(gfs_file, engine="cfgrib",backend_kwargs={'filter_by_keys': {'typeOfLevel':'isobaricInhPa'}})

#---Creating the SST file
sst_file = root+"time_"+time+"/"+date+"/oisst-avhrr-v02r01."+date+".nc"
sst_ds = xr.open_dataset(sst_file)
sst_ds = sst_ds.squeeze()
sst_ds.sst.values = sst_ds.sst.values+273.15

#---Georges Bank
min_lon = -71.5
min_lat = 37
max_lon = -64
max_lat = 42.5

#---Filter to the region of interest
sst_ds = sst_ds.sel(lat=slice(min_lat,max_lat), lon=slice(min_lon+360,max_lon+360))
#------GFS data latitude is reversed compared to the SST data, this flips it into position.
gfs_ds = gfs_ds.sel(latitude=slice(None, None, -1))
gfs_ds = gfs_ds.sel(latitude=slice(min_lat,max_lat), longitude=slice(min_lon+360,max_lon+360))

#---Finding the altitudes of max humidity
max_humidity_indices = gfs_ds['q'].argmax(dim='isobaricInhPa')

#---For some bizarre reason, this initialization of T_maxq seems to be necessary
#---Another bizarre action is that this changes dims to a numpy array
begin = sst_ds.sst.shape[0]
end = sst_ds.sst.shape[1]
dims = gfs_ds.t.values[0][0:begin,0:end]
T_maxq = np.zeros(dims.shape)
T_maxq = gfs_ds['t'].isel(isobaricInhPa=max_humidity_indices)

#---Difference between SST and temperature at most moist layer
T_diff = T_maxq[0:begin,0:end].values - sst_ds.sst[:,:].values

#---Creating the netCDF file
nc_name = root+"time_"+time+"/"+region+"/"+date+".nc"
ncfile = Dataset(nc_name, mode='w', format='NETCDF4_CLASSIC')

lat_dim = ncfile.createDimension('lat', len(sst_ds.lat))
lon_dim = ncfile.createDimension('lon', len(sst_ds.lon))

lat = ncfile.createVariable('lat', np.float32, ('lat',))
lat.units = 'degrees_north'
lat.long_name = 'latitude'
lon = ncfile.createVariable('lon', np.float32, ('lon',))
lon.units = 'degrees_east'
lon.long_name = 'longitude'

t_diff_nc = ncfile.createVariable('t_diff',np.float64,('lat','lon'))
t_diff_nc.units = 'K'
t_diff_nc.standard_name = 'Temperature difference'

lat[:] = sst_ds.lat
lon[:] = sst_ds.lon
t_diff_nc[:,:] = T_diff

ncfile.close()
print('Dataset completed: ',date)


