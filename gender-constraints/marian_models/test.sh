#/bin/bash

marian_build=/home/aires/personal_work_troja/marian_exp/marian-gpu/marian/build

lang_pair=$1
input_file=$2

cat $input_file | $marian_build/marian-decoder -c model_$lang_pair/model.npz.decoder.yml > $input_file.out

# $input_file | $marian_build/marian-decoder -m model_$lang_pair/model.npz -v model_$lang_pair/vocab.$lang_pair.spm model_$lang_pair/vocab.$lang_pair.spm -o $input_file.out
