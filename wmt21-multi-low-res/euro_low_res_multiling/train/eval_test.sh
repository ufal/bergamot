
for dir in any-ocroit ca-ocroit any-any
do
cd $dir
mkdir test_results
for model in model/*best-bleu*decoder.yml
do
        model=$(basename $model)

for lang in oc  ro it
do

cat ../any-any/test.snt | bash ../../../add_tags.sh "$lang" | bash trans_params.sh -c model/$model -b 8 -n 1.0 > test_"$lang".out
cat test_"$lang".out | sacrebleu -m bleu chrf -w 4 ../any-any/wp.test."$lang".snt > test_results/"$model"_ca"$lang"_test_bleu

done

done
cd ..
done

for dir in  ca-ro ca-it ca-oc
do
cd $dir
mkdir test_results


for model in model/*best-bleu*decoder.yml
do
	model=$(basename $model)

cat ../any-any/test.snt | bash trans_params.sh -c model/$model -b 8 -n 1.0 > test.out
cat test.out | sacrebleu -m bleu chrf -w 4 ../any-any/wp.test."$lang".snt > test_results/"$model"_test_bleu


cat ../any-any/test.snt | bash trans_params.sh -c model/$model -b 8 -n 1.0 > test.out
cat test.out | sacrebleu -m bleu chrf -w 4 ../any-any/wp.test."$lang".snt > test_results/"$model"_test_bleu_any_any


cat ../any-any/test.snt | bash trans_chars_params.sh.sh -c model/$model -b 8 -n 1.0 > test.out
cat test.out | sacrebleu -m bleu chrf -w 4 ../any-any/wp.test."$lang".snt > test_results/"$model"_test_bleu_chars






done
cd ..
done
