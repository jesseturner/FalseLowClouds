#! /usr/bin/bash
for month in 01 02 03 04 05 06 07 08 09 10 11 12
do

    for date in 2020"$month"01 2020"$month"02 2020"$month"03 2020"$month"04 2020"$month"05 2020"$month"06 2020"$month"07 2020"$month"08 2020"$month"09 2020"$month"10 2020"$month"11 2020"$month"12 2020"$month"13 2020"$month"14 2020"$month"15 2020"$month"16 2020"$month"17 2020"$month"18 2020"$month"19 2020"$month"20 2020"$month"21 2020"$month"22 2020"$month"23 2020"$month"24 2020"$month"25 2020"$month"26 2020"$month"27 2020"$month"28 2020"$month"29 2020"$month"30 2020"$month"31

    do 

        sst_name=oisst-avhrr-v02r01."$date".nc

            sst_source=https://www.ncei.noaa.gov/thredds/fileServer/OisstBase/NetCDF/V2.1/AVHRR/${date:0:6}/oisst-avhrr-v02r01."$date".nc
        sst_source_backup=https://www.ncei.noaa.gov/thredds/fileServer/OisstBase/NetCDF/V2.1/AVHRR/${date:0:6}/oisst-avhrr-v02r01."$date"_preliminary.nc


        if [ -f OISST_data/$sst_name ]; then
        echo "file exists"

        else
        wget $sst_source -P OISST_data || wget $sst_source_backup -P OISST_data

        fi

    done
done