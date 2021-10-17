#!/bin/bash
cd /lnet/express/work/people/jon/wmt21
cd euro_low_res_multiling/data/add_resources/
set -ex
spm=/lnet/express/work/people/jon/marian/build-CPUONLY/
moses=/lnet/express/work/people/jon/moses-scripts/scripts/

rm -f all_text.any-any.cln.graph+phon.src  all_text.any-any.cln.graph+phon.tgt all_text.any-any.cln.graph+phon.src.sp all_text.any-any.cln.graph+phon.tgt.sp all_text.any-ocroit.cln.graph+phon.src  all_text.any-ocroit.cln.graph+phon.tgt all_text.any-ocroit.cln.graph+phon.src.sp all_text.any-ocroit.cln.graph+phon.tgt.sp
for pair in en-it  en-oc  en-ro es-it es-oc es-ro  fr-it  fr-oc  fr-ro
 

do
echo $pair
cd $pair
src_lang=$(echo $pair| cut -d'-' -f 1)
tgt_lang=$(echo $pair| cut -d'-' -f 2)
if [ "$pair" = "es-oc" ];then
	cat parts3/all_text.$src_lang-$tgt_lang.cln.$src_lang.part{00..23}.phon > all_text.$src_lang-$tgt_lang.cln.$src_lang.phon

else
cat parts3/all_text.$src_lang-$tgt_lang.cln.$src_lang.part{00..31}.phon > all_text.$src_lang-$tgt_lang.cln.$src_lang.phon
fi
paste all_text.$src_lang-$tgt_lang.cln.$src_lang  all_text.$src_lang-$tgt_lang.cln.$src_lang.phon | sed 's/\t/ <sep> /g' > all_text.$src_lang-$tgt_lang.cln.graph+phon.$src_lang

cat all_text.$src_lang-$tgt_lang.cln.graph+phon.$src_lang | bash ../../../../add_tags.sh $tgt_lang > all_text.$src_lang-$tgt_lang.cln.tags.graph+phon.$src_lang
#cat all_text.$src_lang-$tgt_lang.cln.graph+phon.$tgt_lang | bash ../../../../add_tags.sh $src_lang > all_text.$src_lang-$tgt_lang.cln.tags.graph+phon.$tgt_lang
cat all_text.$src_lang-$tgt_lang.cln.tags.graph+phon.$src_lang  >> ../all_text.any-ocroit.cln.graph+phon.src
cat all_text.$src_lang-$tgt_lang.cln.$tgt_lang >> ../all_text.any-ocroit.cln.graph+phon.tgt
#cat all_text.$src_lang-$tgt_lang.cln.graph+phon.$tgt_lang  >> ../all_text.any-any.cln.graph+phon.tgt
#cat all_text.$src_lang-$tgt_lang.cln.$src_lang >> ../all_text.any-any.cln.tgt
cd ..
done


cat ../lang_pairs/all_text.ca-any.graph+phon.cln.tags.ca >> all_text.any-ocroit.cln.graph+phon.src
cat ../lang_pairs/all_text.ca-any.cln.any >> all_text.any-ocroit.cln.graph+phon.tgt

#$spm/spm_train --input_sentence_size  10000000 --user_defined_symbols="<ro>,<it>,<oc>,<sep>" --input=all_text.any-any.cln.graph+phon.src,all_text.any-any.cln.tgt --model_prefix=any-any.graph+phon --vocab_size=32000
#$spm/spm_encode --model  any-any.graph+phon.model < all_text.any-any.cln.graph+phon.src  > all_text.any-any.cln.graph+phon.src.sp
#$spm/spm_encode --model  any-any.graph+phon.model < all_text.any-any.cln.tgt > all_text.any-any.cln.graph+phon.tgt.sp



