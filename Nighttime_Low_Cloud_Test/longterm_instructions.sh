#! /usr/bin/bash

remote_user="jturner"
remote_host="smiller2.cira.colostate.edu"

ssh-keygen -t rsa -b 2048
ssh-copy-id $remote_user@$remote_host
chmod 600 ~/.ssh/id_rsa

for date in 20230714; do 
#20230716 20230717 20230718 20230719 20230720 20230721 20230722 20230723 20230724 20230726 20230727 20230728 20230729 20230730 20230731; do 

    julian=$(date -d "$date" +%j)

    echo
    echo "--- Running for $date"
    
    local_destination="abi_data_temp/"$date

    if [ ! -d $local_destination ]; then mkdir $local_destination
    fi
    
    #--- Added zeros at the end for 'top of each hour'
    
    for time in "00" "01" "02" "03" "04" "05" "06" "07" "08"; do
         remote_directory_07="/mnt/grb/goes16/"${date:0:4}/${date:0:4}_${date:4:2}_${date:6:2}_$julian"/abi/L1b/RadF/OR_ABI-L1b-RadF-M6C07_G16_s"${date:0:4}$julian$time"0"*
         remote_directory_14="/mnt/grb/goes16/"${date:0:4}/${date:0:4}_${date:4:2}_${date:6:2}_$julian"/abi/L1b/RadF/OR_ABI-L1b-RadF-M6C14_G16_s"${date:0:4}$julian$time"0"*
    
        scp $remote_user@$remote_host:$remote_directory_07 $local_destination
        scp $remote_user@$remote_host:$remote_directory_14 $local_destination
        
    done
    
    chmod +x longterm_create_nlct.sh
    ./longterm_create_nlct.sh "$date"
    
    rm -r $local_destination
    
done
    

