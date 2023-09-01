for day in 16 17 18 19 20 21 22 23 24 25 26 27 28 29 30

do

	data_link='https://coastwatch.noaa.gov/pub/socd2/coastwatch/sst_blended/sst5km/night/ghrsst/2023/202304'$day'000000-OSPO-L4_GHRSST-SSTfnd-Geo_Polar_Blended_Night-GLOB-v02.0-fv01.0.nc'

	directory='NOAA_SST'

	saved_file=$directory'/202304'$day'000000-OSPO-L4_GHRSST-SSTfnd-Geo_Polar_Blended_Night-GLOB-v02.0-fv01.0.nc'

	if [ -f $saved_file ]; then
	echo $day" file exists"
	else

	(cd $directory && curl -O $data_link)
	
	fi

done
