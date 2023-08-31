for day in 01 02 03 04 05 06 07 08 09 10 11 12 13 14 15

do

	data_link='https://data.remss.com/SST/daily/mw/v05.1/netcdf/2023/202304'$day'120000-REMSS-L4_GHRSST-SSTfnd-MW_OI-GLOB-v02.0-fv05.1.nc'

	directory='MW_SST'	

	saved_file=$directory'/202304'$day'120000-REMSS-L4_GHRSST-SSTfnd-MW_OI-GLOB-v02.0-fv05.1.nc'

	if [ -f $saved_file ]; then
	echo $day" file exists"
	else

	wget $data_link -P $directory --no-check-certificate

	fi

done
