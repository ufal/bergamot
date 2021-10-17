#!/bin/bash

#. /home/aires/personal_work_ms/python_envs/wmt21/bin/activate

root_path=`pwd`
out_path=$root_path/data
datasets=" GlobalVoices Europarl JW300 WikiMatrix MultiCCAligned Opus100 Books bible-uedin TED2020 Wikipedia ParaCrawl "

lang_pair=${1:-"all"}

echo $lang_pair

if [ $lang_pair != "all" ];
then
	lang_pair=" $lang_pair "
else
	lang_pair=" ca-it ca-oc ca-ro ca-en ca-fr ca-pt ca-es en-it en-oc en-ro es-it es-oc es-ro fr-it fr-oc fr-ro "
fi

# Create main folder.
mkdir -p $out_path/wmt21_data
cd $out_path/wmt21_data

# Run over datasets.
for dataset in $datasets
do
	mkdir -p $dataset
	cd $dataset

	echo "Processing "$dataset

	for l_pair in $lang_pair
	do
	    if [ -d $l_pair  ]; then
                if [ ! -z $l_pair ];then
                    continue
                fi
            fi
	    echo $l_pair
	    src=$(echo $l_pair| cut -d'-' -f 1)
	    tgt=$(echo $l_pair| cut -d'-' -f 2)	

	    if [ $dataset == 'WikiMatrix' ] || [ $dataset == 'Books' ] || [ $dataset == 'bible-uedin' ] \
	    	|| [ $dataset == 'TED2020' ]; then
			wget https://opus.nlpl.eu/download.php?f=$dataset/v1/moses/$src-$tgt.txt.zip
	    elif [ $dataset == 'ParaCrawl' ] || [ $dataset == 'Europarl' ]; then
			wget https://opus.nlpl.eu/download.php?f=$dataset/v8/moses/$src-$tgt.txt.zip
	    elif [ $dataset == 'Opus100' ] || [ $dataset == 'JW300' ]; then
			mkdir -p $l_pair
			cd $l_pair
			echo 'y' |opus_read -d $dataset -s $src -t $tgt -wm moses -w $dataset.$src $dataset.$tgt
			rm -rf *.zip
			cd ..
    	    elif [ $dataset == 'GlobalVoices' ]; then
			wget https://opus.nlpl.eu/download.php?f=$dataset/v2018q4/moses/$src-$tgt.txt.zip
	    elif [[ $dataset == 'Wikipedia' ]]; then
			wget https://opus.nlpl.eu/download.php?f=$dataset/v1.0/moses/$src-$tgt.txt.zip
	    elif [[ $dataset == 'MultiCCAligned' ]]; then
			wget https://opus.nlpl.eu/download.php?f=$dataset/v1.1/moses/$src-$tgt.txt.zip
	    fi

	    zip_file=./*.zip*
	    unzip $zip_file -d ./$l_pair
	    rm -rf $zip_file

	done

	cd ..
done

# Download validation set.
# Can't access validation using common tools (probably due to the password requirement).
# Thus, it is now a requirement.

# Download test set.
cd ..
if [[ -d testSource ]]; then
	echo 'Test already exists.'
else
	curl https://cloud.dfki.de/owncloud/index.php/s/DETKzNpciFyiHRC/download/testSource.tar --output test.tar
	tar -xvf test.tar
	rm test.tar
	# Extract from .xml file.
	cur_folder = `pwd`
	python $root_path/scripts/xml2txt.py $cur_folder/testSource/wikipedia/wp.test.ca.xml
fi
