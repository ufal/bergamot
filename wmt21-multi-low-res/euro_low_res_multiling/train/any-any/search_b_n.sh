mkdir search/
model_name=$(basename $1)
for b in {3..12}
do
	for n in {3..20}
	do
	n=$(echo $n|pz n/10)
	for tgt_lang in ro it oc
	do
         echo "beam $b" >> search/search_res_"$model_name"_$tgt_lang
        echo "len norm $n" >> search/search_res_"$model_name"_$tgt_lang
	cat wp.dev.ca.snt | bash ../../../add_tags.sh $tgt_lang  | bash trans_params.sh -c $1 -n $n -b $b > search/"$model_name"_"$b"_"$n"_"$tgt_lang".out
	cat search/"$model_name"_"$b"_"$n"_"$tgt_lang".out | sacrebleu -m chrf bleu -w 4 wp.dev.$tgt_lang.snt >> search/search_res_"$model_name"_"$tgt_lang"
done
	done
done
