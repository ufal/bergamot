#!/bin/bash

spm=sentencepiece/build/src

model=$1
input=$2

# Encode data.
output=$input.sp

$spm/spm_encode --model=$model < $input > $output
