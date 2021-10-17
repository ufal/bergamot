#!/bin/bash
set -ex

cd /lnet/express/work/people/jon/wmt21
cd euro_low_res_multiling/data/add_resources/
spm=/lnet/express/work/people/jon/marian/build-CPUONLY/
moses=/lnet/express/work/people/jon/moses-scripts/scripts/



for pair in    es-ro  fr-it  fr-oc  fr-ro ca-en  ca-es  ca-fr  ca-pt  en-it  en-oc  en-ro
do
echo $pair
cd $pair
src_lang=$(echo $pair| cut -d'-' -f 1)
tgt_lang=$(echo $pair| cut -d'-' -f 2)

$moses/training/clean-corpus-n.perl -ratio 2.5 all_text.$src_lang-$tgt_lang $src_lang $tgt_lang all_text.$src_lang-$tgt_lang.cln 1 150
if [ ! -d parts ]; then
mkdir parts
fi
parts=32
split -d -n l/$parts all_text.$src_lang-$tgt_lang.cln.$src_lang parts3/all_text.$src_lang-$tgt_lang.cln.$src_lang.part
cd ..
done
cd /lnet/express/work/people/jon/wmt21/phonemizer_parallel
for pair in  fr-oc  es-ro  fr-it  fr-oc  fr-ro ca-en  ca-es  ca-fr  ca-pt  en-it  en-oc  en-ro

do
cp add_phonemes_template.sh preprocess_add_phon_para_"$pair"_00..07.sh
sed -i "s/\$split/00..07/g" preprocess_add_phon_para_"$pair"_00..07.sh

cp add_phonemes_template.sh preprocess_add_phon_para_"$pair"_08..15.sh
sed -i "s/\$split/08..15/g" preprocess_add_phon_para_"$pair"_08..15.sh

cp add_phonemes_template.sh preprocess_add_phon_para_"$pair"_16..23.sh
sed -i "s/\$split/16..23/g" preprocess_add_phon_para_"$pair"_16..23.sh

cp add_phonemes_template.sh preprocess_add_phon_para_"$pair"_24..31.sh
sed -i "s/\$split/24..31/g" preprocess_add_phon_para_"$pair"_24..31.sh

sed -i "s/pair=xx/pair=$pair/g" preprocess_add_phon_para_"$pair"_*.sh
#exit
qsub -q 'cpu-*' -l mem_free=8G,act_mem_free=8G -pe smp 16 preprocess_add_phon_para_"$pair"_00..07.sh
qsub -q 'cpu-*' -l mem_free=8G,act_mem_free=8G -pe smp 16 preprocess_add_phon_para_"$pair"_08..15.sh
qsub -q 'cpu-*' -l mem_free=8G,act_mem_free=8G -pe smp 16 preprocess_add_phon_para_"$pair"_16..23.sh
qsub -q 'cpu-*' -l mem_free=8G,act_mem_free=8G -pe smp 16 preprocess_add_phon_para_"$pair"_24..31.sh

done

