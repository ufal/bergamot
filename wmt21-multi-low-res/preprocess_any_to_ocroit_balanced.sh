cd euro_low_res_multiling/data/add_resources/
set -ex
spm=/lnet/express/work/people/jon/marian/build-CPUONLY/
moses=/lnet/express/work/people/jon/moses-scripts/scripts/

rm -f all_text.any-ocroit.cln.balanced.tgt all_text.any-ocroit.cln.balanced.src all_text.any-it.cln.balanced.tgt all_text.any-ro.cln.balanced.tgt all_text.any-oc.cln.balanced.tgt all_text.any-it.cln.balanced.src all_text.any-ro.cln.balanced.src all_text.any-oc.cln.balanced.src all_text.any-oc.cln.src all_text.any-ro.cln.src all_text.any-it.cln.src all_text.any-oc.cln.tgt all_text.any-ro.cln.tgt all_text.any-it.cln.tgt



for pair in en-it  en-oc  en-ro es-it es-oc es-ro  fr-it  fr-oc  fr-ro
do
echo $pair
cd $pair
src_lang=$(echo $pair| cut -d'-' -f 1)
tgt_lang=$(echo $pair| cut -d'-' -f 2)

#$moses/training/clean-corpus-n.perl -ratio 2.5 all_text.$src_lang-$tgt_lang $src_lang $tgt_lang all_text.$src_lang-$tgt_lang.cln 1 150
#cat all_text.$src_lang-$tgt_lang.cln.$src_lang | bash ../../../../add_tags.sh $tgt_lang > all_text.$src_lang-$tgt_lang.cln.tags.$src_lang
#cat all_text.$src_lang-$tgt_lang.cln.$tgt_lang | bash ../../../../add_tags.sh $src_lang > all_text.$src_lang-$tgt_lang.cln.tags.$tgt_lang

cat all_text.$src_lang-$tgt_lang.cln.tags.$src_lang  >> ../all_text.any-$tgt_lang.cln.src
#cat all_text.$src_lang-$tgt_lang.cln.tags.$tgt_lang >> ../all_text.any-any.cln.src

cat all_text.$src_lang-$tgt_lang.cln.$tgt_lang  >> ../all_text.any-$tgt_lang.cln.tgt
#cat all_text.$src_lang-$tgt_lang.cln.$src_lang >> ../all_text.any-any.cln.tgt


cd ..

done
for lang in it ro oc
do
cat ../lang_pairs/ca-$lang/all_text.ca-$lang.cln.tags.ca >> all_text.any-$lang.cln.src
cat ../lang_pairs/ca-$lang/all_text.ca-$lang.cln.$lang >> all_text.any-$lang.cln.tgt
done

# oversample smaller corpora to have same size as it
it_size=$(wc -l all_text.any-it.cln.tgt | cut -d' ' -f1)
cat all_text.any-it.cln.tgt >> all_text.any-ocroit.cln.balanced.tgt
cat all_text.any-it.cln.src >> all_text.any-ocroit.cln.balanced.src

for lang in ro oc
do
python /lnet/express/work/people/jon/oversample.py all_text.any-$lang.cln.src all_text.any-$lang.cln.tgt $it_size all_text.any-$lang.cln.balanced.src all_text.any-$lang.cln.balanced.tgt
cat all_text.any-$lang.cln.balanced.src >> all_text.any-ocroit.cln.balanced.src
cat all_text.any-$lang.cln.balanced.tgt >> all_text.any-ocroit.cln.balanced.tgt

done
exit

#$spm/spm_train --input_sentence_size  10000000 --input=all_text.any-any.cln.src,all_text.any-any.cln.tgt --model_prefix=any-any --vocab_size=32000
$spm/spm_encode --model  any-any.model < all_text.any-ocroit.cln.balanced.src  > all_text.any-ocroit.cln.balanced.src.sp
$spm/spm_encode --model  any-any.model < all_text.any-ocroit.cln.balanced.tgt > all_text.any-ocroit.cln.balanced.tgt.sp



