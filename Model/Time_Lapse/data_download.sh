#! /usr/bin/bash
for date in 20220201 20220202 20220203 20220204 20220205 20220206 20220207 20220208 20220209 20220210 20220211 20220212 20220213 20220214 20220215 20220216 20220217 20220218 20220219 20220220 20220221 20220222 20220223 20220224 20220225 20220226 20220227 20220228 20220229 20220230 20220231
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
