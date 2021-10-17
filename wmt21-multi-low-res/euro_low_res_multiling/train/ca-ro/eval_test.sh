#!/bin/bash
cd /lnet/express/work/people/jon/wmt21/euro_low_res_multiling/train/ca-ro
mkdir test_results
lang=ro
for model in model/*best-bleu*decoder.yml
do
        model=$(basename $model)

cat ../any-any/test.snt  | bash trans_params.sh -c model/$model -d 0 -b 8 -n 1.0 --mini-batch 8 > test.out
cat test.out | sacrebleu -m bleu chrf -w 4 ../any-any/wp.test."$lang".snt > test_results/"$model"_test_bleu


cat ../any-any/test.snt  | bash trans_any_params.sh -c model/$model -d 0  -b 8 -n 1.0 --mini-batch 8 > test.out
cat test.out | sacrebleu -m bleu chrf -w 4 ../any-any/wp.test."$lang".snt > test_results/"$model"_test_bleu_any



cat ../any-any/test.snt  | bash trans_chars_params.sh -c model/$model -d 0 -b 8 -n 1.0 --mini-batch 8 > test.out
cat test.out | sacrebleu -m bleu chrf -w 4 ../any-any/wp.test."$lang".snt > test_results/"$model"_test_bleu_chars







done
