import sys
import xarray as xr
import numpy as np
import netCDF4 as nc

print(sys.argv[1],sys.argv[2])
date = sys.argv[1]
time = sys.argv[2]

#root = "/home/jturner/false_low_clouds_2023/Model/Time_Lapse/"
	
#--- Open atmos data (for temperature and humidity profile)
gfs_file = "time_"+time+"/"+date+"/gfs.t"+time+".pgrb2.0p25.f000"
gfs_ds = xr.open_dataset(gfs_file, engine="cfgrib",backend_kwargs={'filter_by_keys': {'typeOfLevel':'isobaricInhPa'}})


#--- Open SST data
sst_file = "time_"+time+"/"+date+"/oisst-avhrr-v02r01."+date+".nc"
sst_ds = xr.open_dataset(sst_file)
sst_ds =  sst_ds.squeeze()
sst_ds.sst.values = sst_ds.sst.values+273.15

#--- Filter to the Georges Bank region
min_lon = -71.5
min_lat = 37
max_lon = -64
max_lat = 42.5

sst_ds = sst_ds.sel(lat=slice(min_lat,max_lat), lon=slice(min_lon+360,max_lon+360))
#------ GFS data latitude is reversed compared to the SST data, this flips it into position.
gfs_ds = gfs_ds.sel(latitude=slice(None, None, -1))
gfs_ds = gfs_ds.sel(latitude=slice(min_lat,max_lat), longitude=slice(min_lon+360,max_lon+360))

#--- Use the temperature from the indices of max humidity
max_humidity_indices = gfs_ds['q'].argmax(dim='isobaricInhPa')

#--- Use the dimensions of the SST as standard
begin = sst_ds.sst.shape[0]
end = sst_ds.sst.shape[1]
dims = gfs_ds.t.values[0][0:begin,0:end]

#--- For some bizarre reason, this initialization of T_maxq seems to be necessary
#------ Another bizarre action is that this changes dims to a numpy array
T_maxq = np.zeros(dims.shape)
T_maxq = gfs_ds['t'].isel(isobaricInhPa=max_humidity_indices)

#--- Find the difference in temperature between atmos emission and SST
T_diff = T_maxq[0:begin,0:end].values - sst_ds.sst[:,:].values

#--- Create a new NetCDF file
ncfile = nc.Dataset("FLC_index_V2_data/"+date+"_"+time+".nc", "w", format="NETCDF4")
lat_dim = ncfile.createDimension("latitude", len(sst_ds.lat))
lon_dim = ncfile.createDimension("longitude", len(sst_ds.lon))
lat_var = ncfile.createVariable("latitude", "f4", ("latitude",))
lon_var = ncfile.createVariable("longitude", "f4", ("longitude",))
flc_index_v2_var = ncfile.createVariable("FLC_index_V2", "f4", ("latitude", "longitude"))
lat_var[:] = sst_ds.lat
lon_var[:] = sst_ds.lon
flc_index_v2_var[:] = T_diff
lat_var.units = "degrees_north"
lon_var.units = "degrees_east"
flc_index_v2_var.units = "degrees_Kelvin"
ncfile.close()
