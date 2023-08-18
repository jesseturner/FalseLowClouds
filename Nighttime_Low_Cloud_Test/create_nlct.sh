#None of this is correct yet
for date in '20220914'

do 

	if [ -d time_$dtime/$date ]; then
	echo "directory exists"

	python data_download_convert.py $date $dtime


	fi
done
