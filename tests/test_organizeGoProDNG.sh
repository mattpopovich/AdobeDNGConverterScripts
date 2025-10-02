# This script copies GoPro DNG files from the examples/ folder
#   into the current folder, then runs organizeGoProDNG.sh
#
# This script should be run from the root of the repository Ex.
# $ bash tests/test_organizeGoProDNG.sh
#
# Author: Matt Popovich (mattpopovich.com)

# Stop running script if any command fails
set -e

# Copy the examples from the examples folder
cp examples/* tests/

# Confirm the expected files were copied
ls tests/GOPR0000.GPR
ls tests/GOPR0000.JPG
ls tests/GOPR0001.GPR
ls tests/GOPR0001.JPG

# Copy the organize script to be tested into the current folder
cp organizeGoProDNG.sh tests/

# Change to the tests folder
cd tests

# Run the organize script
./organizeGoProDNG.sh

# Confirm the expected results
ls dng
ls JPG
ls GPR
ls dng/GOPR0000.DNG
ls JPG/GOPR0000.JPG
ls GPR/GOPR0000.GPR
ls dng/GOPR0001.DNG
ls JPG/GOPR0001.JPG
ls GPR/GOPR0001.GPR

# Change back to the original folder
cd ..

# Clean up the created files
rm -r tests/GPR tests/JPG tests/dng tests/organizeGoProDNG.sh

# End of test
echo "organizeGoProDNG.sh test passed"
