cat wp.test.ca.xml | python ../ca-oc/testxml2text.py
cat test.snt | bash ../../../add_tags.sh ro | bash trans_params.sh -c model/model.any-any.bigger_smaller_vocab.2.npz.best-bleu-detok.npz.decoder.yml -b 8 -n 1.0 > test_ro.out
cat test_ro.out | python ../ca-oc/text2xml.py cuniPrimary > cuniPrimary.romance.ca2ro.xml
cat test_ro.out | sacrebleu wp.dev.ro.snt > primary_dev_bleu

cat test.snt | bash ../../../add_tags.sh ro | bash trans_params.sh -c model/model.any-any.bigger_smaller_vocab_bt.npz.best-bleu-detok.npz.decoder.yml -b 8 -n 1.0 > test_ro.out
cat test_ro.out | python ../ca-oc/text2xml.py cuniSecondary  > cuniSecondary.romance.ca2ro.xml
cat test_ro.out | sacrebleu wp.dev.ro.snt > secondary_dev_bleu



cat test.snt | bash ../../../add_tags.sh it | bash trans_params.sh -c model/model.any-any.bigger_smaller_vocab.2.npz.best-bleu-detok.npz.decoder.yml -b 8 -n 1.5 > test_it.out
cat test_it.out | python ../ca-oc/text2xml.py cuniPrimary > cuniPrimary.romance.ca2it.xml
cat test_it.out | sacrebleu wp.dev.it.snt > cait_primary_dev_bleu


cat test.snt | bash ../../../add_tags.sh it | bash trans_params.sh -c model/model.any-any.bigger_smaller_vocab_bt.npz.best-bleu-detok.npz.decoder.yml -b 8 -n 1.5 > test_it.out
cat test_it.out | python ../ca-oc/text2xml.py cuniSecondary > cuniSecondary.romance.ca2it.xml
cat test_it.out | sacrebleu wp.dev.it.snt > cait_secondary_dev_bleu


