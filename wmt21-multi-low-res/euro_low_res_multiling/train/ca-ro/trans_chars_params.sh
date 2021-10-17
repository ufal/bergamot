export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:/opt/cuda/10.1/lib64:/opt/cuda/10.1/cudnn/7.6/lib64



spm=/lnet/express/work/people/jon/marian/build-CPUONLY/
marian=/lnet/express/work/people/jon/marian/build-CUDA-10.2/
if [ $(hostname) = dll10 ];then
	marian=/lnet/express/work/people/jon/marian/build-CUDA-11.1/
	tmp=.
fi

if [ $(hostname) = dll9 ];then
        marian=/lnet/express/work/people/jon/marian/build-CUDA-11.1/
        tmp=.
fi


tgt_lang=ro
$spm/spm_encode --model ../../data/lang_pairs/ca-$tgt_lang/ca-$tgt_lang.model |python split_to_chars.py  | $marian/marian-decoder   "$@"  | python join_chars.py
