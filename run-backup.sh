#!/bin/bash
PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin
#get all args and make sure they're specified first

while [ $# -gt 0 ]; do
  case "$1" in
    --key_id=*)
      key_id="${1#*=}"
      ;;
    --application_key=*)
      application_key="${1#*=}"
      ;;
    --bucket_name=*)
      bucket_name="${1#*=}"
      ;;
    --external_drive=*)
      external_drive="${1#*=}"
      ;;
    --skip_sd=*)
      skip_sd="${1#*=}"
      ;;
    *)
      printf "***************************\n"
      printf "* Error: Invalid argument.*\n"
      printf "***************************\n"
      exit 1
  esac
  shift
done

if [ -z "$key_id" ]; then
	echo "YOU MUST SPECIFY A B2 APPLICATION KEY ID"
	exit;
fi
if [ -z "$application_key" ]; then
        echo "YOU MUST SPECIFY A B2 APPLICATION KEY"
	exit;
fi
if [ -z "$bucket_name" ]; then
        echo "YOU MUST SPECIFY A B2 BUCKET NAME"
        exit;
fi
if [ -z "$external_drive" ]; then
	echo "YOU MUST SPECIFY A MOUNTED EXTERNAL DRIVE AS AN INTERMEDIARY FOR THE CLOUD BACKUP"
	exit;
fi


echo "THIS SCRIPT DEPENDS ON BACKBLAZE'S B2 COMMAND TO WORK! MAKE SURE TO INSTALL IT ON YOUR SYSTEM BEFORE RUNNING!"
echo "Please wait, starting..."
sleep 5;




if grep -qs "$external_drive" /proc/mounts; then

	#shut down Apache to prevent changes to the FS
	systemctl stop apache2

	#MOVE INTO THE EXTERNAL DRIVE
	cd "$external_drive"

	if [ -z "$skip_sd" ]; then
		date=$(date '+%m-%d-%Y %H:%M:%S')
		filename="raspi-sd-backup-${date}.img"
		
		#change into the hard drive mount and run the backup there...
		imgclone -d "$filename"
	
	fi	

	
	##### NOW AUTHORIZE TO B2 AND UPLOAD THIS BITCH #####
	b2 authorize-account "$key_id" "$application_key"
	b2 sync --replaceNewer --allowEmptySource --delete . "b2://${bucket_name}"
	
	## Finally, delete the local file ##
	##LEAVING IT FOR NOW FOR EXTRA BACKUP!##
	#rm "$filename"


	#start apache2 back up
	systemctl start apache2
else
	echo "External drive not mounted! exiting script to prevent data loss"
fi
