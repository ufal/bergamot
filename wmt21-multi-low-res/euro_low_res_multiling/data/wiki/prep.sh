#python get_text.py  > ocwiki.paragraphs
#cat ocwiki.paragraphs | grep -v '=' | grep -v '|'   | grep -v '*' | /lnet/express/work/people/jon/moses-scripts/scripts/ems/support/split-sentences.perl -k -i -n -l fr  > ocwiki.snt
#python remove_short.py < ocwiki.snt > ocwiki.noshort.snt
#apertium -u -f txt oc-ca < ocwiki.noshort.snt  > ocwiki.noshort.ca
spm=/lnet/express/work/people/jon/marian/build-CPUONLY/
tgt_lang=oc
$spm/spm_encode --model ../lang_pairs/ca-$tgt_lang/ca-$tgt_lang.model < ocwiki.noshort.ca > ocwiki.noshort.ca.sp
$spm/spm_encode --model ../lang_pairs/ca-$tgt_lang/ca-$tgt_lang.model < ocwiki.noshort.snt > ocwiki.noshort.oc.sp




