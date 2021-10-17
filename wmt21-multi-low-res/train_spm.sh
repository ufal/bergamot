#!/bin/bash

spm=sentencepiece/build/src

input=$1        # List of files or a single file with the concatenation between files.
model_name=$2   # Output files.
vocab_size=$3   
user_symb=$4    # Extra symbols defined by the user.
#$5             # Anything you pass here will use only $user_symb without $std_symb.

std_symb=\<sep\>,\<ca\>,\<fr\>,\<en\>,\<es\>,\<it\>,\<oc\>,\<ro\>

if [[ -v 5 ]];
then
        def_symb=$user_symb
else
        def_symb=$std_symb,$user_symb
fi

# Create SentencePiece model.
$spm/spm_train --user_defined_symbols=$def_symb --input_sentence_size=5000000 --input=$input \
        --model_prefix=$model_name --vocab_size=$vocab_size --model_type=bpe
