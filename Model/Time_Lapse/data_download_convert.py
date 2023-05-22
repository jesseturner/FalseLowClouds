import sys
import xarray as xr

print(sys.argv[1])
date = sys.argv[1]

root = "/home/jturner/false_low_clouds_2023/Model/Time_Lapse/"
	
gfs_file = root+date+"/gfs.t00z.pgrb2.0p25.f000"
gfs_ds = xr.open_dataset(gfs_file, engine="cfgrib",backend_kwargs={'filter_by_keys': {'typeOfLevel':'isobaricInhPa'}})

min_press = 850 #mb
max_press = 1000 #mb

gfs_ds = gfs_ds.sel(isobaricInhPa=slice(max_press,min_press))

gfs_ds_mean = gfs_ds.mean(dim='isobaricInhPa')
gfs_ds_mean = gfs_ds_mean.squeeze()
gfs_ds_mean = gfs_ds_mean.reindex(latitude=gfs_ds_mean.latitude[::-1])

gfs_ds_max = gfs_ds.max(dim='isobaricInhPa')
gfs_ds_max = gfs_ds_max.squeeze()
gfs_ds_max = gfs_ds_max.reindex(latitude=gfs_ds_max.latitude[::-1])

t = gfs_ds_mean.t
t.to_netcdf(root+date+'/t_'+date+'.nc')

q = gfs_ds_max.q
q.to_netcdf(root+date+'/q_'+date+'.nc')
