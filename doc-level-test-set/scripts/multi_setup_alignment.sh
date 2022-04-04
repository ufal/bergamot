#!/bin/bash

in_folder=$1
lang1=$2
lang2=$3

for f in $(ls $in_folder);
do
    if [ ! -d $in_folder/$f ];
    then
        in_file=$in_folder/$f
        alt_file=$in_folder/czech/$f.all.cs
        out_file=$in_folder/align/$f'.'$lang1'-'$lang2
        python setup_alignment.py $lang1 $in_file $lang2 $alt_file -o $out_file
    fi
done