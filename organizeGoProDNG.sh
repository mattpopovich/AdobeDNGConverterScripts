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

# Constants
jpg_dir="JPG"
gpr_dir="GPR"
dng_dir="dng"
adobeDNGconverter="/Applications/Adobe DNG Converter.app/Contents/MacOS/Adobe DNG Converter"

# Function to display a progress bar
show_progress() {
    local progress=$1
    local total=50  # Total length of the progress bar
    local filled=$(( progress * total / 100 ))
    local empty=$(( total - filled ))

    # Display the progress bar
    printf "\r["
    for ((i=0; i<$filled; i++)); do printf "#"; done
    for ((i=0; i<$empty; i++)); do printf " "; done
    printf "] %d%%" "$progress"
}

# Allow this script to be renamed to a .command file and run in the
#   current directory that this script is in (and not the user's home directory ~)
cd "$(dirname "$0")"

# Prevent this script from overwriting folders
if [ -d "$jpg_dir" ] || [ -d "$gpr_dir" ] || [ -d "$dng_dir" ]; then     # Shell is not case sensitive
    echo "ERROR: $jpg_dir, $gpr_dir, or $dng_dir folder was found." \
         "Please remove it (so that we don't mess it up) before running this script"
    exit 1
fi

# Make sure we have the expected files in this folder (both *.JPG and *.GPR files)
if ! ls *."$jpg_dir" *."$gpr_dir" 1> /dev/null 2>&1; then
    printf  "%s\n" \
            "ERROR: Did not find both *.$jpg_dir and *.$gpr_dir files in this folder" \
            "Are you running this script in the right folder?" \
            "Extensions must be capitalized"
    exit 2
fi

# Make sure the Adobe DNG Converter executable exists
if [ ! -x "$adobeDNGconverter" ]; then
    echo "ERROR: Could not find executable: $adobeDNGconverter"
    exit 3
fi

# Count total number of files in GPR directory to process
total_files=$(ls -1 *."$gpr_dir" | wc -l | xargs)
# Capture the start time (in seconds with nanoseconds)
start_time=$(ruby -e 'puts Time.now.to_f')  # https://serverfault.com/a/423642/453183

# Move files into a JPG folder
mkdir "$jpg_dir"
mv *."$jpg_dir" "$jpg_dir"

# Move files into a GPR folder
mkdir "$gpr_dir"
mv *."$gpr_dir" "$gpr_dir"

# Create a DNG folder
mkdir "$dng_dir"
# Populate the DNG folder via Adobe DNG Converter (in the background)
"$adobeDNGconverter" -fl -mp -d "$dng_dir" "$gpr_dir"/* &

# Get the PID of the executable
exec_pid=$!

# Wait for DNG converter to output a line before we output progress bar
sleep 1
echo "Processing $total_files files..."

# Continuously check the progress while the executable is running
while kill -0 $exec_pid 2>/dev/null; do
    # Count number of processed files in the jpg directory
    processed_files=$(ls -1 "$dng_dir" | wc -l)

    # Calculate the progress percentage
    if [ $total_files -ne 0 ]; then
        progress=$(( processed_files * 100 / total_files ))
    else
        progress=0
    fi

    # Show the progress bar
    show_progress "$progress"

    # Sleep for a short while before checking again
    sleep 0.5
done

# Ensure final progress display after the executable finishes
processed_files=$(ls -1 "$dng_dir" | wc -l)
if [ $total_files -ne 0 ]; then
    progress=$(( processed_files * 100 / total_files ))
else
    progress=100
fi
show_progress "$progress"

# Calculate and display the elapsed time in seconds (to nearest hundredth)
end_time=$(ruby -e 'puts Time.now.to_f')  # https://serverfault.com/a/423642/453183
elapsed_time=$(echo "$end_time - $start_time" | bc)
printf "\nProcessing complete in %.2f seconds.\n" "$elapsed_time"
