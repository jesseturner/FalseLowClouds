#! /usr/bin/bash

for date in 20230701 20230702 20230703 20230704 20230705 20230706 20230707 20230708 20230709 20230710 20230711 20230712 20230713 20230714 20230715 20230716 20230717 20230718 20230719 20230720 20230721 20230722 20230723 20230724 20230725 20230726 20230727 20230728 20230729 20230730 20230731 

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


