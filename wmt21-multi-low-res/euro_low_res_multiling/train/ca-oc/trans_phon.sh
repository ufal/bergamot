
spm=/lnet/express/work/people/jon/marian/build-CPUONLY/
marian=/lnet/express/work/people/jon/marian/build-CUDA-10.2/

tgt_lang=oc
$spm/spm_encode --model ../../data/lang_pairs/ca-$tgt_lang/ca-$tgt_lang.phon.model  | $marian/marian-decoder -c $1 
