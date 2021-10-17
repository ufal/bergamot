cd euro_low_res_multiling/data/lang_pairs/
set -ex
spm=/lnet/express/work/people/jon/marian/build-CPUONLY/
moses=/lnet/express/work/people/jon/moses-scripts/scripts/


rm all_text.ca-any.graph+phon.cln.ca all_text.ca-any.graph+phon.cln.tags.ca wp.dev.ca-any.ca.tags.graph+phon wp.dev.ca-any.ca.graph+phon

for lang in  "it"  "oc" "ro" 
do
cd ca-$lang
##$moses/training/clean-corpus-n.perl -ratio 2.5 all_text.ca-$lang ca.graph+phon $lang all_text.ca-$lang.graph+phon.cln 1 150
##python ../../../../phonemize.py ca <  all_text.ca-$lang.cln.ca > all_text.ca-$lang.cln.ca.graph+phon
##cat all_text.ca-$lang.cln.ca.graph+phon | bash ../../../../add_tags.sh $lang > all_text.ca-$lang.cln.tags.ca.graph+phon
paste all_text.ca-$lang.cln.tags.ca all_text.ca-$lang.cln.ca.phon | sed 's/\t/ <sep> /g' > all_text.ca-$lang.cln.tags.ca.graph+phon
paste all_text.ca-$lang.cln.ca all_text.ca-$lang.cln.ca.phon | sed 's/\t/ <sep> /g' > all_text.ca-$lang.cln.ca.graph+phon

#$spm/spm_train --input=all_text.ca-$lang.cln.ca.graph+phon,all_text.ca-$lang.cln.$lang --model_prefix=ca-$lang.graph+phon --vocab_size=8000 
#$spm/spm_encode --model ca-$lang.graph+phon.model < all_text.ca-$lang.cln.ca.graph+phon >  all_text.ca-$lang.cln.ca.graph+phon.graph+phonsp
#$spm/spm_encode --model ca-$lang.graph+phon.model < all_text.ca-$lang.cln.tags.ca.graph+phon >  all_text.ca-$lang.cln.ca.tags.graph+phonsp

#$spm/spm_encode --model ca-$lang.graph+phon.model < all_text.ca-$lang.cln.$lang >  all_text.ca-$lang.cln.$lang.graph+phonsp

#grep -v "^<" ../../validation_set/validation/wikipedia/dev/wp.dev.$lang.xml >  ../../validation_set/validation/wikipedia/dev/wp.dev.$lang.snt
paste ../../validation_set/validation/wikipedia/dev/wp.dev.ca.snt ../../validation_set/validation/wikipedia/dev/wp.dev.ca.phon | sed 's/\t/ <sep> /g' > ../../validation_set/validation/wikipedia/dev/wp.dev.ca.graph+phon
#cp ../../validation_set/validation/wikipedia/dev/wp.dev.ca.graph+phon ../../validation_set/validation/wikipedia/dev/wp.dev.$lang.snt .
#cat wp.dev.ca.graph+phon | bash ../../../../add_tags.sh $lang > wp.dev.ca.tags.graph+phon

##$spm/spm_encode --model ca-$lang.graph+phon.model < wp.dev.ca.tags.graph+phon > wp.dev.ca.tags.graph+phonsp
##$spm/spm_encode --model ca-$lang.graph+phon.model < wp.dev.ca.graph+phon > wp.dev.ca.graph+phonsp
##$spm/spm_encode --model ca-$lang.graph+phon.model < wp.dev.$lang.snt > wp.dev.ca.$lang.graph+phonsp


cat all_text.ca-$lang.cln.ca.graph+phon  >> ../all_text.ca-any.graph+phon.cln.ca
cat all_text.ca-$lang.cln.tags.ca.graph+phon >> ../all_text.ca-any.graph+phon.cln.tags.ca
#cat all_text.ca-$lang.cln.$lang.graph  >> ../all_text.ca-any.graph+phon.cln.any

cat wp.dev.ca.tags.graph+phon  >> ../wp.dev.ca-any.ca.tags.graph+phon
cat wp.dev.ca.graph+phon  >> ../wp.dev.ca-any.ca.graph+phon
#cat wp.dev.$lang.graph+phon  >> ../wp.dev.ca-any.any.graph+phon


cd ..

done
exit
$spm/spm_train --user_defined_symbols=<sep>,<oc>,<ro>,<it> --input=all_text.ca-any.graph+phon.cln.ca,all_text.ca-any.graph+phon.cln.any --model_prefix=ca-any.graph+phon --vocab_size=32000
$spm/spm_encode --model  ca-any.graph+phon.model < all_text.ca-any.graph+phon.cln.ca > all_text.ca-any.graph+phon.cln.ca.sp
$spm/spm_encode --model  ca-any.graph+phon.model < all_text.ca-any.graph+phon.cln.tags.ca > all_text.ca-any.graph+phon.cln.ca.tags.sp


$spm/spm_encode --model  ca-any.graph+phon.model < all_text.ca-any.graph+phon.cln.any > all_text.ca-any.graph+phon.cln.any.sp

$spm/spm_encode --model  ca-any.graph+phon.model < wp.dev.ca-any.ca.tags.graph+phon > wp.dev.ca-any.graph+phon.ca.tags.sp
$spm/spm_encode --model  ca-any.graph+phon.model < wp.dev.ca-any.any.graph+phon > wp.dev.ca-any.graph+phon.any.sp


