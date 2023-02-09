#!/bin/sh
# AutoDirBackup
# Compresses (.tar.gz) directory to a temp directory at users home,
# and moves it to the output directory
# ADBeta 09 Feb 2023

# Note: Running this script as root will create and delete a file in the root
# home directory. It should leave the directory as it found it, but be aware 
# that this script DOES touch the root section of the system.

###### Functions ###############################################################
# Print USAGE notes then exit.
function exitUsage {
	echo -e "USAGE: AutoBackupDir.sh [input directory] [output directory]\n"
	exit 1
}

###### Get User Input ##########################################################
# Get user input
indir="$1"
outdir="$2"

# Make sure user provided all the inputs needed
if [ -z "${indir}" ] || [ -z "${outdir}" ]; then
	exitUsage
fi

# Check input - Make sure $1 is a directory and is valid
if [ ! -d "${indir}" ]; then
	echo -e "${indir} is not a directory."
	exitUsage
fi

# Check output - Make sure $1 is a directory and is valid
if [ ! -d "${outdir}" ]; then
	echo -e "${outdir} is not a directory."
	exitUsage
fi

####### Main Execution #########################################################
# Make sure tar and gzip are installed and functional

# Create a temporary directory in the users home
tmpdir="$HOME/AutoDirBackup/"

echo "$tmpdir"
mkdir -p "${tmpdir}" &>/dev/null

# Make sure the temp creation worked
if [ $? -ne 0 ]; then
	echo "Failed to create $tmpdir"
	exit 1
fi

# Create Output filename, this is the input directory, without any /, and with
# _backup_, date and .tar.gz (##*/ is a greedy trim from any last match to /)
outfile=("${tmpdir}${indir##*/}_backup_"$(date +'%d-%b-%Y')".tar.gz")

# Compress the in directory to a gzip tar. Output to temp directory.
tar -czvf "${outfile}" "${indir}"

# If tar failed, its verbosity is enough for error hunting. Just exit
if [ $? -ne 0 ]; then exit 1; fi

# Move the file from /tmp to the output directory. Force overwrite
mv -f "${outfile}" "${outdir}"

if [ $? -ne 0 ]; then
	echo "Failed to move the backup to $outdir!"
	exit 1
fi

# Remove the temp directory
rmdir "${tmpdir}"

# Success! Finish by outputting success message
echo -e "\nBackup of $indir successfully complete to $outdir"
