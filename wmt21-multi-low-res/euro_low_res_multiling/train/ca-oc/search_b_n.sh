mkdir search/
model_name=$(basename $1)
for b in {5..12}
do
	for n in {5..18..2}
	do
	n=$(echo $n|pz n/10)
         echo "beam $b" >> search/search_res_"$model_name"
        echo "len norm $n" >> search/search_res_"$model_name"
	cat wp.dev.ca.snt | bash trans_chars_params.sh -c $1 -n $n -b $b > search/"$model_name"_"$b"_"$n".out
	cat search/"$model_name"_"$b"_"$n".out | sacrebleu -m chrf bleu -w 4 wp.dev.oc.snt >> search/search_res_"$model_name"
	done
done
