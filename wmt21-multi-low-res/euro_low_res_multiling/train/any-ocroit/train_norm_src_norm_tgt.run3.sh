#!/bin/bash
set -ex
export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:/opt/cuda/10.1/lib64:/opt/cuda/10.1/cudnn/7.6/lib64
#cd marian-dev2/build
#/home/jon/cmake-3.19.0-Linux-x86_64/bin/cmake -DCUDA_TOOLKIT_ROOT_DIR=/opt/cuda/10.1/ -DUSE_SENTENCEPIECE=on ..
#make -j8
marian=/lnet/express/work/people/jon/marian/build-CUDA-10.2/

if [ $(hostname) = dll10 ];
then
	marian=/lnet/express/work/people/jon/marian/build-CUDA-11.1/
#	echo "dll10"
fi

if [ $(hostname) = dll9 ];
then
        marian=/lnet/express/work/people/jon/marian/build-CUDA-11.1/
#       echo "dll10"
fi



cd /lnet/express/work/people/jon/wmt21/euro_low_res_multiling/train/any-ocroit
$marian/marian \
	--model model/model.any-ocroit.norm_src_norm_tgt.npz  --type transformer \
    --train-sets ../../data/add_resources/all_text.any-ocroit.cln.src ../../data/add_resources/all_text.any-ocroit.cln.tgt  \
    --max-length 350 \
    --vocabs /lnet/express/work/people/jon/wmt21/euro_low_res_multiling/data/add_resources/any-any.graph+phon.spm /lnet/express/work/people/jon/wmt21/euro_low_res_multiling/data/add_resources/any-any.graph+phon.spm \
    --mini-batch-fit -w 12300 --maxi-batch 1000 \
    --early-stopping 200 \
    --valid-freq 2500 --save-freq 2500 --disp-freq 500  --valid-script-path ./val_decode.sh \
    --valid-metrics cross-entropy perplexity translation bleu-detok \
    --valid-sets wp.dev.ca-any.ca.tags.graph+fakephon  wp.dev.wp.dev.ca-any.any.graph+phon \
    --valid-translation-output data/valid.update{U}.output \
    --valid-mini-batch 16 --overwrite  \
    --beam-size 4 --normalize 0.6 \
    --log model/norm_src_norm_tgt.log --valid-log model/valid.log \
    --enc-depth 6 --dec-depth 6 \
    --transformer-heads 8 --keep-best \
    --transformer-postprocess-emb d \
    --transformer-postprocess dan \
    --transformer-dropout 0.1 --label-smoothing 0.1 \
    --learn-rate 0.0002 --lr-warmup 16000 --lr-decay-inv-sqrt 16000 --lr-report \
    --optimizer-params 0.9 0.98 1e-09 --clip-norm 5 \
    --tied-embeddings-all --optimizer-delay 1 \
    --devices 0 1 2 3  --sync-sgd --seed 1111 --sqlite -T /mnt/h/tmp/ \
    --exponential-smoothing --no-restore-corpus 

