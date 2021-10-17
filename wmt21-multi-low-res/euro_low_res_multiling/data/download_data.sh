#!/bin/bash

. /home/aires/personal_work_ms/python_envs/wmt21/bin/activate

mkdir -p wmt21_data
cd wmt21_data

# Download ELRC.
#TODO Find all occurrences of Catalan here.

# Download Paracrawl.
mkdir -p paracrawl
cd paracrawl
wget https://opus.nlpl.eu/download.php?f=ParaCrawl/v7.1/moses/ca-es.txt.zip 
mkdir -p ca-es
unzip *ca-es.txt.zip -d ./ca-es
cd ../

# Download Global voices.
echo "Downloading Global Voices data."

mkdir -p global_voices
cd global_voices
lang_pairs=" ca-en ca-es ca-fr ca-it ca-pt ca-ro "

for pair in $lang_pairs
do
	echo "Processing "$pair
	wget https://opus.nlpl.eu/download.php?f=GlobalVoices/v2018q4/moses/$pair.txt.zip
	mkdir -p $pair
	unzip *$pair.txt.zip -d ./$pair
done
cd ../

# JW300
mkdir -p jw300
cd jw300
tgs=" en es fr it pt oc ro "
for tg in $tgs
do
	mkdir ca-$tg
	cd ca-$tg
	echo y | opus_read -d JW300 -s cat -t $tg -wm moses -w jw300.ca jw300.$tg
	cd ../
done
cd ../

# WikiMatrix
mkdir -p wikimatrix
cd wikimatrix
lang_pairs=" ca-en ca-es ca-fr ca-it ca-oc ca-pt ca-ro "
for pair in $lang_pairs
do
	wget https://opus.nlpl.eu/download.php?f=WikiMatrix/v1/moses/$pair.txt.zip
	mkdir -p $pair
	unzip *$pair.txt.zip -d ./$pair
done
cd ../

# MultiCCAligned
mkdir -p multiccaligned
cd multiccaligned
lang_pairs=" ca-es ca-fr ca-it ca-pt ca-ro "
for pair in $lang_pairs
do
	wget https://opus.nlpl.eu/download.php?f=MultiCCAligned/v1.1/moses/$pair.txt.zip
	mkdir -p $pair
	unzip *$pair.txt.zip -d ./$pair
done
cd ../

# Opus100
mkdir -p opus100
cd opus100
wget http://data.statmt.org/opus-100-corpus/v1.0/supervised/ca-en/opus.ca-en-dev.ca
wget http://data.statmt.org/opus-100-corpus/v1.0/supervised/ca-en/opus.ca-en-dev.en
wget http://data.statmt.org/opus-100-corpus/v1.0/supervised/ca-en/opus.ca-en-test.ca
wget http://data.statmt.org/opus-100-corpus/v1.0/supervised/ca-en/opus.ca-en-test.en
wget http://data.statmt.org/opus-100-corpus/v1.0/supervised/ca-en/opus.ca-en-train.ca
wget http://data.statmt.org/opus-100-corpus/v1.0/supervised/ca-en/opus.ca-en-train.en
cd ../

# Books
mkdir -p books
cd books
wget https://opus.nlpl.eu/download.php?f=Books/v1/xml/ca-en.xml.gz
cd ../

# Wikidata.
mkdir -p wikidata
cd wikidata
wget https://cloud.dfki.de/owncloud/index.php/s/iQooErdWq9fpd5Q/download/wikidata.cleaner_20210325.itcaro
wget https://cloud.dfki.de/owncloud/index.php/s/n3gkLtY7zBcxow8/download/wikidataBilingualsRomance.tar.bz2
wget https://cloud.dfki.de/owncloud/index.php/s/9dRRmmnXEqeqMeX/download/wiktionaryBilingualsRomance.tar
wget https://cloud.dfki.de/owncloud/index.php/s/ErKAW5Cx4bTCmd6/download/it.0.ca.0.ro.0.oc.0.t0.cleaner_20210325
wget https://cloud.dfki.de/owncloud/index.php/s/eDMZfwpEHwo5aca/download/it.0.ca.0.ro.0.t0.cleaner_20210325
wget https://cloud.dfki.de/owncloud/index.php/s/QG9axxgKeWoX2Dc/download/WPtitlesBilingualsRomance.tar.bz2
wget https://cloud.dfki.de/owncloud/index.php/s/Nkx2KiAWgFaCKoA/download/wikidata.cleaner_20210325.itcarooc
cd ../

# English to Target Languages (it, oc, ro).

mkdir -p wmt21_data
cd wmt21_data

corpora=" ParaCrawl GlobalVoices EuroParl JW300 WikiMatrix MultiCCaligned Opus100 books bible "
src=en
tgs=" it oc ro "

for corpus in $corpora
do
	echo "Processing " $corpus
	mkdir -p $corpus
	cd $corpus
	for tg in $tgs
	do
        	mkdir $src-$tg
     	   	cd $src-$tg
	        echo y | opus_read -d ParaCrawl -s $src -t $tg -wm moses -w $corpus.ca $corpus.$tg
        	cd ../
	done
	cd ../
done
