lang=oc
mkdir dev_results
for model in model/*best-bleu*decoder.yml
do
        model=$(basename $model)


	cat ../any-any/dev.snt  | bash trans_params.sh -c model/$model -d 0  -b 8 -n 1.0 --mini-batch 8 > dev.out
cat dev.out | sacrebleu -m bleu chrf -w 4 ../any-any/wp.dev."$lang".snt > dev_results/"$model"_dev_bleu


cat ../any-any/dev.snt  | bash trans_any_params.sh -c model/$model -d 0  -b 8 -n 1.0 --mini-batch 8 > dev.out
cat dev.out | sacrebleu -m bleu chrf -w 4 ../any-any/wp.dev."$lang".snt > dev_results/"$model"_dev_bleu_any




cat ../any-any/dev.snt  | bash trans_chars_params.sh -c model/$model -d 0  -b 8 -n 1.0 --mini-batch 8 > dev.out
cat dev.out | sacrebleu -m bleu chrf -w 4 ../any-any/wp.dev."$lang".snt > dev_results/"$model"_dev_bleu_chars


cat ../any-any/dev.snt  | bash trans_2k_params.sh -c model/$model -d 0  -b 8 -n 1.0 --mini-batch 8 > dev.out
cat dev.out | sacrebleu -m bleu chrf -w 4 ../any-any/wp.dev."$lang".snt > dev_results/"$model"_dev_bleu_2k








done
