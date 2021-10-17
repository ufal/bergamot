#!/bin/bash

. /home/aires/personal_work_troja/python_envs/wmt21/bin/activate

src=$2
tgt=$3
lang_pair=$src-$tgt
data=$4
spm=/home/aires/personal_work_ms/wmt21/sentencepiece/sentencepiece/build/src
spm_model=$data/model/$lang_pair.model

cat $1 | $spm/spm_decode --model $spm_model > $data/out/out_postprocessed
cat $data/out/out_postprocessed | python -m sacrebleu $data/data/val/all_texts.$tgt
