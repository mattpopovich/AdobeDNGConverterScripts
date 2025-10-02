# This script copies GoPro DNG files from the examples/ folder
#   into the current folder, then runs compare_AdobeDNGConverter_arguments.sh
#
# This script should be run from the root of the repository Ex.
# $ bash tests/test_compare_AdobeDNGConverter_arguments.sh
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
cp compare_AdobeDNGConverter_arguments.sh tests/

# Change to the tests folder
cd tests

# Run the compare script
./compare_AdobeDNGConverter_arguments.sh

# Clean up the copied files
rm GOPR0000.GPR
rm GOPR0000.JPG
rm GOPR0001.GPR
rm GOPR0001.JPG
rm compare_AdobeDNGConverter_arguments.sh

# Change back to the original folder
cd ..

# End of test
echo "organizeGoProDNG.sh test passed"
