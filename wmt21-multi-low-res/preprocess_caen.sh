cd euro_low_res_multiling/data/add_resources/
set -ex
spm=/lnet/express/work/people/jon/marian/build-CPUONLY/
moses=/lnet/express/work/people/jon/moses-scripts/scripts/


for pair in  ca-en
do
echo $pair
cd $pair
src_lang=$(echo $pair| cut -d'-' -f 1)
tgt_lang=$(echo $pair| cut -d'-' -f 2)

#$moses/training/clean-corpus-n.perl -ratio 2.5 all_text.$src_lang-$tgt_lang $src_lang $tgt_lang all_text.$src_lang-$tgt_lang.cln 1 150
#cat all_text.$src_lang-$tgt_lang.cln.$src_lang | bash ../../../../add_tags.sh $tgt_lang > all_text.$src_lang-$tgt_lang.cln.tags.$src_lang
#cat all_text.$src_lang-$tgt_lang.cln.$tgt_lang | bash ../../../../add_tags.sh $src_lang > all_text.$src_lang-$tgt_lang.cln.tags.$tgt_lang
$spm/spm_train --input_sentence_size  5000000 --input=all_text.$src_lang-$tgt_lang.cln.tags.$tgt_lang,all_text.$src_lang-$tgt_lang.cln.tags.$src_lang --model_prefix=$src_lang-$tgt_lang --vocab_size=8000
$spm/spm_encode --model $src_lang-$tgt_lang.model  < all_text.$src_lang-$tgt_lang.cln.$src_lang > all_text.$src_lang-$tgt_lang.cln.$src_lang.sp &
$spm/spm_encode --model $src_lang-$tgt_lang.model  < all_text.$src_lang-$tgt_lang.cln.$tgt_lang > all_text.$src_lang-$tgt_lang.cln.$tgt_lang.sp &




cd ..

done


