#!/bin/bash

printf '\n\nImages in this dir :'

{
  printf '\n%s' $(ls /data/*.png | sed -e 's/\/.*\///g')
} || {
  printf '\n%s' $(ls /data/*.jpg | sed -e 's/\/.*\///g')
} || {
  printf '\n%s' $(ls /data/*.jpeg | sed -e 's/\/.*\///g')
}

printf "\n\nEnter image name to detect objects: "
read image

./darknet detect cfg/yolov3.cfg yolov3.weights "/data/$image"

cp predictions.png /data/predictions.png

printf "\n\nDetected objects have been marked into predictions.png\n\n"
