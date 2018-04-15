#!/bin/bash

#printf '\n\nImages in this dir :'

# {
#  printf '\n%s' $(ls /data/*.png | sed -e 's/\/.*\///g')
#} || {
#  printf '\n%s' $(ls /data/*.jpg | sed -e 's/\/.*\///g')
#} || {
#  printf '\n%s' $(ls /data/*.jpeg | sed -e 's/\/.*\///g')
#}
#
#printf "\n\nEnter image name to colorize it: "
#read image

image=$1

outfilename="${image%.*}"
outextension="${image##*.}"
outfile="${outfilename}_out.${outextension}"

/root/torch/install/bin/th colorize.lua /data/$image /data/$outfile
