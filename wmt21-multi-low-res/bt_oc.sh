cd /lnet/express/work/people/jon/wmt21
cd euro_low_res_multiling/data/add_resources/
set -ex
spm=/lnet/express/work/people/jon/marian/build-CPUONLY/
moses=/lnet/express/work/people/jon/moses-scripts/scripts/
rm bt_apertium.oc bt_apertium.oc_to_ca
for pair in  en-oc  es-oc fr-oc
do
echo $pair
cd $pair
src_lang=$(echo $pair| cut -d'-' -f 1)
tgt_lang=$(echo $pair| cut -d'-' -f 2)

##$moses/training/clean-corpus-n.perl -ratio 2.5 all_text.$src_lang-$tgt_lang $src_lang $tgt_lang all_text.$src_lang-$tgt_lang.cln 1 150

apertium -u -f txt oc-ca < all_text.$pair.cln.oc  > all_text.$pair.cln.oc_apertium_bt

cat all_text.$pair.cln.oc >> ../bt_apertium.oc
cat all_text.$pair.cln.oc_apertium_bt >> ../bt_apertium.oc_to_ca
cd ..
done
cp bt_apertium.oc bt_apertium.oc_to_ca ../lang_pairs/ca-oc/
cd ../lang_pairs/ca-oc
$spm/spm_encode --model ca-oc.model < bt_apertium.oc_to_ca > bt_apertium.oc_to_ca.sp 
$spm/spm_encode --model ca-oc.model < bt_apertium.oc > bt_apertium.oc.sp






