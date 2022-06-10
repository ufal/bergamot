#!/bin/bash

. /home/aires/personal_work_troja/python_envs/style_transf/bin/activate

in_folder=$1
lang=$2

for f in $(ls $in_folder/*);
do
	if [[ ! -d $f ]];
	then
		python udpipe_annotate.py $f $lang
	fi
done
