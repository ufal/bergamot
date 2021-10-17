#!/bin/bash
set -ex
export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:/opt/cuda/10.1/lib64:/opt/cuda/10.1/cudnn/7.6/lib64
#cd marian-dev2/build
#/home/jon/cmake-3.19.0-Linux-x86_64/bin/cmake -DCUDA_TOOLKIT_ROOT_DIR=/opt/cuda/10.1/ -DUSE_SENTENCEPIECE=on ..
#make -j8
marian=/lnet/express/work/people/jon/marian/build-CUDA-10.2/
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

tgt_lang="oc"
cd /lnet/express/work/people/jon/wmt21/euro_low_res_multiling/train/ca-$tgt_lang
$marian/marian \
	--model model/model.ca-$tgt_lang.big.wikbt.bt.chars.from.scratch.new_vocab.npz  --type transformer --task transformer-big\
    --train-sets ../../data/lang_pairs/ca-$tgt_lang/all_text+wikibt+bt.ca-$tgt_lang.cln.ca.sp.chars ../../data/lang_pairs/ca-$tgt_lang/all_text+wikibt+bt.ca-$tgt_lang.cln.$tgt_lang.sp.chars  \
    --max-length 450 \
    --vocabs corp/char_vocab.yml corp/char_vocab.yml \
    --mini-batch-fit -w 10300 --maxi-batch 1000 \
    --early-stopping 200 \
    --valid-freq 1500 --save-freq 1500 --disp-freq 100  --valid-script-path ./val_chars.sh \
    --valid-metrics cross-entropy perplexity  bleu-detok \
    --valid-sets wp.dev.ca.chars wp.dev.ca.$tgt_lang.chars \
    --valid-translation-output data/valid.update{U}.output \
    --valid-mini-batch 16 --overwrite  \
    --beam-size 4 --normalize 0.6 \
    --log model/train_big_chars_from_scratch_new_vocab.log --valid-log model/valid.log \
     --keep-best \
    --transformer-dropout 0.1 --label-smoothing 0.1 \
    --lr-report \
    --optimizer-params 0.9 0.98 1e-09 --clip-norm 5 \
    --tied-embeddings-all --optimizer-delay 1 \
    --devices 0 1 2 3   --sync-sgd --seed 1111 --sqlite -T  /mnt/h/tmp \
    --exponential-smoothing --no-restore-corpus 
rm core
