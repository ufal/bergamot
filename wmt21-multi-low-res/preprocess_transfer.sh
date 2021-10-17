cd euro_low_res_multiling/data/lang_pairs/
set -ex
spm=/lnet/express/work/people/jon/marian/build-CPUONLY/
moses=/lnet/express/work/people/jon/moses-scripts/scripts/


for lang in  "it" "oc" "ro"
do
cd ca-$lang
$spm/spm_encode --model ../../add_resources/any-any.model < all_text.ca-$lang.cln.ca >  all_text.ca-$lang.cln.ca.any_to_any_sp
$spm/spm_encode --model ../../add_resources/any-any.model < all_text.ca-$lang.cln.tags.ca >  all_text.ca-$lang.cln.ca.any_to_any_sp

$spm/spm_encode --model ../../add_resources/any-any.model < all_text.ca-$lang.cln.$lang >  all_text.ca-$lang.cln.$lang.any_to_any_sp


$spm/spm_encode --model ../../add_resources/any-any.model  < wp.dev.ca.tags.snt > wp.dev.ca.tags.any_to_any_sp
$spm/spm_encode --model ../../add_resources/any-any.model  < wp.dev.ca.snt > wp.dev.ca.any_to_any_sp
$spm/spm_encode --model ../../add_resources/any-any.model <  wp.dev.$lang.snt  > wp.dev.ca.$lang.any_to_any_sp
cp wp* ../../../train/transfer/

cd ..

done

