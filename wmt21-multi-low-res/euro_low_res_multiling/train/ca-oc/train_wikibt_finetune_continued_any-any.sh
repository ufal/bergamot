#!/bin/bash
set -ex
export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:/opt/cuda/10.1/lib64:/opt/cuda/10.1/cudnn/7.6/lib64
#cd marian-dev2/build
#/home/jon/cmake-3.19.0-Linux-x86_64/bin/cmake -DCUDA_TOOLKIT_ROOT_DIR=/opt/cuda/10.1/ -DUSE_SENTENCEPIECE=on ..
#make -j8
marian=/lnet/express/work/people/jon/marian/build-CUDA-10.2/
tgt_lang="oc"
cd /lnet/express/work/people/jon/wmt21/euro_low_res_multiling/train/ca-$tgt_lang
cp ../any-any/model/model.any-any.bigger_smaller_vocab.2.npz model/model.ca-$tgt_lang.wikibt.finetune.continued.any-any.bigger.npz
cp ../any-any/model/model.any-any.bigger_smaller_vocab.2.npz model/model.ca-$tgt_lang.wikibt.finetune.continued.any-any.bigger.npz.orig.npz

cp ../any-any/model/model.any-any.bigger_smaller_vocab.2.npz.optimizer.npz model/model.ca-$tgt_lang.wikibt.finetune.continued.any-any.bigger.npz.optimizer.npz
cp ../any-any/model/model.any-any.bigger_smaller_vocab.2.npz.progress.yml model/model.ca-$tgt_lang.wikibt.finetune.continued.any-any.bigger.progress.yml
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
	--model model/model.ca-$tgt_lang.wikibt.finetune.continued.any-any.bigger.npz --type transformer --task transformer-big \
    --train-sets ../../data/lang_pairs/ca-$tgt_lang/all_text+wikibt+bt.balanced.ca-oc.cln.ca.langtags.anyanysp  ../../data/lang_pairs/ca-$tgt_lang/all_text+wikibt+bt.balanced.ca-oc.cln.oc.anyanysp  \
    --max-length 150 \
    --vocabs ../any-any/corp/vocab_from_sp.txt ../any-any/corp/vocab_from_sp.txt \
    --mini-batch-fit -w 9300 --maxi-batch 1000 \
    --early-stopping 200 \
    --valid-freq 1000 --save-freq 1000 --disp-freq 100  --valid-script-path ./val_chars.sh \
    --valid-metrics cross-entropy perplexity bleu-detok \
    --valid-sets wp.dev.ca.tags.anyanysp wp.dev.$tgt_lang.anyanysp \
    --valid-translation-output data/valid.update{U}.output \
    --valid-mini-batch 4 --overwrite  \
    --beam-size 4 --normalize 0.6 \
    --log model/train_wikibt_finetune_continued_any-any.bigger.log --valid-log model/valid.log \
    --keep-best \
    --enc-depth 16 --transformer-depth-scaling --dec-depth 6 \
    --dim-emb 1024 --transformer-dim-ffn 4096 \
    --transformer-dropout 0.05 --transformer-dropout-attention 0.05 --transformer-dropout-ffn 0.05 --label-smoothing 0.1 \
    --optimizer-params 0.9 0.98 1e-09 --clip-norm 5 \
    --tied-embeddings-all --optimizer-delay 1 \
    --devices 0 1 2 3   --sync-sgd --seed 1111 --sqlite -T  /mnt/h/tmp \
    --exponential-smoothing --no-restore-corpus 

