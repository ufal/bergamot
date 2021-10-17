cd /lnet/express/work/people/jon/wmt21
cd euro_low_res_multiling/data/lang_pairs/
set -ex
spm=/lnet/express/work/people/jon/marian/build-CPUONLY/
moses=/lnet/express/work/people/jon/moses-scripts/scripts/

rm -f all_text.ca-any.phon.cln.ca all_text.ca-any.phon.cln.tags.ca all_text.ca-any.phon.cln.any wp.dev.ca-any.ca.tags.phon wp.dev.ca-any.ca.phon wp.dev.ca-any.any.phon

#
#phonemization moved to phonemize_parallel
#for lang in  "it" "ro"  #"oc"
#do
#cd ca-$lang
##$moses/training/clean-corpus-n.perl -ratio 2.5 all_text.ca-$lang ca.phon $lang all_text.ca-$lang.phon.cln 1 150
#tmp_dir=$(mktemp -d -t espeak-XXXXXXXXXX)

#export XDG_RUNTIME_DIR="$tmp_dir"

#python -u ../../../../phonemize.py ca <  all_text.ca-$lang.cln.ca > all_text.ca-$lang.cln.ca.phon &
#cd ..
#done
#wait

for lang in  "it" "ro"  #"oc"
do
cd ca-$lang
cat parts/all_text.ca-$lang.cln.ca.part{00..31}.phon > all_text.ca-$lang.cln.ca.phon
cat parts/all_text.ca-$lang.cln.$lang.part{00..31}.phon > all_text.ca-$lang.cln.$lang.phon

cat all_text.ca-$lang.cln.ca.phon | bash ../../../../add_tags.sh $lang > all_text.ca-$lang.cln.tags.ca.phon
$spm/spm_train --input=all_text.ca-$lang.cln.tags.ca.phon,all_text.ca-$lang.cln.$lang.phon --user_defined_symbols="<sep>" --model_prefix=ca-$lang.phon --vocab_size=8000 
$spm/spm_encode --model ca-$lang.phon.model < all_text.ca-$lang.cln.ca.phon >  all_text.ca-$lang.cln.ca.phon.phonsp
$spm/spm_encode --model ca-$lang.phon.model < all_text.ca-$lang.cln.tags.ca.phon >  all_text.ca-$lang.cln.ca.tags.phonsp

$spm/spm_encode --model ca-$lang.phon.model < all_text.ca-$lang.cln.$lang.phon >  all_text.ca-$lang.cln.$lang.phon.phonsp

grep -v "^<" ../../validation_set/validation/wikipedia/dev/wp.dev.$lang.xml >  ../../validation_set/validation/wikipedia/dev/wp.dev.$lang.snt
cp ../../validation_set/validation/wikipedia/dev/wp.dev.ca.phon ../../validation_set/validation/wikipedia/dev/wp.dev.$lang.snt .
cat wp.dev.ca.phon | bash ../../../../add_tags.sh $lang > wp.dev.ca.tags.phon

$spm/spm_encode --model ca-$lang.phon.model < wp.dev.ca.tags.phon > wp.dev.ca.tags.phonsp
$spm/spm_encode --model ca-$lang.phon.model < wp.dev.ca.phon > wp.dev.ca.phonsp
python -u ../../../../phonemize.py $lang < wp.dev.$lang.snt > wp.dev.$lang.phon
$spm/spm_encode --model ca-$lang.phon.model < wp.dev.$lang.phon > wp.dev.ca.$lang.phon.phonsp


cat all_text.ca-$lang.cln.ca.phon  >> ../all_text.ca-any.phon.cln.ca
cat all_text.ca-$lang.cln.tags.ca.phon >> ../all_text.ca-any.phon.cln.tags.ca
cat all_text.ca-$lang.cln.$lang.phon  >> ../all_text.ca-any.phon.cln.any

cat wp.dev.ca.tags.phon  >> ../wp.dev.ca-any.ca.tags.phon
cat wp.dev.ca.phon  >> ../wp.dev.ca-any.ca.phon
cat wp.dev.$lang.phon  >> ../wp.dev.ca-any.any.phon


cd ..

done
exit
$spm/spm_train --input=all_text.ca-any.phon.cln.ca,all_text.ca-any.phon.cln.any --model_prefix=ca-any.phon --vocab_size=32000
$spm/spm_encode --model  ca-any.phon.model < all_text.ca-any.phon.cln.ca > all_text.ca-any.phon.cln.ca.sp
$spm/spm_encode --model  ca-any.phon.model < all_text.ca-any.phon.cln.tags.ca > all_text.ca-any.phon.cln.ca.tags.sp


$spm/spm_encode --model  ca-any.phon.model < all_text.ca-any.phon.cln.any > all_text.ca-any.phon.cln.any.sp

$spm/spm_encode --model  ca-any.phon.model < wp.dev.ca-any.phon.ca.tags.snt > wp.dev.ca-any.phon.ca.tags.sp
$spm/spm_encode --model  ca-any.phon.model < wp.dev.ca-any.phon.any.snt > wp.dev.ca-any.phon.any.sp


