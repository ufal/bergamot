#!/bin/bash
# preprocess additional (not evaluated) language pairs
set -ex
cd euro_low_res_multiling/data/add_resources/
spm=/lnet/express/work/people/jon/marian/build-CPUONLY/
moses=/lnet/express/work/people/jon/moses-scripts/scripts/

rm -f all_text.any-any.cln.src all_text.any-any.cln.tgt

for pair in ca-en  ca-es  ca-fr  ca-pt  en-it  en-oc  en-ro  es-it	es-oc  es-ro  fr-it  fr-oc  fr-ro
do
echo $pair
cd $pair
src_lang=$(echo $pair| cut -d'-' -f 1)
tgt_lang=$(echo $pair| cut -d'-' -f 2)

$moses/training/clean-corpus-n.perl -ratio 2.5 all_text.$src_lang-$tgt_lang $src_lang $tgt_lang all_text.$src_lang-$tgt_lang.cln 1 150
cat all_text.$src_lang-$tgt_lang.cln.$src_lang | bash ../../../../add_tags.sh $tgt_lang > all_text.$src_lang-$tgt_lang.cln.tags.$src_lang
cat all_text.$src_lang-$tgt_lang.cln.$tgt_lang | bash ../../../../add_tags.sh $src_lang > all_text.$src_lang-$tgt_lang.cln.tags.$tgt_lang


cat all_text.$src_lang-$tgt_lang.cln.tags.$src_lang  >> ../all_text.any-any.cln.src
cat all_text.$src_lang-$tgt_lang.cln.tags.$tgt_lang >> ../all_text.any-any.cln.src

cat all_text.$src_lang-$tgt_lang.cln.$tgt_lang  >> ../all_text.any-any.cln.tgt
cat all_text.$src_lang-$tgt_lang.cln.$src_lang >> ../all_text.any-any.cln.tgt


cd ..

done
cat ../lang_pairs/all_text.ca-any.cln.tags.ca >> all_text.any-any.cln.src
cat ../lang_pairs/all_text.ca-any.cln.any >> all_text.any-any.cln.tgt

$spm/spm_train --input_sentence_size  10000000 --input=all_text.any-any.cln.src,all_text.any-any.cln.tgt --model_prefix=any-any --vocab_size=32000
$spm/spm_encode --model  any-any.model < all_text.any-any.cln.src  > all_text.any-any.cln.src.sp
$spm/spm_encode --model  any-any.model < all_text.any-any.cln.tgt > all_text.any-any.cln.tgt.sp



