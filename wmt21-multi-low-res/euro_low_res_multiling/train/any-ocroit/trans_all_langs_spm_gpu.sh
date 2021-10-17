export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:/opt/cuda/10.1/lib64:/opt/cuda/10.1/cudnn/7.6/lib64
spm=/lnet/express/work/people/jon/marian/build-CPUONLY/
marian=/lnet/express/work/people/jon/marian/build-CUDA-10.2/
cat ../ca-oc/wp.dev.ca.snt | bash ../../../add_tags.sh oc |  $marian/marian-decoder -c $1 -d 0  -n 1.0 -b 8 > $2_oc
cat ../ca-oc/wp.dev.ca.snt | bash ../../../add_tags.sh it |  $marian/marian-decoder -c  $1 -d 0 -n 1.0 -b 8 > $2_it
cat ../ca-oc/wp.dev.ca.snt | bash ../../../add_tags.sh ro |  $marian/marian-decoder -c  $1 -d 0  -n 1.0 -b 8 > $2_ro
cat $2_oc | sacrebleu -m chrf bleu -w 4 ../ca-oc/wp.dev.oc.snt > $2_oc.bleu
cat $2_it | sacrebleu -m chrf bleu -w 4 ../ca-it/wp.dev.it.snt > $2_it.bleu
cat $2_ro | sacrebleu -m chrf bleu -w 4 ../ca-ro/wp.dev.ro.snt > $2_ro.bleu



cat ../any-any/wp.test.ca.snt | bash ../../../add_tags.sh oc |  $marian/marian-decoder -c $1 -d 0  -n 1.0 -b 8 > $2_oc
cat ../any-any/wp.test.ca.snt | bash ../../../add_tags.sh it |  $marian/marian-decoder -c  $1 -d 0  -n 1.0 -b 8 > $2_it
cat ../any-any/wp.test.ca.snt | bash ../../../add_tags.sh ro |  $marian/marian-decoder -c  $1 -d 0  -n 1.0 -b 8 > $2_ro
cat $2_oc | sacrebleu -m chrf bleu -w 4 ../any-any/wp.test.oc.snt > $2_test_oc.bleu
cat $2_it | sacrebleu -m chrf bleu -w 4 ../any-any/wp.test.it.snt > $2_test_it.bleu
cat $2_ro | sacrebleu -m chrf bleu -w 4 ../any-any/wp.test.ro.snt > $2_test_ro.bleu


