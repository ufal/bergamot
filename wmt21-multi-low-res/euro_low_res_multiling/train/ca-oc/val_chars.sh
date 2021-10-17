#!/bin/bash
python -m pip install sacrebleu
spm=/lnet/express/work/people/jon/marian/build-CPUONLY/
tgt_lang=oc
cat $1 | python join_chars.py  > data/out_postprocessed
cat data/out_postprocessed | python -m sacrebleu ../../data/lang_pairs/ca-$tgt_lang/wp.dev.$tgt_lang.snt
