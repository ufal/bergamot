#!/bin/bash

# model langs.
lang_pair=enfr_factors_partial
seed=2048
trn_src=/home/aires/personal_work_troja/style_transfer/data/gender/fr-en/europarl.remainder.fr-en.en-fr_en.gender_factors.src.train
trn_tgt=/home/aires/personal_work_troja/style_transfer/data/gender/fr-en/europarl.remainder.fr-en.en-fr_en.gender_factors.tgt.train
tst_src=/home/aires/personal_work_troja/style_transfer/data/gender/fr-en/europarl.remainder.fr-en.en-fr_en.gender_factors.src.test
tst_tgt=/home/aires/personal_work_troja/style_transfer/data/gender/fr-en/europarl.remainder.fr-en.en-fr_en.gender_factors.tgt.test
model_path=model_$lang_pair'_'$seed

# create the model directory
mkdir -p $model_path #model_$lang_pair'_'$seed

MARIAN_BUILD=/home/aires/personal_work_troja/marian_exp/marian-gpu/marian/build

# train the model

$MARIAN_BUILD/marian --seed $seed\
    --model $model_path/model.npz  --type transformer \
    --train-sets $trn_src $trn_tgt \
    --max-length 150 \
    --vocabs $model_path/vocab.enfr.spm $model_path/vocab.enfr.spm \
    --mini-batch-fit -w 9300 --maxi-batch 1000 \
    --early-stopping 20 \
    --valid-freq 5000 --save-freq 5000 --disp-freq 500  --valid-script-path ./validate_$lang_pair.sh \
    --valid-metrics cross-entropy perplexity bleu \
    --valid-sets $tst_src $tst_tgt  \
    --valid-mini-batch 32 --overwrite  \
    --quiet-translation \
    --beam-size 4 --normalize 0.6 \
    --log $model_path/train.log --valid-log $model_path/valid.log \
    --enc-depth 6 --dec-depth 6 \
    --transformer-heads 8 --keep-best \
    --transformer-postprocess-emb d \
    --transformer-postprocess dan \
    --transformer-dropout 0.1 --label-smoothing 0.1 \
    --learn-rate 0.0003 --lr-warmup 16000 --lr-decay-inv-sqrt 16000 --lr-report \
    --optimizer-params 0.9 0.98 1e-09 --clip-norm 5 \
    --tied-embeddings-all --optimizer-delay 1 \
    --num-devices 2 --devices 0 1 --sync-sgd  --sqlite \
    --exponential-smoothing --no-restore-corpus
