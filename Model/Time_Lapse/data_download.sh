#! /usr/bin/bash
for date in 20221201 20221202 20221203 20221204 20221205 20221206 20221207 20221208 20221209 20221210 20221211 20221212 20221213 20221214 20221215 20221216 20221217 20221218 20221219 20221220 20221221 20221222 20221223 20221224 20221225 20221226 20221227 20221228 20221229 20221230 20221231
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
