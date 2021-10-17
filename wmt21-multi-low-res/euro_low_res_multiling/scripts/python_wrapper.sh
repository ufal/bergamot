#!/bin/bash

. /home/aires/personal_work_ms/python_envs/wmt21/bin/activate

# phonemize_data.py

#root_folder=/home/aires/personal_work_ms/wmt21/euro_low_res_multiling/data/lang_pairs
#lang=ca
#python phonemize_data.py $root_folder $lang


# combine_data.py

root_folder=/home/aires/personal_work_ms/wmt21/euro_low_res_multiling/data/wmt21_data
out_folder=/home/aires/personal_work_ms/wmt21/euro_low_res_multiling/data/add_resources  #lang_pairs

lang_pairs=" en-it en-oc en-ro "  #" ca-en ca-es ca-fr ca-it ca-oc ca-pt ca-ro "

for lang_pair in $lang_pairs
do
	python combine_data.py $root_folder $lang_pair $out_folder
done
