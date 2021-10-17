
spm=/lnet/express/work/people/jon/marian/build-CPUONLY/
marian=/lnet/express/work/people/jon/marian/build-CUDA-10.2/
cat ../ca-oc/wp.dev.ca.snt | bash ../../../add_tags.sh oc | bash trans_params.sh -c $1 -b 8 -n 1.0 --cpu-threads 32 > $2_oc
cat ../ca-oc/wp.dev.ca.snt | bash ../../../add_tags.sh it | bash trans_params.sh -c $1 -b 8 -n 1.0 --cpu-threads 32 > $2_it
cat ../ca-oc/wp.dev.ca.snt | bash ../../../add_tags.sh ro | bash trans_params.sh -c $1 -b 8 -n 1.0 --cpu-threads 32 > $2_ro
cat $2_oc | sacrebleu -m chrf bleu -w 4 ../ca-oc/wp.dev.oc.snt > $2_oc.bleu
cat $2_it | sacrebleu -m chrf bleu -w 4 ../ca-it/wp.dev.it.snt > $2_it.bleu
cat $2_ro | sacrebleu -m chrf bleu -w 4 ../ca-ro/wp.dev.ro.snt > $2_ro.bleu

