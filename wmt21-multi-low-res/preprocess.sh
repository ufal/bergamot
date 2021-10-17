cd euro_low_res_multiling/data/lang_pairs/
set -ex
spm=/lnet/express/work/people/jon/marian/build-CPUONLY/
moses=/lnet/express/work/people/jon/moses-scripts/scripts/


grep -v "^<" ../validation_set/validation/wikipedia/dev/wp.dev.ca.xml > ../validation_set/validation/wikipedia/dev/wp.dev.ca.snt

rm -f all_text.ca-any.cln.ca all_text.ca-any.cln.tags.ca all_text.ca-any.cln.any wp.dev.ca-any.ca.tags.snt wp.dev.ca-any.ca.snt wp.dev.ca-any.any.snt

for lang in  "it" "oc" "ro"
do
cd ca-$lang
$moses/training/clean-corpus-n.perl -ratio 2.5 all_text.ca-$lang ca $lang all_text.ca-$lang.cln 1 150
cat all_text.ca-$lang.cln.ca | bash ../../../../add_tags.sh $lang > all_text.ca-$lang.cln.tags.ca
$spm/spm_train --input=all_text.ca-$lang.cln.tags.ca,all_text.ca-$lang.cln.$lang --model_prefix=ca-$lang --vocab_size=8000 
$spm/spm_encode --model ca-$lang.model < all_text.ca-$lang.cln.ca >  all_text.ca-$lang.cln.ca.sp
$spm/spm_encode --model ca-$lang.model < all_text.ca-$lang.cln.tags.ca >  all_text.ca-$lang.cln.ca.tags.sp

$spm/spm_encode --model ca-$lang.model < all_text.ca-$lang.cln.$lang >  all_text.ca-$lang.cln.$lang.sp

grep -v "^<" ../../validation_set/validation/wikipedia/dev/wp.dev.$lang.xml >  ../../validation_set/validation/wikipedia/dev/wp.dev.$lang.snt
cp ../../validation_set/validation/wikipedia/dev/wp.dev.ca.snt ../../validation_set/validation/wikipedia/dev/wp.dev.$lang.snt .
cat wp.dev.ca.snt | bash ../../../../add_tags.sh $lang > wp.dev.ca.tags.snt

$spm/spm_encode --model ca-$lang.model < wp.dev.ca.tags.snt > wp.dev.ca.tags.sp
$spm/spm_encode --model ca-$lang.model < wp.dev.ca.snt > wp.dev.ca.sp
$spm/spm_encode --model ca-$lang.model < wp.dev.$lang.snt > wp.dev.ca.$lang.sp



cat all_text.ca-$lang.cln.ca  >> ../all_text.ca-any.cln.ca
cat all_text.ca-$lang.cln.tags.ca >> ../all_text.ca-any.cln.tags.ca
cat all_text.ca-$lang.cln.$lang  >> ../all_text.ca-any.cln.any

cat wp.dev.ca.tags.snt  >> ../wp.dev.ca-any.ca.tags.snt
cat wp.dev.ca.snt  >> ../wp.dev.ca-any.ca.snt
cat wp.dev.$lang.snt  >> ../wp.dev.ca-any.any.snt


cd ..

done

#$spm/spm_train --input=all_text.ca-any.cln.ca,all_text.ca-any.cln.any --model_prefix=ca-any --vocab_size=32000
#$spm/spm_encode --model  ca-any.model < all_text.ca-any.cln.ca > all_text.ca-any.cln.ca.sp
#$spm/spm_encode --model  ca-any.model < all_text.ca-any.cln.tags.ca > all_text.ca-any.cln.ca.tags.sp


#$spm/spm_encode --model  ca-any.model < all_text.ca-any.cln.any > all_text.ca-any.cln.any.sp

#$spm/spm_encode --model  ca-any.model < wp.dev.ca-any.ca.tags.snt > wp.dev.ca-any.ca.tags.sp
#$spm/spm_encode --model  ca-any.model < wp.dev.ca-any.any.snt > wp.dev.ca-any.any.sp


