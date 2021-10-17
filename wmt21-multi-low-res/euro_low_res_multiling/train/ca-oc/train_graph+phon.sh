#!/bin/bash
set -ex
export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:/opt/cuda/10.1/lib64:/opt/cuda/10.1/cudnn/7.6/lib64
#cd marian-dev2/build
#/home/jon/cmake-3.19.0-Linux-x86_64/bin/cmake -DCUDA_TOOLKIT_ROOT_DIR=/opt/cuda/10.1/ -DUSE_SENTENCEPIECE=on ..
#make -j8
marian=/lnet/express/work/people/jon/marian/build-CUDA-10.2/
#if [[ $(hostname)==dll10 ]];then
#	marian=/lnet/express/work/people/jon/marian/build-CUDA-11.1/
#echo "dll10"
#fi

tgt_lang="oc"
cd /lnet/express/work/people/jon/wmt21/euro_low_res_multiling/train/ca-$tgt_lang
$marian/marian \
	--model model/model.ca-$tgt_lang.graph+phon.shuf.npz  --type transformer \
    --train-sets ../../data/lang_pairs/ca-$tgt_lang/all_text.ca-oc.cln.ca.graph+phon.graph+phonsp.shuf_phon ../../data/lang_pairs/ca-$tgt_lang/all_text.ca-oc.cln.oc.graph+phonsp  \
    --max-length 450 \
    --vocabs corp/vocab.graph+phon.yml corp/vocab.graph+phon.yml \
    --mini-batch-fit -w 9300 --maxi-batch 1000 \
    --early-stopping 200 \
    --valid-freq 2000 --save-freq 2000 --disp-freq 100  --valid-script-path ./val.sh \
    --valid-metrics cross-entropy perplexity translation bleu-detok \
    --valid-sets wp.dev.ca.graph+phonsp.shuf_phon  wp.dev.ca.oc.graph+phonsp \
    --valid-translation-output data/valid.update{U}.output \
    --valid-mini-batch 16  \
    --beam-size 4 --normalize 1 \
    --log model/train_graph+phon.log --valid-log model/valid.log \
    --enc-depth 6 --dec-depth 6 \
    --transformer-heads 8 --keep-best \
    --transformer-postprocess-emb d \
    --transformer-postprocess dan \
    --transformer-dropout 0.1 --label-smoothing 0.1 \
    --learn-rate 0.0005 --lr-warmup 16000 --lr-decay-inv-sqrt 16000 --lr-report \
    --optimizer-params 0.9 0.98 1e-09 --clip-norm 5 \
    --tied-embeddings-all --optimizer-delay 1 \
    --devices 0 1  --sync-sgd --seed 1111 --sqlite -T  /tmp \
    --exponential-smoothing --no-restore-corpus 

