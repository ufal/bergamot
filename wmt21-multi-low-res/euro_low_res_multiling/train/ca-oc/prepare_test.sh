cat wp.test.ca.xml | python ../ca-oc/testxml2text.py
cat test.snt | bash ../../../add_tags.sh oc | bash trans_any_nbest.sh model/model.ca-oc.wikibt.finetune.continued.any-any.bigger.npz.ens.npz.decoder.yml > mytest_translated_n_best
bash rescore.sh mytest

cat mytest_translated_rescored | python ../ca-oc/text2xml.py cuniPrimary > cuniPrimary.romance.ca2oc.xml
cat mytest_translated_rescored | sacrebleu wp.dev.oc.snt > primary_dev_bleu



