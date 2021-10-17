mkdir search/
tgt_lang=ro
for b in {3..12}
do
	for n in {4..20}
	do
	n=$(echo $n|pz n/10)
	echo "beam $b" >> search_res
	echo "len norm $n" >> search_res
	bash trans_params.sh -c $1 -n $n -b $b > search/$b_$n.out
	cat search/$b_$n.out | sacrebleu -m chrf bleu -w 4 wp.dev.$tgt_lang.snt
	done
done
