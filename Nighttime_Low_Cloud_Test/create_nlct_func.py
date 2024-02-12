import sys
import xarray as xr
import os
import numpy as np
import fnmatch
import datetime
import pickle

abi_path = sys.argv[1]
nlct_path = sys.argv[2]

#print(abi_path)

path = abi_path[0:23]
filename = abi_path[23:]
#print(path)
#print(filename)

#--- Using full extent of GOES East
# min_lon = -180
# min_lat = -90
# max_lon = 0
# max_lat = 90

#--- Georges bank
# min_lon = -70.5
# min_lat = 39
# max_lon = -67
# max_lat = 43

#--- Oaxaca
min_lon = -109
min_lat = 10
max_lon = -81
max_lat = 24

#---Gulf Stream
# min_lon = -77
# min_lat = 33
# max_lon = -50
# max_lat = 45

#---Falklands
# min_lon = -75
# min_lat = -58
# max_lon = -50
# max_lat = -35


lats = (min_lat, max_lat)
lons = (min_lon, max_lon)

def calc_latlon(ds):
    # The math for this function was taken from 
    # https://makersportal.com/blog/2018/11/25/goes-r-satellite-latitude-and-longitude-grid-projection-algorithm
    x = ds.x
    y = ds.y
    goes_imager_projection = ds.goes_imager_projection
    
    x,y = np.meshgrid(x,y)
    
    r_eq = goes_imager_projection.attrs["semi_major_axis"]
    r_pol = goes_imager_projection.attrs["semi_minor_axis"]
    l_0 = goes_imager_projection.attrs["longitude_of_projection_origin"] * (np.pi/180)
    h_sat = goes_imager_projection.attrs["perspective_point_height"]
    H = r_eq + h_sat
    
    a = np.sin(x)**2 + (np.cos(x)**2 * (np.cos(y)**2 + (r_eq**2 / r_pol**2) * np.sin(y)**2))
    b = -2 * H * np.cos(x) * np.cos(y)
    c = H**2 - r_eq**2
    
    #--- Added absolute to remove error
    r_s = (-b - np.sqrt(np.absolute(b**2 - 4*a*c)))/(2*a)
    
    s_x = r_s * np.cos(x) * np.cos(y)
    s_y = -r_s * np.sin(x)
    s_z = r_s * np.cos(x) * np.sin(y)
    
    lat = np.arctan((r_eq**2 / r_pol**2) * (s_z / np.sqrt((H-s_x)**2 +s_y**2))) * (180/np.pi)
    lon = (l_0 - np.arctan(s_y / (H-s_x))) * (180/np.pi)
    
    ds = ds.assign_coords({
        "lat":(["y","x"],lat),
        "lon":(["y","x"],lon)
    })
    ds.lat.attrs["units"] = "degrees_north"
    ds.lon.attrs["units"] = "degrees_east"
    return ds



def get_xy_from_latlon(ds, lats, lons):
    lat1, lat2 = lats
    lon1, lon2 = lons

    lat = ds.lat.data
    lon = ds.lon.data
    
    x = ds.x.data
    y = ds.y.data
    
    x,y = np.meshgrid(x,y)
    
    x = x[(lat >= lat1) & (lat <= lat2) & (lon >= lon1) & (lon <= lon2)]
    y = y[(lat >= lat1) & (lat <= lat2) & (lon >= lon1) & (lon <= lon2)] 
    
    return ((min(x), max(x)), (min(y), max(y)))

def create_BTD(path, filename):

    data_07 = xr.open_dataset(abi_path)
    #---seperate the path and filename    

    year = filename[27:31]
    jul_day = filename[31:34]
    h = filename[34:36]
    m = filename[36:38]

    print('Processing 07 band for '+year+'-'+jul_day+' '+h+':'+m)

    ds_07 = calc_latlon(data_07)

    ((x1,x2), (y1, y2)) = get_xy_from_latlon(ds_07, lats, lons)

    subset_07 = ds_07.sel(x=slice(x1, x2), y=slice(y2, y1))

    #--- Search for corresponding Band 14 file:
    files = os.listdir(path) 
    pattern = 'OR_ABI-L1b-RadF-M6C14*'+filename[27:38]+'*.nc'
    filename_14 = str(fnmatch.filter(files, pattern)[0])

    data_14 = xr.open_dataset(path+'/'+filename_14)

    print('Processing 14 band for '+year+'-'+jul_day+' '+h+':'+m)

    ds_14 = calc_latlon(data_14)

    ((x1,x2), (y1, y2)) = get_xy_from_latlon(ds_14, lats, lons)

    subset_14 = ds_14.sel(x=slice(x1, x2), y=slice(y2, y1))

    #--- Calculate BTD and take product of the data over time
    T_07 = (subset_07.planck_fk2/(np.log((subset_07.planck_fk1/subset_07.Rad)+1)) - subset_07.planck_bc1)/subset_07.planck_bc2
    T_14 = (subset_14.planck_fk2/(np.log((subset_14.planck_fk1/subset_14.Rad)+1)) - subset_14.planck_bc1)/subset_14.planck_bc2

    BTD = T_14 - T_07
    
    yr_m_d = datetime.datetime.strptime(year+jul_day, '%Y%j').date()
    time_delta = datetime.timedelta(hours=int(h), minutes=int(m))
    dt = datetime.datetime.combine(yr_m_d, datetime.datetime.min.time()) + time_delta
    BTD = BTD.expand_dims({'time':[dt]})
    
    return BTD

#--- Running the function to create the BTD xarray

BTD = create_BTD(path, filename)

#--- Creating the datetime string

dt = BTD.time[0].values.astype(datetime.datetime)
python_dt = datetime.datetime.utcfromtimestamp(dt * 1e-9)
dt_str = python_dt.strftime("%Y_%m_%d_%HH_%MM")

#--- Saving the file in /Nighttime_Low_Cloud_Test
#------ Saving in netcdf form, instead of pickling the xarray (doesn't work with updates)

netcdf_path = nlct_path+"goes_e_ntlc_"+dt_str+".nc"

if os.path.exists(netcdf_path):
    os.remove(netcdf_path)
    
BTD.to_netcdf(netcdf_path)


print('Success --- NLCT for '+dt_str+'  produced')
