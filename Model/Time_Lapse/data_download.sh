#! /usr/bin/bash
for date in 20230301 20230302 20230303
do
	dtime=00z

	#---Commented out "if" in order to reprocess data with u and v"
	#if [ -d time_$dtime/$date ]; then
	#echo "directory exists"
	#else
	
	#---Commented out SST because it was making a second copy
	#wget https://www.ncei.noaa.gov/thredds/fileServer/OisstBase/NetCDF/V2.1/AVHRR/${date:0:6}/oisst-avhrr-v02r01."$date".nc -P time_$dtime/$date

	wget https://noaa-gfs-bdp-pds.s3.amazonaws.com/gfs."$date"/${dtime:0:2}/atmos/gfs.t"$dtime".pgrb2.0p25.f000 -P time_$dtime/$date

	python data_download_convert.py $date $dtime

	rm time_$dtime/$date/gfs*

	#fi

done
