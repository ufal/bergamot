#!/bin/bash
cd /lnet/express/work/people/jon/wmt21/euro_low_res_multiling/train/ca-ro
lang=ro
mkdir dev_results
for model in model/*2k*best-bleu*decoder.yml
do
        model=$(basename $model)



cat ../any-any/dev.snt  | bash trans_2k_params.sh -c model/$model --cpu-threads 16 -b 8 -n 1.0 --mini-batch 8 > dev.out
cat dev.out | sacrebleu -m bleu chrf -w 4 ../any-any/wp.dev."$lang".snt > dev_results/"$model"_dev_bleu_chars

cat ../any-any/test.snt  | bash trans_2k_params.sh -c model/$model --cpu-threads 16 -b 8 -n 1.0 --mini-batch 8 > test.out
cat test.out | sacrebleu -m bleu chrf -w 4 ../any-any/wp.test."$lang".snt > test_results/"$model"_test_bleu_chars



done
