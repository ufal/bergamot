#!/bin/bash

. /home/aires/personal_work_troja/python_envs/style_transf/bin/activate 

base_path=$1

for f in $(ls $base_path/*.ner);
do
	python replace_names.py $f
done
