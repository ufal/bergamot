#!/bin/bash
cd /lnet/express/work/people/jon/wmt21
cd euro_low_res_multiling/data/add_resources/
set -ex
spm=/lnet/express/work/people/jon/marian/build-CPUONLY/
moses=/lnet/express/work/people/jon/moses-scripts/scripts/

/home/jon/FastText/fastText/fasttext predict /home/jon/FastText/lid.176.bin <(sed 's/(<oc>\|<ca>\|<en>\|<fr>\|<it>\|<es>\|<ro>)//' all_text.any-any.cln.src ) 5  > all_text.any-any.cln.src.lid
/home/jon/FastText/fastText/fasttext predict /home/jon/FastText/lid.176.bin all_text.any-any.cln.tgt 5 > all_text.any-any.cln.tgt.lid

paste all_text.any-any.cln.src all_text.any-any.cln.tgt all_text.any-any.cln.src.lid all_text.any-any.cln.tgt.lid | python ../../../lid_filter.py all_text.any-any.cln
$spm/spm_encode --model  any-any.model < all_text.any-any.cln.langid_clean.src > all_text.any-any.cln.langid_clean.src.sp
$spm/spm_encode --model  any-any.model < all_text.any-any.cln.langid_clean.tgt > all_text.any-any.cln.langid_clean.tgt.sp


