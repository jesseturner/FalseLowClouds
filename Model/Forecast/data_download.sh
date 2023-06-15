#! /usr/bin/bash
for date in 20230512

do
	dtime=00z
	ftime=03z
	path=time_"$dtime"_"$ftime"/$date

	if [ -d $path ]; then
	echo "directory exists"
	else
	
	wget https://www.ncei.noaa.gov/thredds/fileServer/OisstBase/NetCDF/V2.1/AVHRR/${date:0:6}/oisst-avhrr-v02r01."$date".nc -P $path

	wget https://noaa-gfs-bdp-pds.s3.amazonaws.com/gfs."$date"/${dtime:0:2}/atmos/gfs.t"$dtime".pgrb2.0p25.f300 -P $path

	python data_download_convert.py $date $dtime $ftime

	rm $path/gfs*

	fi

done
