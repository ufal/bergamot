lang=oc
mkdir dev_results
for model in model/*chars*base*best-bleu*decoder.yml
do
        model=$(basename $model)



cat ../any-any/dev.snt  | bash trans_chars_params.sh -c model/$model -d 0  -b 8 -n 1.0 --mini-batch 8 > dev.out
cat dev.out | sacrebleu -m bleu chrf -w 4 ../any-any/wp.dev."$lang".snt > dev_results/"$model"_dev_bleu_chars


cat ../any-any/test.snt  | bash trans_chars_params.sh -c model/$model -d 0  -b 8 -n 1.0 --mini-batch 8 > test.out
cat test.out | sacrebleu -m bleu chrf -w 4 ../any-any/wp.test."$lang".snt > test_results/"$model"_test_bleu_chars










done
