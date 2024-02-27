# A script to convert a folder coming fresh off of a GoPro from
#   `GOPR0000.GPR`
#   `GOPR0000.JPG`
#   `GOPR0001.GPR`
#   `GOPR0001.JPG`
#   `organizeGoProDNG.sh`
# to
#   `GPR/`
#       `GOPR0000.GPR`
#       `GOPR0001.GPR`
#   `JPG/`
#       `GOPR0000.JPG`
#       `GOPR0001.JPG`
#   `dng/`
#       `GOPR0000.dng`
#       `GOPR0001.dng`
#   `organizeGoProDNG.sh`

# Author: Matt Popovich (mattpopovich.com)

# Allow this script to be renamed to a .command file and run in the
#   current directory that this script is in (and not the user's home directory ~)
cd "$(dirname "$0")"

# Stop running script if any command fails
set -e

# Prevent this script from overwriting folders
if [ -d JPG ] || [ -d GPR ] || [ -d dng ]; then     # Shell is not case sensitive
    echo "ERROR: JPG, GPR, or DNG folder was found." \
         "Please remove it (so that we don't mess it up) before running this script"
    exit 1
fi

# Make sure we have the expected files in this folder (both *.JPG and *.GPR files)
if ! ls *.JPG *.GPR 1> /dev/null 2>&1; then
    echo "ERROR: Did not find both *.JPG and *.GPR files in this folder" \
         "Are you running this script in the right folder?" \
         "Extensions must be capitalized"
    exit 2
fi

# Move files into a JPG folder
mkdir JPG
mv *.JPG JPG

# Move files into a GPR folder
mkdir GPR
mv *.GPR GPR

# Create a DNG folder
mkdir dng
# Populate the DNG folder via Adobe DNG Converter
/Applications/Adobe\ DNG\ Converter.app/Contents/MacOS/Adobe\ DNG\ Converter -fl -mp -d dng GPR/*
