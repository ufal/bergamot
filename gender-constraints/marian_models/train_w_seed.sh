#!/bin/bash

train=/home/aires/personal_work_troja/style_transfer/marian_models/train.sh
#seeds=( '1' '42' '66' '128' '2048' )

model_name=$1
seed=$2
trn_src=$3
trn_tgt=$4
tst_src=$5
tst_tgt=$6

#for seed in $(seeds[@]);
#do
$train $model_name $seed $trn_src $trn_tgt $tst_src $tst_tgt
#done
