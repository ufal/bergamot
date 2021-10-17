
spm=/lnet/express/work/people/jon/marian/build-CPUONLY/
marian=/lnet/express/work/people/jon/marian/build-CUDA-10.2/
marian=/lnet/express/work/people/jon/marian/build-CUDA-11.1/

tgt_lang=oc
   $marian/marian-decoder -c $1 | $spm/spm_decode --model ../../data/add_resources/any-any.model
