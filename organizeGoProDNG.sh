
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
mkdir DNG
# Populate the DNG folder via Adobe DNG Converter
/Applications/Adobe\ DNG\ Converter.app/Contents/MacOS/Adobe\ DNG\ Converter -fl -d DNG GPR/*

ls -l DNG
shasum -a 256 DNG/GOPR0924.dng
shasum -a 256 DNG/GOPR0925.dng

