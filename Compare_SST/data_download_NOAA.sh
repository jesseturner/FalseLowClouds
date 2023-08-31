for day in 01 02 03 04 05 06 07 08 09 10 11 12 13 14 15

do

	data_link='https://coastwatch.noaa.gov/pub/socd2/coastwatch/sst_blended/sst5km/night/ghrsst/2023/202304'$day'000000-OSPO-L4_GHRSST-SSTfnd-Geo_Polar_Blended_Night-GLOB-v02.0-fv01.0.nc'

	directory='NOAA_SST'

	saved_file=$directory'/202304'$day'000000-OSPO-L4_GHRSST-SSTfnd-Geo_Polar_Blended_Night-GLOB-v02.0-fv01.0.nc'

	if [ -f $saved_file ]; then
	echo $day" file exists"
	else

	wget $data_link -P $directory --no-check-certificate

	fi

done
