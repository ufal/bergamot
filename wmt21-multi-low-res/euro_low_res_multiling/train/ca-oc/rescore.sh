#cat wp.dev.ca.tags.snt | bash trans_any_nbest.sh model/model.ca-oc.wikibt.finetune.continued.any-any.bigger.npz.best-bleu-detok.npz.decoder.yml  >  $1_translated_n_best
perl -ne 'print $_ x 20' test.snt > testx20.snt
sed 's/|||/\t/g' $1_translated_n_best | cut -f2 > $1_translated_sentences
bash score_chars.sh testx20.snt $1_translated_sentences  "model/model.ca-oc.chars.wikibt.from_scratch.big.balanced.npz.best-bleu-detok.npz" > $1_translated_scores
paste $1_translated_n_best $1_translated_scores | python rescore.py > $1_translated_rescored
paste $1_translated_n_best $1_translated_scores | python rescore_fake.py > $1_translated_origscored

cat $1_translated_rescored | sacrebleu -m chrf bleu -w 4 wp.dev.oc.snt
cat $1_translated_origscored | sacrebleu -m chrf bleu -w 4 wp.dev.oc.snt
