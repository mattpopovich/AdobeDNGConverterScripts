# This script runs Adobe DNG Converter CLI with a bunch of different arguments
#   and compares their runtime and output file sizes

# This script is expecting to be ran in a folder that has a bunch of *.GPR files:
# $ ls
# GOPR0924.GPR
# GOPR0925.GPR
# compareDNGarguments.sh

# WARNING: This script will move things around in that folder.
#          Only use on in a folder that contains deleteable files

# Author: Matt Popovich (mattpopovich.com)


# Move files into a GPR folder
mkdir GPR
mv *.GPR GPR

# Create a DNG folder
mkdir DNG

# Will pass the argument given to Adobe DNG Converter
function test_flags(){
    /Applications/Adobe\ DNG\ Converter.app/Contents/MacOS/Adobe\ DNG\ Converter $1 -d DNG GPR/*
}

flags_array=(
    "-c -p1        -cr7.1 -dng1.7.1"     # Default
    "-u -p1        -cr7.1 -dng1.7.1"
    "-l -p1        -cr7.1 -dng1.7.1"
    "-c -p1 -e     -cr7.1 -dng1.7.1"
    "-c -p0        -cr7.1 -dng1.7.1"
    "-c -p2        -cr7.1 -dng1.7.1"
    "-c -p1 -fl    -cr7.1 -dng1.7.1"
    "-c -p1 -lossy -cr7.1 -dng1.7.1"
    "-c -p1 -mp    -cr7.1 -dng1.7.1"
)

# Get default statistics
start_time=$(ruby -e 'puts Time.now.to_f')  # https://serverfault.com/a/423642/453183
test_flags "${flags_array[0]}" > /dev/null 2>/dev/null
end_time=$(ruby -e 'puts Time.now.to_f')
default_run_time=$(echo "$end_time - $start_time" | bc)
default_file_sizes=$(ls -l DNG | awk '{sum += $5} END {print sum}')
echo "Default = ${default_file_sizes}B, ${default_run_time}s"
rm DNG/*

# Get statistics for flags
for flags in "${flags_array[@]}"; do
    # Run Adobe DNG Converter and record runtime
    start_time=$(ruby -e 'puts Time.now.to_f')  # https://serverfault.com/a/423642/453183
    test_flags "$flags" > /dev/null 2>/dev/null # Suppress GPU Warnings
    end_time=$(ruby -e 'puts Time.now.to_f')
    run_time=$(echo "$end_time - $start_time" | bc)

    # Calculate time differences
    time_difference=$(echo "$run_time - $default_run_time" | bc)
    percent_time_difference=$(echo "100 * $time_difference / $default_run_time" | bc)
    if (( $(echo "$time_difference >= 0" | bc -l) )); then
        time_difference="+$time_difference"
        percent_time_difference="+$percent_time_difference"
    fi

    # Calculate file size differences
    file_size=$(ls -l DNG | awk '{sum += $5} END {print sum}')
    size_difference=$(echo "$file_size - $default_file_sizes" | bc)
    percent_size_difference=$(echo "100 * $size_difference / $default_file_sizes" | bc)
    if (( $(echo "$size_difference >= 0" | bc -l) )); then
        size_difference="+$size_difference"
        percent_size_difference="+$percent_size_difference"
    fi

    # Output statistics
    echo "Using flags" $flags "= ${time_difference}s (${percent_time_difference}%), ${size_difference}B (${percent_size_difference}%) vs default"
    rm DNG/*
done
