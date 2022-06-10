#!/bin/bash

base_path=/home/aires/personal_work_troja/style_transfer/data/gender/fr-en

cat $1 |  /home/aires/personal_work_troja/marian_exp/marian-task/bin/sacrebleu -b $base_path/europarl.remainder.fr-en.en-fr_en.gender_tags.tgt.test

