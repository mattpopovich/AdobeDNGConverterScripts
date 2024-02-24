
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

# TODO: make this into a function
# TODO: Remove the adobe dng output
# TODO: Add file size difference (percentage) compared to default arguments
flags="-c -p1 -cr7.1 -dng1.4"
/Applications/Adobe\ DNG\ Converter.app/Contents/MacOS/Adobe\ DNG\ Converter $flags -d DNG GPR/* > /dev/null
echo "Using flags" $flags
ls -l DNG
rm DNG/*

flags="-u -p1 -cr7.1 -dng1.4"
/Applications/Adobe\ DNG\ Converter.app/Contents/MacOS/Adobe\ DNG\ Converter $flags -d DNG GPR/* > /dev/null
echo "Using flags" $flags
ls -l DNG
rm DNG/*

flags="-l -p1 -cr7.1 -dng1.4"
/Applications/Adobe\ DNG\ Converter.app/Contents/MacOS/Adobe\ DNG\ Converter $flags -d DNG GPR/* > /dev/null
echo "Using flags" $flags
ls -l DNG
rm DNG/*

flags="-c -e -p1 -cr7.1 -dng1.4"
/Applications/Adobe\ DNG\ Converter.app/Contents/MacOS/Adobe\ DNG\ Converter $flags -d DNG GPR/* > /dev/null
echo "Using flags" $flags
ls -l DNG
rm DNG/*

flags="-c -p0 -cr7.1 -dng1.4"
/Applications/Adobe\ DNG\ Converter.app/Contents/MacOS/Adobe\ DNG\ Converter $flags -d DNG GPR/* > /dev/null
echo "Using flags" $flags
ls -l DNG
rm DNG/*

flags="-c -p2 -cr7.1 -dng1.4"
/Applications/Adobe\ DNG\ Converter.app/Contents/MacOS/Adobe\ DNG\ Converter $flags -d DNG GPR/* > /dev/null
echo "Using flags" $flags
ls -l DNG
rm DNG/*

flags="-c -p1 -fl -cr7.1 -dng1.4"
/Applications/Adobe\ DNG\ Converter.app/Contents/MacOS/Adobe\ DNG\ Converter $flags -d DNG GPR/* > /dev/null
echo "Using flags" $flags
ls -l DNG
rm DNG/*

flags="-c -p1 -lossy -cr7.1 -dng1.4"
/Applications/Adobe\ DNG\ Converter.app/Contents/MacOS/Adobe\ DNG\ Converter $flags -d DNG GPR/* > /dev/null
echo "Using flags" $flags
ls -l DNG
rm DNG/*

flags="-c -mp -p1 -cr7.1 -dng1.4"
/Applications/Adobe\ DNG\ Converter.app/Contents/MacOS/Adobe\ DNG\ Converter $flags -d DNG GPR/* > /dev/null
echo "Using flags" $flags
ls -l DNG
rm DNG/*
