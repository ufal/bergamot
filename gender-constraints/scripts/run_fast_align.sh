#!/bin/bash

# Receive as input an aligned file. Output the alignment between sentences.
# Sentence from an aligned file: The student eats . ||| L'étudiant mange .


fast_align=/home/aires/personal_work_troja/repos/fast_align/build/fast_align

input=$1
output=$2

$fast_align -i $input -d -o -v > $output
