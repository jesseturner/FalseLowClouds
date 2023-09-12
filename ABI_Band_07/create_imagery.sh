#! /usr/bin/bash

date="$1"

if [ -z "$date" ]; then
    echo "Please provide an input."
else
    abi_path="abi_data_temp/$date"
    result_path="band07_data/$date/"

    if [ -d $result_path ]; then echo "Success --- destination directory found"
    else mkdir $result_path
    fi

    for i in $abi_path/OR_ABI-L1b-RadF-M6C07*; do

        b07_path=$i

        if [ -e $b07_path ]; then
        echo "Success --- data found, proceeding"

        python create_band07_func.py $b07_path $result_path

        else echo "Failure --- data not found"

        fi
    
    done
fi


