# Adobe DNG Converter Scripts
A collection of scripts I made that utilize [Adobe Digital Negative (DNG) Converter](https://helpx.adobe.com/camera-raw/using/adobe-dng-converter.html)'s command line interface (CLI). Read my [blog post](https://mattpopovich.com/posts/how-to-use-adobe-dng-converter-from-the-command-line/) for additional details.

* [compare_AdobeDNGConverter_arguments.sh](compare_AdobeDNGConverter_arguments.sh)
  * Runs the *Adobe DNG Converter* from the CLI with a bunch of different arguments to compare the arguments' runtime and size of the converted files
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
  * I much prefer my files to be in folders for organization sake!
  * This performs a bulk conversion (in parallel) from `*.GPR` to `*.dng`
  * This also makes importing into [Final Cut Pro (FCPX)](https://www.apple.com/final-cut-pro/) much easier as FCPX does not support `.GPR` files.
  * **TIP**: You can rename this file to `*.command` so that you can double click it to run it in the current directory it is in on MacOS.
