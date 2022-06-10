#!/bin/bash
set -ex
marian=/home/aires/personal_work_troja/marian_exp/marian-gpu/marian/build
tgt_lang="es"

cd /home/aires/personal_work_troja/wmt21_multi_low_res/experiments/multisource/ca-$tgt_lang
$marian/marian \
    --model model/model.ca-$tgt_lang.npz  --type transformer \
    --train-sets data/all_text.ca-$tgt_lang.cln.ca.sp data/all_text.ca-$tgt_lang.cln.$tgt_lang.sp  \
    --max-length 150 \
    --vocabs model/ca-$tgt_lang.vocab.yml model/ca-$tgt_lang.vocab.yml \
    --mini-batch-fit -w 9300 --maxi-batch 1000 \
    --early-stopping 100 \
    --valid-freq 2500 --save-freq 2500 --disp-freq 250  --valid-script-path ./val_decode.sh \
    --valid-metrics cross-entropy perplexity translation bleu \
    --valid-sets data/val/QED.ca-$tgt_lang.ca.sp data/val/QED.ca-$tgt_lang.$tgt_lang.sp  \
    --valid-translation-output out/valid.update{U}.output \
    --valid-mini-batch 16 --overwrite  \
    --quiet-translation \
    --beam-size 4 --normalize 0.6 \
    --log model/train.log --valid-log model/valid.log \
    --enc-depth 6 --dec-depth 6 \
    --transformer-heads 8 --keep-best \
    --transformer-postprocess-emb d \
    --transformer-postprocess dan \
    --transformer-dropout 0.1 --label-smoothing 0.1 \
    --learn-rate 0.0005 --lr-warmup 16000 --lr-decay-inv-sqrt 16000 --lr-report \
    --optimizer-params 0.9 0.98 1e-09 --clip-norm 5 \
    --tied-embeddings-all --optimizer-delay 1 \
    --devices 0 1  --sync-sgd --seed 1111 --sqlite \
    --exponential-smoothing --no-restore-corpus 

