
spm=/lnet/express/work/people/jon/marian/build-CPUONLY/
marian=/lnet/express/work/people/jon/marian/build-CUDA-10.2/

tgt_lang=oc
$marian/marian-decoder -c $1 | $spm/spm_decode --model ../../data/lang_pairs/ca-$tgt_lang/ca-$tgt_lang.graph+phon.model
