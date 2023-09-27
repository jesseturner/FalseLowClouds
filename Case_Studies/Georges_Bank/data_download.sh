#! /usr/bin/bash

for date in 20230908

do 

	dtime=00z

	if [ -d time_$dtime/$date ]; then
	echo "directory exists"
	else
    
    sst=https://www.ncei.noaa.gov/thredds/fileServer/OisstBase/NetCDF/V2.1/AVHRR/${date:0:6}/oisst-avhrr-v02r01."$date".nc
    sst_backup=https://www.ncei.noaa.gov/thredds/fileServer/OisstBase/NetCDF/V2.1/AVHRR/${date:0:6}/oisst-avhrr-v02r01."$date"_preliminary.nc
    
    wget $sst -P time_$dtime/$date || wget $sst_backup -P time_$dtime/$date

	wget https://noaa-gfs-bdp-pds.s3.amazonaws.com/gfs."$date"/${dtime:0:2}/atmos/gfs.t"$dtime".pgrb2.0p25.f000 -P time_$dtime/$date

	python create_flcindexv2_data.py $date $dtime

	#rm time_$dtime/$date/gfs*

	fi

done