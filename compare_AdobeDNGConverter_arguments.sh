# This script runs Adobe DNG Converter CLI with a bunch of different arguments
#   and compares their runtime and output file sizes

# WARNING: This script will be creating (and destroying) a .DNG folder

# This script is expecting to be ran in a folder that has a bunch of *.GPR files:
# $ ls
# GOPR0000.GPR
# GOPR0001.GPR
# compare_AdobeDNGConverter_arguments.sh
# $ ./compare_AdobeDNGConverter_arguments.sh

# Author: Matt Popovich (mattpopovich.com)

# Stop running script if any command fails
set -e

# Create a (hidden) .DNG folder to store our converted files
mkdir .DNG

# Will pass the argument given to Adobe DNG Converter
function test_flags(){
    /Applications/Adobe\ DNG\ Converter.app/Contents/MacOS/Adobe\ DNG\ Converter $1 -d .DNG *.GPR
}

# Flag explanation: https://helpx.adobe.com/content/dam/help/en/camera-raw/digital-negative/jcr_content/root/content/flex/items/position/position-par/download_section/download-1/dng_converter_commandline.pdf
flags_array=(
    "-c -p1            -cr7.1 -dng1.7.1"    # Default values for AdobeDNGConverter 16.2.0 (lossless + compressed DNG files + medium JPEG preview)
    "-u -p1            -cr7.1 -dng1.7.1"    # Output uncompressed DNG files
    "-l -p1            -cr7.1 -dng1.7.1"    # Output linear DNG files
    "-c -p1 -e         -cr7.1 -dng1.7.1"    # Embed original raw file inside DNG files
    "-c -p0            -cr7.1 -dng1.7.1"    # Set JPEG preview size to none
    "-c -p2            -cr7.1 -dng1.7.1"    # Set JPEG preview size to full size
    "-c -p1 -fl        -cr7.1 -dng1.7.1"    # Embed fast load data inside DNG files
    "-c -p1 -lossy     -cr7.1 -dng1.7.1"    # Use lossy compression
    "-c -p1 -mp        -cr7.1 -dng1.7.1"    # Process multiple files in parallel
    "-c -p1 -mp -lossy -cr7.1 -dng1.7.1"    # Use lossy compression while processing in parallel
)

# Get default statistics
start_time=$(ruby -e 'puts Time.now.to_f')  # Alternatives: https://serverfault.com/a/423642/453183
test_flags "${flags_array[0]}" > /dev/null 2>/dev/null
end_time=$(ruby -e 'puts Time.now.to_f')
default_run_time=$(echo "${end_time} - ${start_time}" | bc)
default_file_sizes=$(ls -l .DNG | awk '{sum += $5} END {print sum}')
echo "Default = ${default_file_sizes}B, ${default_run_time}s"
rm .DNG/*

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
    file_size=$(ls -l .DNG | awk '{sum += $5} END {print sum}')
    size_difference=$(echo "${file_size} - ${default_file_sizes}" | bc)
    percent_size_difference=$(echo "100 * ${size_difference} / ${default_file_sizes}" | bc)
    if (( $(echo "$size_difference >= 0" | bc -l) )); then
        size_difference="+${size_difference}"
        percent_size_difference="+${percent_size_difference}"
    fi

    # Output statistics
    echo "Using flags ${flags} = ${time_difference}s (${percent_time_difference}%), ${size_difference}B (${percent_size_difference}%) vs default"
    rm .DNG/*
done

# Remove temporary folder
rm -r .DNG
