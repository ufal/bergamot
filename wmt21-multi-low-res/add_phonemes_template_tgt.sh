#!/bin/bash
cd /lnet/express/work/people/jon/wmt21
cd euro_low_res_multiling/data/add_resources/
set -ex
spm=/lnet/express/work/people/jon/marian/build-CPUONLY/
moses=/lnet/express/work/people/jon/moses-scripts/scripts/
pair=xx

#necessary for parallelization of the phonemizer
tmp_dir=$(mktemp -d -t espeak-XXXXXXXXXX)
export XDG_RUNTIME_DIR="$tmp_dir"


echo $pair
cd $pair
src_lang=$(echo $pair| cut -d'-' -f 1)
tgt_lang=$(echo $pair| cut -d'-' -f 2)

for p in {$split}
do
python -u ../../../../phonemize.py $tgt_lang < parts/all_text.$src_lang-$tgt_lang.cln.$tgt_lang.part$p  > parts/all_text.$src_lang-$tgt_lang.cln.$tgt_lang.part$p.phon  
done
rm -rf "$tmp_dir"

