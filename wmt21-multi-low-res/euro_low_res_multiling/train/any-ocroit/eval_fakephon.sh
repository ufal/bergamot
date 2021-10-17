
mkdir dev_results
for model in model/model.any-ocroit.graph+fakephon.spm.run5.npz.best-bleu-detok.npz.decoder.yml
do
        model=$(basename $model)


cat wp.dev.ca-any.ca.tags.graph+fakephon | bash trans_params_phon.sh -c model/$model -d 0 -b 8 -n 1.0 --mini-batch 8 > dev.out


head -n 1269 dev.out > dev_oc.out
head -n 2538 dev.out | tail -n 1269 > dev_it.out
tail -n 1269 dev.out >dev_ro.out
for lang in oc ro it
do
cat dev_"$lang".out | sacrebleu -m bleu chrf -w 4 ../any-any/wp.dev."$lang".snt > dev_results/"$model"_ca"$lang"_dev_bleu
done



done
