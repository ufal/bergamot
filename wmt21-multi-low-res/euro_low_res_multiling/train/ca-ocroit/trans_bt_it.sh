cd /lnet/express/work/people/jon/wmt21/euro_low_res_multiling/train/ca-ocroit/
export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:/opt/cuda/10.1/lib64:/opt/cuda/10.1/cudnn/7.6/lib64


spm=/lnet/express/work/people/jon/marian/build-CPUONLY/
marian=/lnet/express/work/people/jon/marian/build-CUDA-10.2/

cat /lnet/express/work/people/jon/wmt21/euro_low_res_multiling/data/wiki/itwiki.noshort.snt | $spm/spm_encode --model ../../data/lang_pairs/ca-any.model  | $marian/marian-decoder -c model/model.any-ca.npz.best-bleu-detok.npz.decoder.yml | $spm/spm_decode --model ../../data/lang_pairs/ca-any.model > /lnet/express/work/people/jon/wmt21/euro_low_res_multiling/data/wiki/itwiki.bt_to_ca
