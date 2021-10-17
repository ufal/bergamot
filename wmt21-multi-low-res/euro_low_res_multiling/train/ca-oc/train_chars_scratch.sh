#!/bin/bash
set -ex
export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:/opt/cuda/10.1/lib64:/opt/cuda/10.1/cudnn/7.6/lib64
#cd marian-dev2/build
#/home/jon/cmake-3.19.0-Linux-x86_64/bin/cmake -DCUDA_TOOLKIT_ROOT_DIR=/opt/cuda/10.1/ -DUSE_SENTENCEPIECE=on ..
#make -j8
marian=/lnet/express/work/people/jon/marian/build-CUDA-10.2/
tgt_lang="oc"
cd /lnet/express/work/people/jon/wmt21/euro_low_res_multiling/train/ca-$tgt_lang
$marian/marian \
	--model model/model.ca-$tgt_lang.chars.from.scratch.npz  --type transformer \
    --train-sets ../../data/lang_pairs/ca-$tgt_lang/all_text.ca-$tgt_lang.cln.ca.chars ../../data/lang_pairs/ca-$tgt_lang/all_text.ca-$tgt_lang.cln.$tgt_lang.chars  \
    --max-length 450 \
    --vocabs corp/vocab.yml corp/vocab.yml \
    --mini-batch-fit -w 9300 --maxi-batch 1000 \
    --early-stopping 200 \
    --valid-freq 1000 --save-freq 1000 --disp-freq 100  --valid-script-path ./val_chars.sh \
    --valid-metrics cross-entropy perplexity translation bleu-detok \
    --valid-sets wp.dev.ca.chars wp.dev.ca.$tgt_lang.chars \
    --valid-translation-output data/valid.update{U}.output \
    --valid-mini-batch 16 --overwrite  \
    --beam-size 4 --normalize 0.6 \
    --log model/train_chars_from_scratch.log --valid-log model/valid.log \
    --enc-depth 6 --dec-depth 6 \
    --transformer-heads 8 --keep-best \
    --transformer-postprocess-emb d \
    --transformer-postprocess dan \
    --transformer-dropout 0.1 --label-smoothing 0.1 \
    --learn-rate 0.0005 --lr-warmup 16000 --lr-decay-inv-sqrt 16000 --lr-report \
    --optimizer-params 0.9 0.98 1e-09 --clip-norm 5 \
    --tied-embeddings-all --optimizer-delay 1 \
    --devices 0 1 2 3  --sync-sgd --seed 1111 --sqlite -T  /tmp \
    --exponential-smoothing --no-restore-corpus 

