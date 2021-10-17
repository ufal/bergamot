export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:/opt/cuda/10.1/lib64:/opt/cuda/10.1/cudnn/7.6/lib64

spm=/lnet/express/work/people/jon/marian/build-CPUONLY/
marian=/lnet/express/work/people/jon/marian/build-CUDA-10.2/

$spm/spm_encode --model ../../data/lang_pairs/ca-any.model  | $marian/marian-decoder -c $1 | $spm/spm_decode --model ../../data/lang_pairs/ca-any.model
