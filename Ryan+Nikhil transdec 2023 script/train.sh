#!/bin/bash


#@author: ryan yang


file=$(pwd)/$(find *.zip | head -n1)
echo currently selected file is $file

echo enter model name:
read model_name

echo enter image extension:
read image_extension

echo train model location from root or yolov8s.pt:
read model_location

echo now training $model_name with yolov8

time=$(date +"%Y_%m_%d_%I_%M_%p")
echo time is now $time

mkdir -p $(pwd)/$model_name/$time/
cd $model_name/$time
current_dir=$(pwd)

echo unzipping...
unzip $file -d $current_dir
echo $current_dir
echo converting xml to YOLO
python3 /home/avbotz/train/YOLO_format.py --train_test_split 0.8 \
--image_dir $current_dir/JPEGImages \
--annot_dir $current_dir/Annotations \
--save_dir $current_dir --ext $image_extension 

trap "rm -rf $file && echo $file is deleted" SIGINT

yolo task=detect mode=train \
model=$model_location \
data=data.yaml imgsz=640 plots=True device=0 epochs=200 save_period=2
