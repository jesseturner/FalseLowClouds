#! /usr/bin/bash
date="$1"
abi_path="abi_data_temp/$date"
nlct_path="nlct_data/$date/"

if [ -d $nlct_path ]; then echo #"Success --- destination directory found for $date"
else mkdir $nlct_path
fi

for i in $abi_path/OR_ABI-L1b-RadF-M6C07*; do

	b07_path=$i

	if [ -e $b07_path ]; then
	#echo "Success --- data found for $date, proceeding"

	python create_nlct_func.py $b07_path $nlct_path

	#else echo "Failure --- data not found for $date"

	fi
    
done

