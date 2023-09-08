#! /usr/bin/bash

date="20230907"
time="01" # hh
julian="250"

local_destination="abi_data_temp/"$date
remote_user="jturner"
remote_host="smiller2.cira.colostate.edu"

remote_directory_07="/mnt/grb/goes16/"${date:0:4}/${date:0:4}_${date:4:2}_${date:6:2}_$julian"/abi/L1b/RadF/OR_ABI-L1b-RadF-M6C07_G16_s"${date:0:4}$julian$time*
remote_directory_14="/mnt/grb/goes16/"${date:0:4}/${date:0:4}_${date:4:2}_${date:6:2}_$julian"/abi/L1b/RadF/OR_ABI-L1b-RadF-M6C14_G16_s"${date:0:4}$julian$time*

echo "--- Create the directory for the ABI data"
echo "mkdir abi_data_temp/$date"

echo "--- Retrieve ABI data from 07 band:"
echo "scp $remote_user@$remote_host:$remote_directory_07 $local_destination" 

echo "--- Retrieve ABI data from 14 band:"
echo "scp $remote_user@$remote_host:$remote_directory_14 $local_destination" 

echo "--- Edit date and run create_nlct.sh"

echo "--- When finished, use this command to remove ABI data:"
echo "rm -r $local_destination"