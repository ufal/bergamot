#!/bin/bash -v

. /home/aires/personal_work_troja/python_envs/style_transf/bin/activate

#/home/aires/personal_work_troja/marian_task/marian-gpu/build/marian-decoder -m model/model.npz --mini-batch 10 -v vocab.csen.spm vocab.csen.spm < data/newstest2014.en > output.de

in=$1 #/home/aires/personal_work_troja/style_transfer/data/gender/winoMT/aggregates/en_pro.txt.pe.input
model=$2

# translate dev set
#cat $in \
#    | /home/aires/personal_work_troja/marian_exp/marian-gpu/marian/build/marian-decoder -c model_enfr/model.npz.decoder.yml \
#    > $in.fr

# GPU
cat $in | /home/aires/personal_work_troja/marian_exp/marian-gpu/marian/build/marian-decoder -c $model > $in.fr

# CPU
#echo $model
#cat $in | /home/aires/personal_work_troja/marian_exp/marian-cpu/build/marian-decoder -c $model > $in.fr

# translate test set
#cat dataset/wmt14/cs-en.en \
#    | /home/aires/personal_work_troja/marian_exp/marian-gpu/marian/build/marian-decoder -c model/model.npz.decoder.yml \
#    > dataset/wmt14/cs-en.en.output_2

#cat $in.fr | /home/aires/personal_work_troja/marian_task/marian-task/bin/sacrebleu -b dataset/wmt14/cs-en.cs
#cat dataset/wmt14/cs-en.en.output | /home/aires/personal_work_troja/marian_task/marian-task/bin/sacrebleu -b dataset/wmt14/cs-en.cs
