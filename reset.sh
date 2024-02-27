# WARNING: THIS SCRIPT REMOVES FILES. BE CAREFUL WHEN EXECUTING IT

# This script "resets" the current folder to what it normally looks like
#   coming fresh off of a GoPro
#   (as long as those files are in an examples/ folder):
# $ ./reset.sh
# $ ls
# GOPR0000.GPR
# GOPR0000.JPG
# GOPR0001.GPR
# GOPR0001.JPG
# examples/
# reset.sh

# Remove all image files
rm -f *.GPR
rm -f *.gpr
rm -f *.JPG

# Remove all generated folders
rm -rf GPR
rm -rf JPG
rm -rf DNG
rm -rf .DNG

# Copy the examples back out from the examples folder
cp examples/* .
