#! /usr/bin/bash
for date in 20230101 20230102 20230103 20230104 20230105 20230106 20230107 20230108 20230109 20230110 20230111 20230112 20230113 20230114 20230115 20230116 20230117 20230118 20230119 20230120 20230121 20230122 20230123 20230124 20230125 20230126 20230127 20230128 20230129 20230130 20230131
do 
	dtime=00z

	if [ -d time_$dtime/$date ]; then
	echo "directory exists"
	else
	
	wget https://www.ncei.noaa.gov/thredds/fileServer/OisstBase/NetCDF/V2.1/AVHRR/${date:0:6}/oisst-avhrr-v02r01."$date".nc -P time_$dtime/$date

	wget https://noaa-gfs-bdp-pds.s3.amazonaws.com/gfs."$date"/${dtime:0:2}/atmos/gfs.t"$dtime".pgrb2.0p25.f000 -P time_$dtime/$date

	python data_download_convert.py $date $dtime

	rm time_$dtime/$date/gfs*

	fi

done
