#!/bin/bash

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



echo "THIS SCRIPT DEPENDS ON BACKBLAZE'S B2 COMMAND TO WORK! MAKE SURE TO INSTALL IT ON YOUR SYSTEM BEFORE RUNNING!"
echo "Please wait, starting..."
sleep 5;
date=$(date '+%m-%d-%Y %H:%M:%S')
filename="raspi-sd-backup-${date}.img"
imgclone -d filename


##### NOW AUTHORIZE TO B2 AND UPLOAD THIS BITCH #####
b2 authorize-account $key_id $application_key
b2 upload-file $bucket_name "./$filename" $filename

## Finally, delete the local file ##
rm $filename