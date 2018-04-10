#!/bin/bash

printf '\n\nImages in this dir :'

{
  printf '\n%s' $(ls /data/*.png | sed -e 's/\/.*\///g')
} || {
  printf '\n%s' $(ls /data/*.jpg | sed -e 's/\/.*\///g')
} || {
  printf '\n%s' $(ls /data/*.jpeg | sed -e 's/\/.*\///g')
}

printf "\n\nEnter image name to colorize it: "
read image

outfilename="${image%.*}"
outextension="${image##*.}"
outfile="${outfilename}_out.${outextension}"

/root/torch/install/bin/th colorize.lua /data/$image /data/$outfile

printf "\n\Colorized image have been saved as %s\n\n" $outfile
