
# Clean things up
./reset.sh

# Move files into a JPG folder
mkdir JPG
mv *.JPG JPG

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
    "-c -p1 -cr7.1 -dng1.4"
    "-u -p1 -cr7.1 -dng1.4"
    "-l -p1 -cr7.1 -dng1.4"
    "-c -e -p1 -cr7.1 -dng1.4"
    "-c -p0 -cr7.1 -dng1.4"
    "-c -p2 -cr7.1 -dng1.4"
    "-c -p1 -fl -cr7.1 -dng1.4"
    "-c -p1 -lossy -cr7.1 -dng1.4"
    "-c -mp -p1 -cr7.1 -dng1.4"
)

# TODO: Add file size difference (percentage) compared to default arguments

for flags in "${flags_array[@]}"; do
    test_flags "$flags" > /dev/null 2>/dev/null # Suppress GPU Warnings
    echo "Using flags" $flags
    # Suppress the "total" line from output + only display file size and name
    ls -l DNG | tail -n +2 | awk '{print $5, $9}'
    rm DNG/*
    echo
done
