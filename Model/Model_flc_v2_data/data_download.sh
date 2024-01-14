#! /usr/bin/bash

for date in 20230909 20230910

do 

	dtime=06z

	if [ -d time_$dtime/$date ]; then
	echo "directory exists"
	else
    
    sst=https://www.ncei.noaa.gov/thredds/fileServer/OisstBase/NetCDF/V2.1/AVHRR/${date:0:6}/oisst-avhrr-v02r01."$date".nc
    sst_backup=https://www.ncei.noaa.gov/thredds/fileServer/OisstBase/NetCDF/V2.1/AVHRR/${date:0:6}/oisst-avhrr-v02r01."$date"_preliminary.nc
    
    wget --no-check-certificate $sst -P time_$dtime/$date || wget $sst_backup -P time_$dtime/$date
    echo "SST collected for "$date

	wget https://noaa-gfs-bdp-pds.s3.amazonaws.com/gfs."$date"/${dtime:0:2}/atmos/gfs.t"$dtime".pgrb2.0p25.f000 -P time_$dtime/$date
    echo "GFS collected for "$date

	python data_download_convert_v2.py $date $dtime

	rm -r time_$dtime/$date

	fi

done


