# AutoDirBackup

This script will create a backup using tar.gz compression, with the date and _backup_ appended, of a directory on the system, and move it to another directory.  

For example:
`./AutoDirBackup.sh [input dir] [output dir]`  
`./AutoDirBackup.sh ./Files ./ ` will create a file called "Files_backup_DD-MMM-YY.tar.gz"  
Both directories must be passed to the script.  

Notes: This script works by creating a temporary directory in the home directory of the $USER who called it. It will use this to compress the input directory, then move the tar.gz from the temp directory to the output directory and remove the temporary directory - thus leaving the home directory completely untampered afterwards. Please keep not of this if you use this script as root user or under sudo.
