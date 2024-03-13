#--- Cloud search libraries
import s3fs
import requests

#--- Data libraries
import xarray as xr
import netCDF4


#--- Function code
#------- Input format: get_gfs_data(YYYY, MM, DD, hh [00,06,12,18])

def get_gfs_data(year, month, day, hour):
    
    fs = s3fs.S3FileSystem(anon=True)
    bucket = 'noaa-gfs-bdp-pds'
    path = 'enkfgdas.'+year+month+day+'/'+hour+'/atmos/mem001/gdas.t'+hour+'z.sfcf003.nc'

    print('--- Retrieving the GFS file from the AWS servers')

    resp = requests.get(f'https://'+bucket+'.s3.amazonaws.com/'+path)
    if str(resp) != '<Response [200]>':
        print('file not found in AWS servers')

    print('--- Opening the NetCDF file')

    nc = netCDF4.Dataset(path, memory = resp.content)
    ds = xr.open_dataset(xr.backends.NetCDF4DataStore(nc))
    #ds = xr.open_dataset(nc, engine="cfgrib", backend_kwargs={'filter_by_keys': {'typeOfLevel':'isobaricInhPa'}})
    
    return ds