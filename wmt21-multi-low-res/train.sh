marian=/home/aires/personal_work_troja/marian_exp/marian-gpu/marian/build
src_lang=$1
tgt_lang=$2
train_path=$3
prev_lang=${4:-$src_lang}

cd $train_path

$marian/marian \
    --model model/model.$src_lang-$tgt_lang.npz  --type transformer \
    --train-sets data/all_texts.$prev_lang-$tgt_lang.cln.$src_lang.sp data/all_texts.ca-$tgt_lang.cln.$tgt_lang.sp  \
    --max-length 150 \
    --vocabs model/$src_lang-$tgt_lang.vocab.yml model/$src_lang-$tgt_lang.vocab.yml \
    --mini-batch-fit -w 9300 --maxi-batch 1000 \
    --early-stopping 200 \
    --valid-freq 2500 --save-freq 2500 --disp-freq 250  --valid-script-path ./val_decode.sh \
    --valid-script-args $src_lang $tgt_lang $train_path
    --valid-metrics cross-entropy perplexity translation bleu \
    --valid-sets data/val/all_texts.$src_lang.sp data/val/all_texts.$tgt_lang.sp  \
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

