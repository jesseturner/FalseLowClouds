#! /usr/bin/bash

abi_path="/home/jturner/false_low_clouds_2023/Static_Features/20220914"
#b07_filename="OR_ABI-L1b-RadF-M6C07_G16_s20222570240204_e20222570249524_c20222570249569.nc"
nlct_path="/home/jturner/false_low_clouds_2023/Nighttime_Low_Cloud_Test/data/"

echo "Enter your b07 filename (Static_Features/20220914): "
read b07_filename

if [ -e $abi_path/$b07_filename ]; then
echo "Success --- data found, proceeding"

python create_nlct_func.py $abi_path $b07_filename $nlct_path

else echo "Failure --- data not found"

fi
