#! /usr/bin/bash
for date in 20230423 20230424 20230425 20230426 20230427 20230428
do
	if [ -d $date ]; then
	echo "directory exists"
	else
	
	mkdir $date
	
	wget https://www.ncei.noaa.gov/thredds/fileServer/OisstBase/NetCDF/V2.1/AVHRR/202304/oisst-avhrr-v02r01."$date".nc -P $date

	wget https://noaa-gfs-bdp-pds.s3.amazonaws.com/gfs."$date"/00/atmos/gfs.t00z.pgrb2.0p25.f000 -P $date

	python data_download_convert.py $date

	rm $date/gfs*

	fi

done
