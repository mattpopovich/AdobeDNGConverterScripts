# This script runs Adobe DNG Converter CLI with a bunch of different arguments
#   and compares their runtime and output file sizes
#
# This script is expecting to be ran in a folder that has a bunch of *.GPR files:
# $ ls
# GOPR0000.GPR
# GOPR0001.GPR
# compare_AdobeDNGConverter_arguments.sh
# $ bash compare_AdobeDNGConverter_arguments.sh
#
# Author: Matt Popovich (mattpopovich.com)

# Stop running script if any command fails
set -e

# Constants
gpr_extension="GPR"
dng_dir=".DNG"
adobeDNGconverter="/Applications/Adobe DNG Converter.app/Contents/MacOS/Adobe DNG Converter"

# Will pass the argument given to Adobe DNG Converter
function test_flags(){
    "$adobeDNGconverter" $1 -d "$dng_dir" *."$gpr_extension"
}

# Flag explanation: https://helpx.adobe.com/content/dam/help/en/camera-raw/digital-negative/jcr_content/root/content/flex/items/position/position-par/download_section/download-1/dng_converter_commandline.pdf
flags_array=(
    "-c -p1            -cr7.1  -dng1.7.1"   # Default values for AdobeDNGConverter 16.2.0 (lossless + compressed DNG files + medium JPEG preview)
    "-u -p1            -cr7.1  -dng1.7.1"   # Output uncompressed DNG files
    "-l -p1            -cr7.1  -dng1.7.1"   # Output linear DNG files
    "-c -p1 -e         -cr7.1  -dng1.7.1"   # Embed original raw file inside DNG files
    "-c -p0            -cr7.1  -dng1.7.1"   # Set JPEG preview size to none
    "-c -p2            -cr7.1  -dng1.7.1"   # Set JPEG preview size to full size
    "-c -p1 -fl        -cr7.1  -dng1.7.1"   # Embed fast load data inside DNG files
    "-c -p1 -lossy     -cr7.1  -dng1.7.1"   # Use lossy compression
    "-c -p1 -mp        -cr7.1  -dng1.7.1"   # Process multiple files in parallel
    "-c -p1 -mp        -cr11.2 -dng1.7.1"   # Upgrade minimum camera raw compatibility version
    "-c -p1 -mp        -cr12.4 -dng1.7.1"   # ''
    "-c -p1 -mp        -cr13.2 -dng1.7.1"   # ''
    "-c -p1 -mp        -cr14.0 -dng1.7.1"   # ''
    "-c -p1 -mp        -cr15.3 -dng1.7.1"   # ''
    "-c -p1 -mp -lossy -cr7.1  -dng1.7.1"   # Use lossy compression while processing in parallel
)

# Prevent this script from overwriting folders
if [ -d "$dng_dir" ]; then     # Shell is not case sensitive
    echo "ERROR: $dng_dir folder was found." \
         "Please remove it (so that we don't mess it up) before running this script"
    exit 1
fi

# Make sure we have the expected *.GPR files in this folder
if ! ls *."$gpr_extension" 1> /dev/null 2>&1; then
    printf  "%s\n" \
            "ERROR: Did not find *.$gpr_extension files in this folder" \
            "Are you running this script in the right folder?" \
            "Extensions must be capitalized"
    exit 2
fi

# Make sure the Adobe DNG Converter executable exists
if [ ! -x "$adobeDNGconverter" ]; then
    echo "ERROR: Could not find executable: $adobeDNGconverter"
    exit 3
fi

# Create a (hidden) .DNG folder to store our converted files
mkdir "$dng_dir"

# Get default statistics
start_time=$(ruby -e 'puts Time.now.to_f')  # Alternatives: https://serverfault.com/a/423642/453183
test_flags "${flags_array[0]}" > /dev/null 2>/dev/null
end_time=$(ruby -e 'puts Time.now.to_f')
default_run_time=$(echo "${end_time} - ${start_time}" | bc)
default_file_sizes=$(ls -l "$dng_dir" | awk '{sum += $5} END {print sum}')
echo "Default = ${default_file_sizes}B, ${default_run_time}s"
rm "$dng_dir"/*

# Get statistics for flags
for flags in "${flags_array[@]}"; do
    # Run Adobe DNG Converter and record runtime
    start_time=$(ruby -e 'puts Time.now.to_f')  # https://serverfault.com/a/423642/453183
    test_flags "$flags" > /dev/null 2>/dev/null # Suppress GPU Warnings
    end_time=$(ruby -e 'puts Time.now.to_f')
    run_time=$(echo "${end_time} - ${start_time}" | bc)

    # Calculate time differences
    time_difference=$(echo "${run_time} - ${default_run_time}" | bc)
    percent_time_difference=$(echo "100 * ${time_difference} / ${default_run_time}" | bc)
    if (( $(echo "$time_difference >= 0" | bc -l) )); then
        time_difference="+${time_difference}"
        percent_time_difference="+${percent_time_difference}"
    fi

    # Calculate file size differences
    file_size=$(ls -l "$dng_dir" | awk '{sum += $5} END {print sum}')
    size_difference=$(echo "${file_size} - ${default_file_sizes}" | bc)
    percent_size_difference=$(echo "100 * ${size_difference} / ${default_file_sizes}" | bc)
    if (( $(echo "$size_difference >= 0" | bc -l) )); then
        size_difference="+${size_difference}"
        percent_size_difference="+${percent_size_difference}"
    fi

    # Output statistics
    echo "Using flags ${flags} = ${time_difference}s (${percent_time_difference}%), ${size_difference}B (${percent_size_difference}%) vs default"
    rm "$dng_dir"/*
done

# Remove temporary folder
rm -r "$dng_dir"
