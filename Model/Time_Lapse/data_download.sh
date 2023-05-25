#! /usr/bin/bash
for date in 20230316 20230317 20230318 20230319 20230320 20230321 20230322 20230323 20230324 20230325 20230326 20230327 20230328 20230329 20230330 20230331
do
	dtime=18z
	if [ -d time_$dtime/$date ]; then
	echo "directory exists"
	else
	
	#mkdir time_$dtime/$date
	
	wget https://www.ncei.noaa.gov/thredds/fileServer/OisstBase/NetCDF/V2.1/AVHRR/${date:0:6}/oisst-avhrr-v02r01."$date".nc -P time_$dtime/$date

	wget https://noaa-gfs-bdp-pds.s3.amazonaws.com/gfs."$date"/${dtime:0:2}/atmos/gfs.t"$dtime".pgrb2.0p25.f000 -P time_$dtime/$date

	python data_download_convert.py $date $dtime

	rm time_$dtime/$date/gfs*

	fi

done
