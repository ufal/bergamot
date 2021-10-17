export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:/opt/cuda/10.1/lib64:/opt/cuda/10.1/cudnn/7.6/lib64

spm=/lnet/express/work/people/jon/marian/build-CPUONLY/
marian=/lnet/express/work/people/jon/marian/build-CUDA-10.2/

bash ../../../add_tags.sh es | $spm/spm_encode --model ../../data/add_resources/any-any.model  | $marian/marian-decoder -c model/model.any-any.bigger_smaller_vocab.npz.best-bleu-detok.npz.decoder.yml  -b 8 -n 1.5 | $spm/spm_decode --model ../../data/add_resources/any-any.model
