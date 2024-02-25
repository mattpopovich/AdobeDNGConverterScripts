# AdobeDNGConverterScripts
A collection of scripts I made that utilize Adobe Digital Negative (DNG) Converter's command line interface (CLI).
* [compare_AdobeDNGConverter_arguments.sh](compare_AdobeDNGConverter_arguments.sh)
  * Runs the *Adobe DNG Converter* from the CLI with a bunch of different arguments to compare their runtime and size of the converted files
* [reset.sh](reset.sh)
  * A script used while testing [organizeGoProDNG.sh](organizeGoProDNG.sh). This script "resets" the folder to what it normally looks like coming fresh off of a GoPro.
* [organizeGoProDNG.sh](organizeGoProDNG.sh)
  * A script to convert a folder coming fresh off of a GoPro from
    * `GOPR0000.GPR`
    * `GOPR0000.JPG`
    * `GOPR0001.GPR`
    * `GOPR0001.JPG`
  * to
    * `GPR/`
      * `GOPR0000.GPR`
      * `GOPR0001.GPR`
    * `JPG/`
      * `GOPR0000.JPG`
      * `GOPR0001.JPG`
    * `DNG/`
      * `GOPR0000.dng`
      * `GOPR0001.dng`

TODO: Add an `original/` folder with two sample images.
