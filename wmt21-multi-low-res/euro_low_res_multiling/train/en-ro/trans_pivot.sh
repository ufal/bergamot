
spm=/lnet/express/work/people/jon/marian/build-CPUONLY/
marian=/lnet/express/work/people/jon/marian/build-CUDA-10.2/
marian=/lnet/express/work/people/jon/marian/build-CUDA-11.1/
tgt_lang=ro
$spm/spm_encode --model ../../data/add_resources/ca-en/ca-en.model | $marian/marian-decoder -c ../ca-en/model/model.ca-en.2.npz.best-bleu-detok.npz.decoder.yml --relative-paths  | $spm/spm_decode --model ../../data/add_resources/ca-en/ca-en.model  |  $spm/spm_encode --model ../../data/add_resources/en-$tgt_lang/en-$tgt_lang.model  | $marian/marian-decoder -c $1 | $spm/spm_decode --model ../../data/add_resources/en-$tgt_lang/en-$tgt_lang.model | /lnet/express/work/people/jon/moses-scripts/scripts/tokenizer/detokenizer.perl
