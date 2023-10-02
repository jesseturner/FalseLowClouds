#! /usr/bin/bash

for date in 20230101 20230102 20230103 20230104 20230105 20230106 20230107 20230108 20230109 20230110 20230111 20230112 20230113 20230114 20230115 20230116 20230117 20230118 20230119 20230120 20230121 20230122 20230123 20230124 20230125 20230126 20230127 20230128 20230129 20230130 20230131

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