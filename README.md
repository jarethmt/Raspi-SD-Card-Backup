# Raspi SD Card Backup #
This code was developed by me in order to backup my Raspi SD card OS to a cloud object storage solution. I personally use it to back up the OS on a Raspi NAS that I built. Please note that this code WILL REQUIRE some modifications to work in your environment at this point in time. I plan to make it more universal, but for now, this script makes a few assumptions:
 
 1) You have a BackBlaze account, with an empty bucket, and a key for that bucket.
 2) Must have the b2 cli tool installed on the system in question.
 3) Must have the Raspi imgclone library installed on the system in question.
 4) Must have an external drive mounted to the system at /mnt/raid. This is used to generate the actual img file, which is then uploaded.

Future version roadmap:
 - Remove reliance on local external drive for backup to work
 - Work on improving compatibility with other mainstream cloud providers
