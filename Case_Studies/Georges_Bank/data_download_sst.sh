#! /usr/bin/bash

for date in 20230601 20230602 20230603 20230604 20230605 20230606 20230607 20230608 20230609 20230610 20230611 20230612 20230613 20230614 20230615 20230616 20230617 20230618 20230619 20230620 20230621 20230622 20230623 20230624 20230625 20230626 20230627 20230628 20230629 20230630

do 

    sst_name=oisst-avhrr-v02r01."$date".nc

	sst_source=https://www.ncei.noaa.gov/thredds/fileServer/OisstBase/NetCDF/V2.1/AVHRR/${date:0:6}/oisst-avhrr-v02r01."$date".nc
    sst_source_backup=https://www.ncei.noaa.gov/thredds/fileServer/OisstBase/NetCDF/V2.1/AVHRR/${date:0:6}/oisst-avhrr-v02r01."$date"_preliminary.nc
    

	if [ -f SST_data/$sst_name ]; then
	echo "file exists"
	
    else
    wget $sst_source -P SST_data || wget $sst_source_backup -P SST_data

	fi

done