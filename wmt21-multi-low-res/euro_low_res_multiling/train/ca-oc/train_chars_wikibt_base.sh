#!/bin/bash
set -ex
export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:/opt/cuda/10.1/lib64:/opt/cuda/10.1/cudnn/7.6/lib64
#cd marian-dev2/build
#/home/jon/cmake-3.19.0-Linux-x86_64/bin/cmake -DCUDA_TOOLKIT_ROOT_DIR=/opt/cuda/10.1/ -DUSE_SENTENCEPIECE=on ..
#make -j8
marian=/lnet/express/work/people/jon/marian/build-CUDA-10.2/
tgt_lang="oc"
cd /lnet/express/work/people/jon/wmt21/euro_low_res_multiling/train/ca-$tgt_lang
if [ $(hostname) = dll10 ];then
	marian=/lnet/express/work/people/jon/marian/build-CUDA-11.1/
	tmp=.
	echo "dll10"
fi

if [ $(hostname) = dll9 ];then
        marian=/lnet/express/work/people/jon/marian/build-CUDA-11.1/
        tmp=.
        echo "dll9"
fi

$marian/marian \
	--model model/model.ca-$tgt_lang.chars.wikibt.from_scratch.base.npz --type transformer --task transformer-base \
    --train-sets ../../data/lang_pairs/ca-$tgt_lang/all_text+wikibt.ca-$tgt_lang.cln.ca.sp.chars  ../../data/lang_pairs/ca-$tgt_lang/all_text+wikibt.ca-$tgt_lang.cln.$tgt_lang.sp.chars  \
    --max-length 450 \
    --vocabs ../any-any/corp/vocab.yml ../any-any/corp/vocab.yml \
    --mini-batch-fit -w 7000 --maxi-batch 1000 \
    --early-stopping 200 \
    --valid-freq 1000 --save-freq 1000 --disp-freq 100  --valid-script-path ./val_chars.sh \
    --valid-metrics cross-entropy perplexity bleu-detok \
    --valid-sets wp.dev.ca.chars wp.dev.ca.$tgt_lang.chars \
    --valid-translation-output data/valid.update{U}.output \
    --valid-mini-batch 4 --overwrite  \
    --beam-size 4 --normalize 0.6 \
    --log model/train_chars_wikibt_from_scratch.base.log --valid-log model/valid.log \
     --keep-best \
    --optimizer-params 0.9 0.98 1e-09 --clip-norm 5 \
    --tied-embeddings-all --optimizer-delay 1 \
    --devices 0 1 2 3   --sync-sgd --seed 1111 --sqlite -T  /mnt/h/tmp \
    --exponential-smoothing --no-restore-corpus 

