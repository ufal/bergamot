#!/bin/bash
set -ex
export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:/opt/cuda/10.1/lib64:/opt/cuda/10.1/cudnn/7.6/lib64
#cd marian-dev2/build
#/home/jon/cmake-3.19.0-Linux-x86_64/bin/cmake -DCUDA_TOOLKIT_ROOT_DIR=/opt/cuda/10.1/ -DUSE_SENTENCEPIECE=on ..
#make -j8
tmp=/tmp
marian=/lnet/express/work/people/jon/marian/build-CUDA-10.2/
#if [[ $(hostname)==dll10 ]];then
#	marian=/lnet/express/work/people/jon/marian/build-CUDA-11.1/
#	tmp=.
#	echo "dll10"
#fi

cd /lnet/express/work/people/jon/wmt21/euro_low_res_multiling/train/ca-ocroit
$marian/marian \
	--model model/model.ca-ocroit.big.npz  --type transformer --task transformer-big\
    --train-sets ../../data/lang_pairs/all_text.ca-any.cln.ca.tags.sp ../../data/lang_pairs/all_text.ca-any.cln.any.sp  \
    --max-length 150 \
    --vocabs corp/vocab.yml corp/vocab.yml \
    --mini-batch-fit -w 11300 --maxi-batch 1000 \
    --early-stopping 200 \
    --valid-freq 2500 --save-freq 2500 --disp-freq 500  --valid-script-path ./val_decode.sh \
    --valid-metrics cross-entropy perplexity translation bleu-detok \
    --valid-sets wp.dev.ca-any.ca.tags.sp wp.dev.ca-any.any.sp \
    --valid-translation-output data/valid.update{U}.output \
    --valid-mini-batch 16 --overwrite  \
    --beam-size 4 --normalize 0.6 \
    --log model/train.big.log --valid-log model/valid.log \
    --keep-best \
    --transformer-dropout 0.1 --label-smoothing 0.1 \
    --learn-rate 0.0002 --lr-warmup 32000 --lr-decay-inv-sqrt 32000 --lr-report \
    --optimizer-params 0.9 0.98 1e-09 --clip-norm 5 \
    --tied-embeddings-all --optimizer-delay 1 \
    --devices 0 1 2 3  --sync-sgd --seed 1111 --sqlite -T . \
    --exponential-smoothing --no-restore-corpus 

