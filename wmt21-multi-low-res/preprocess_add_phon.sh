#!/bin/bash
#phonemize additional lanuage pairs
cd /lnet/express/work/people/jon/wmt21
cd euro_low_res_multiling/data/add_resources/
set -ex
spm=/lnet/express/work/people/jon/marian/build-CPUONLY/
moses=/lnet/express/work/people/jon/moses-scripts/scripts/

rm -f euro_low_res_multiling/data/lang_pairs/all_text.ca-any.graph+phon.cln.tags.ca

for pair in ca-en  ca-es  ca-fr  ca-pt  en-it  en-oc  en-ro  es-it	es-oc  es-ro  fr-it  fr-oc  fr-ro
do
echo $pair
cd $pair
src_lang=$(echo $pair| cut -d'-' -f 1)
tgt_lang=$(echo $pair| cut -d'-' -f 2)

$moses/training/clean-corpus-n.perl -ratio 2.5 all_text.$src_lang-$tgt_lang $src_lang $tgt_lang all_text.$src_lang-$tgt_lang.cln 1 150
python -u ../../../../phonemize.py $src_lang < all_text.$src_lang-$tgt_lang.cln.$src_lang > all_text.$src_lang-$tgt_lang.cln.graph+phon.$src_lang  &
cd ..
done
wait


for pair in ca-en  ca-es  ca-fr  ca-pt  en-it  en-oc  en-ro  es-it      es-oc  es-ro  fr-it  fr-oc  fr-ro
do
cat all_text.$src_lang-$tgt_lang.cln.graph+phon.$src_lang | bash ../../../../add_tags.sh $tgt_lang > all_text.$src_lang-$tgt_lang.cln.tags.graph+phon.$src_lang
cat all_text.$src_lang-$tgt_lang.cln.graph+phon.$tgt_lang | bash ../../../../add_tags.sh $src_lang > all_text.$src_lang-$tgt_lang.cln.tags.graph+phon.$tgt_lang
cat all_text.$src_lang-$tgt_lang.cln.tags.graph+phon.$src_lang  >> ../all_text.any-any.cln.graph+phon.src
cat all_text.$src_lang-$tgt_lang.cln.tags.$tgt_lang >> ../all_text.any-any.cln.src
cat all_text.$src_lang-$tgt_lang.cln.graph+phon.$tgt_lang  >> ../all_text.any-any.cln.graph+phon.tgt
cat all_text.$src_lang-$tgt_lang.cln.$src_lang >> ../all_text.any-any.cln.tgt
cd ..
done


cat ../lang_pairs/euro_low_res_multiling/data/lang_pairs/all_text.ca-any.graph+phon.cln.tags.ca >> all_text.any-any.cln.grap+phon.src
cat ../lang_pairs/all_text.ca-any.cln.any >> all_text.any-any.cln.tgt

$spm/spm_train --input_sentence_size  10000000 --input=all_text.any-any.cln.src,all_text.any-any.cln.tgt --model_prefix=any-any.graph+phon --vocab_size=32000
$spm/spm_encode --model  any-any.graph+phon.model < all_text.any-any.cln.graph+phon.src  > all_text.any-any.cln.graph+phon.src.sp
$spm/spm_encode --model  any-any.graph+phon.model < all_text.any-any.cln.tgt > all_text.any-any.cln.graph+phon.tgt.sp



