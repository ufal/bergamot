mkdir search_any/
model_name=$(basename $1)
for b in {6..12}
do
	for n in {7..30..2}
	do
	n=$(echo $n|pz n/10)
         echo "beam $b" >> search_any/search_res_"$model_name"
        echo "len norm $n" >> search_any/search_res_"$model_name"
	cat wp.dev.ca.tags.snt | bash trans_any_params.sh -c $1 -n $n -b $b > search_any/"$model_name"_"$b"_"$n".out
	cat search_any/"$model_name"_"$b"_"$n".out | sacrebleu -m chrf bleu -w 4 wp.dev.oc.snt >> search_any/search_res_"$model_name"
	done
done
