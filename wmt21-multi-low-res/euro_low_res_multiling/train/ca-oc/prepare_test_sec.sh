#cat wp.test.ca.xml | python ../ca-oc/testxml2text.py
#cat test.snt | bash ../../../add_tags.sh oc | bash trans_any_nbest.sh model/model.ca-oc.wikibt.finetune.continued.any-any.bigger.npz.ens.npz.decoder.yml > mytest_translated_n_best
#bash rescore.sh mytest

cat test.best-oc.b20.n1.5.nbest.decoded.out_translated_rescored | python ../ca-oc/text2xml.py cuniSecondary > cuniSecondary.romance.ca2oc.xml
#cat test_translated_rescored | sacrebleu wp.dev.oc.snt > primary_dev_bleu



