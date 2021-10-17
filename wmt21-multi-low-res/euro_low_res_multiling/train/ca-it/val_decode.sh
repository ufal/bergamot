#!/bin/bash
python -m pip install sacrebleu
spm=/lnet/express/work/people/jon/marian/build-CPUONLY/
tgt_lang=it
cat $1 | $spm/spm_decode --model ../../data/lang_pairs/ca-$tgt_lang/ca-$tgt_lang.model  > data/out_postprocessed
cat data/out_postprocessed | python -m sacrebleu ../../data/lang_pairs/ca-$tgt_lang/wp.dev.$tgt_lang.snt
