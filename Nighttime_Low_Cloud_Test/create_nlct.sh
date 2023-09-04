#! /usr/bin/bash
date="20230901"
abi_path="/home/jturner/false_low_clouds_2023/Static_Features"/$date

for i in $abi_path/OR_ABI-L1b-RadF-M6C07*; do

	b07_path=$i

	nlct_path="/home/jturner/false_low_clouds_2023/Nighttime_Low_Cloud_Test/data/"

	if [ -e $b07_path ]; then
	echo "Success --- data found, proceeding"
	#echo "$b07_path"
	#---Need to fix this connection
	#python create_nlct_func.py $abi_path $b07_filename $nlct_path
	python create_nlct_func.py $b07_path $nlct_path

	else echo "Failure --- data not found"

	fi
done

