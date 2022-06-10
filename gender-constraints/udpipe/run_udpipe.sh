#!/bin/bash

base_path=/home/aires/personal_work_troja/repos/udpipe
udpipe=$base_path/src/udpipe
model=$1  #base_path/models/english-ewt-ud-2.5-191206.udpipe
input_path=$2
out_path=$3

$udpipe --tokenize --tag --outfile=$out_path --parse $model $input_path

