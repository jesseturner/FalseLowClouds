#! /usr/bin/bash

remote_user="jturner"
remote_host="smiller2.cira.colostate.edu"

ssh-keygen -t rsa -b 2048
ssh-copy-id $remote_user@$remote_host
chmod 600 ~/.ssh/id_rsa

#--- Date and time range to run the data:
start_date="20231226"
end_date="20231231"
hours="07"

date=$(date -d "$start_date" +%Y%m%d)

while [ "$date" -le "$(date -d "$end_date" +%Y%m%d)" ]; do
#------------------------------------------------------

    julian=$(date -d "$date" +%j)

    echo
    echo "--- Running for $date"
    
    local_destination="abi_data_temp/"$date

    if [ ! -d $local_destination ]; then mkdir $local_destination
    fi
    
    #--- Added zeros at the end for 'top of each hour'
    
    for time in $hours; do
         remote_directory_07="/mnt/grb/goes16/"${date:0:4}/${date:0:4}_${date:4:2}_${date:6:2}_$julian"/abi/L1b/RadF/OR_ABI-L1b-RadF-M6C07_G16_s"${date:0:4}$julian$time"0"*
         remote_directory_14="/mnt/grb/goes16/"${date:0:4}/${date:0:4}_${date:4:2}_${date:6:2}_$julian"/abi/L1b/RadF/OR_ABI-L1b-RadF-M6C14_G16_s"${date:0:4}$julian$time"0"*
         
#--- M6C13 has the clean IR window, 10.3um

        scp $remote_user@$remote_host:$remote_directory_07 $local_destination
        scp $remote_user@$remote_host:$remote_directory_14 $local_destination
    
    done
    
    chmod +x collect_nlct_each.sh
    ./collect_nlct_each.sh "$date"
    
    rm -r $local_destination
    
    date=$(date -d "$date + 1 day" +%Y%m%d)
    
done
    

