
mkdir test_results
for model in model/*best-bleu*decoder.yml
do
        model=$(basename $model)

for lang in oc  ro it
do

cat ../any-any/test.snt | bash ../../../add_tags.sh "$lang" | bash trans_params.sh -c model/$model -d 0  -b 8 -n 1.0 --mini-batch 8 > test_"$lang".out
cat test_"$lang".out | sacrebleu -m bleu chrf -w 4 ../any-any/wp.test."$lang".snt > test_results/"$model"_ca"$lang"_test_bleu


done

done
