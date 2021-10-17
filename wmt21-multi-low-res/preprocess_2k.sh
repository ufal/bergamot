#!/bin/bash
#create 2k sp models for all the language pairs
set -ex
cd euro_low_res_multiling/data/lang_pairs/
spm=/lnet/express/work/people/jon/marian/build-CPUONLY/
moses=/lnet/express/work/people/jon/moses-scripts/scripts/


for lang in  "it" "oc" "ro"
do
cd ca-$lang
$spm/spm_train --input=all_text.ca-$lang.cln.tags.ca,all_text.ca-$lang.cln.$lang --model_prefix=ca-$lang --vocab_size=2000 
$spm/spm_encode --model ca-$lang.model < all_text.ca-$lang.cln.ca >  all_text.ca-$lang.cln.ca.2ksp
$spm/spm_encode --model ca-$lang.model < all_text.ca-$lang.cln.tags.ca >  all_text.ca-$lang.cln.ca.tags.2ksp

$spm/spm_encode --model ca-$lang.model < all_text.ca-$lang.cln.$lang >  all_text.ca-$lang.cln.$lang.2ksp


$spm/spm_encode --model ca-$lang.model < wp.dev.ca.tags.snt > wp.dev.ca.tags.2ksp
$spm/spm_encode --model ca-$lang.model < wp.dev.ca.snt > wp.dev.ca.2ksp
$spm/spm_encode --model ca-$lang.model < wp.dev.$lang.snt > wp.dev.ca.$lang.2ksp
cp wp* ../../../../euro_low_res_multiling/train/ca-$lang

cd ..

done



