
mkdir dev_results
for model in model/*best-bleu*decoder.yml
do
        model=$(basename $model)

for lang in oc  ro it
do

cat ../any-any/dev.snt | bash ../../../add_tags.sh "$lang" | bash trans_params.sh -c model/$model -d 0 -b 8 -n 1.0 --mini-batch 8 > dev_"$lang".out
cat dev_"$lang".out | sacrebleu -m bleu chrf -w 4 ../any-any/wp.dev."$lang".snt > dev_results/"$model"_ca"$lang"_dev_bleu

cat ../any-any/dev.snt | bash ../../../add_tags.sh "$lang" | bash trans_phon_params.sh -c model/$model -d 0 -b 8 -n 1.0 --mini-batch 8  > dev_"$lang".out
cat dev_"$lang".out | sacrebleu -m bleu chrf -w 4 ../any-any/wp.dev."$lang".snt > dev_results/"$model"_ca"$lang"_dev_bleu_phonsp

cat ../any-any/dev.snt | bash ../../../add_tags.sh "$lang" | bash trans_noprep_params.sh -c model/$model -d 0 -b 8 -n 1.0 --mini-batch 8 > dev_"$lang".out
cat dev_"$lang".out | sacrebleu -m bleu chrf -w 4 ../any-any/wp.dev."$lang".snt > dev_results/"$model"_ca"$lang"_dev_bleu_noprep


done

done
