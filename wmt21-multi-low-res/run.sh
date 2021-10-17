#!/bin/bash

cd ..
root_folder=`pwd`

# Set python environment.
echo "Setting python env"
$root_folder/scripts/setup_env.sh
. $root_folder/python_envs/wmt21/bin/activate


lang_pair=${1:-"all"}

echo "Working on "$lang_pair

if [ $lang_pair != "all" ];
then
    lang_pairs=" $lang_pair "
else
    lang_pairs=" ca-it ca-oc ca-ro ca-en ca-fr ca-pt ca-es en-it en-oc en-ro es-it es-oc es-ro fr-it fr-oc fr-ro "
fi

data_folder=$root_folder/data

# Check if data folder exists.
if [ ! -d $data_folder ]; then
    mkdir $data_folder
fi

lang_folder=$data_folder/lang_pairs

# Check if lang_pairs folder exists.
if [ ! -d $lang_folder ]; then
    mkdir $lang_folder
fi

# Set vocab_size.
vocab_size=8000

# For each lang_pair, process it and prepare data.
for l_pair in $lang_pairs; do

    # Download lang_pair.
    if [ $lang_pair == 'all' ]; then
        $root_folder/scripts/download.sh all
    else
        $root_folder/scripts/download.sh $l_pair
    fi

    # Combine data.
    python $root_folder/scripts/combine_data.py $data_folder/wmt21_data $l_pair $lang_folder

    echo $l_pair

    src_tgt=($(echo $l_pair | tr "-" " "))

    # Clean data.
    src=${src_tgt[0]}
    tgt=${src_tgt[1]}

    $root_folder/scripts/clean_corpus.sh $root_folder/scripts $lang_folder/$l_pair/data $src $tgt

    # Train SentencePiece Model.

    # Check if SentencePiece is installed.
    if [ ! -d $root/sentenceíece ]; then
	$root_folder/scripts/download_sp.sh $root_folder
    fi
    # all_texts.ca-oc.cln.ca 
    base_name=all_texts.$l_pair.cln
    $root_folder/scripts/train_spm.sh $lang_folder/$l_pair/data/$base_name.$src,$lang_folder/$l_pair/data/$base_name.$tgt $lang_folder/$l_pair/model/$l_pair $vocab_size

    # Encode using sentencepiece.
    for f in $lang_folder/$l_pair/data/$base_name.*
    do
	    $root_folder/scripts/encode_spm.sh $lang_folder/$l_pair/model/$l_pair.model $f
    done

done
