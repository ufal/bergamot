#!/bin/bash

. /home/aires/personal_work_ms/python_envs/wmt21/bin/activate

# English to Target Languages (it, oc, ro).

mkdir -p wmt21_data
cd wmt21_data

corpora=" ParaCrawl WikiMatrix MultiCCAligned Opus100 books bible "
src=en
tgs=" it oc ro "

for corpus in $corpora
do
        echo "Processing " $corpus
        mkdir -p $corpus
        cd $corpus
        for tg in $tgs
	do
                mkdir -p $src-$tg
        	cd $src-$tg
	        #echo y | opus_read -d $corpus -s $src -t $tg -wm moses -w $corpus.$src $corpus.$tg
		wget https://opus.nlpl.eu/download.php?f=$corpus/v8/moses/$src-$tg.txt.zip
		unzip *$src-$tg.txt.zip
        	cd ../
	done
	cd ../
done

# ParaCrawl

echo "Processing ParaCrawl"

mkdir -p ParaCrawl

cd ParaCrawl

# en-it
mkdir -p en-it
wget https://opus.nlpl.eu/download.php?f=ParaCrawl/v8/moses/en-it.txt.zip
unzip *en-it.txt.zip -d en-it

# en-ro
mkdir -p en-ro
wget https://opus.nlpl.eu/download.php?f=ParaCrawl/v8/moses/en-it.txt.zip
unzip *en-it.txt.zip -d en-it

