#!/bin/bash

# Receive as input an aligned file. Output the alignment between sentences.
# Sentence from an aligned file: The student eats . ||| L'étudiant mange .


fast_align=/home/aires/personal_work_troja/repos/fast_align/build/fast_align

#input=$1
#output=$2

in_folder=$1
out_folder=$2

for f in $(ls $in_folder);
do
	$fast_align -i $in_folder/$f -d -o -v > $out_folder/$f.aligned
done
