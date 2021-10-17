cat wp.test.ca.xml | python ../ca-"$lang"/testxml2text.py

for model in model/*best-bleu*npz
do

for lang in "$lang" ro it
do

cat test.snt | bash ../../../add_tags.sh "$lang" | bash trans_params.sh -c model/model.any-any.bigger_smaller_vocab.2.npz.best-bleu-detok.npz.decoder.yml -b 8 -n 1.0 > test_"$lang".out
cat test_"$lang".out | sacrebleu wp.test."$lang".snt > test_results/"$model"_ca"$lang"_test_bleu

done


done

