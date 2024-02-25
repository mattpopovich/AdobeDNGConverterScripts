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

# Stop running script if any command fails
set -e

# TOOD: Check if folders exist to hit that this script has already ran
# check JPG GPR DNG
# If it finds them, tell the user to delete those folders and run again

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
