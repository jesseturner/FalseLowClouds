import sys
import xarray as xr

print(sys.argv[1],sys.argv[2],sys.argv[3])
date = sys.argv[1]
dtime = sys.argv[2]
ftime = sys.argv[3]

root = "/home/jturner/false_low_clouds_2023/Model/Forecast/"

#---Will need to change the forecast time in the path, or make it variable
gfs_file = root+"time_"+dtime+"_"+ftime+"/"+date+"/gfs.t"+dtime+".pgrb2.0p25.f300"
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
t.to_netcdf(root+"time_"+dtime+"_"+ftime+"/"+date+'/t_'+date+'.nc')

u = gfs_ds_mean.u
u.to_netcdf(root+"time_"+dtime+"_"+ftime+"/"+date+'/u_'+date+'.nc')

v = gfs_ds_mean.v
v.to_netcdf(root+"time_"+dtime+"_"+ftime+"/"+date+'/v_'+date+'.nc')

q = gfs_ds_max.q
q.to_netcdf(root+"time_"+dtime+"_"+ftime+"/"+date+'/q_'+date+'.nc')
