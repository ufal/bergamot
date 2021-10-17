mkdir dev_results
for model in model/*best-bleu*dec*yml
do

for lang in oc ro it
do
	model=$(basename $model)
cat dev.snt | bash ../../../add_tags.sh "$lang" | bash trans_params.sh -c model/$model -b 8 -n 1.0 > dev_"$lang".out
cat dev_"$lang".out | sacrebleu -m bleu chrf -w 4 wp.dev."$lang".snt > dev_results/"$model"_ca"$lang"_dev_bleu

done


done

