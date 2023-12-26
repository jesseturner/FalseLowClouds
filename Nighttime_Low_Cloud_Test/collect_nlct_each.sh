#! /usr/bin/bash
date="$1"
abi_path="abi_data_temp/$date"
region="oaxaca/"
nlct_path="/mnt/data2/jturner/nlct_data/$region$date/"

if [ ! -d $nlct_path ]; then
    mkdir $nlct_path
fi

for i in $abi_path/OR_ABI-L1b-RadF-M6C07*; do

	b07_path=$i

	if [ -e $b07_path ]; then

	python create_nlct_func.py $b07_path $nlct_path

	fi
    
done

