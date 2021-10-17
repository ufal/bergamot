spm=/lnet/express/work/people/jon/marian/build-CPUONLY/
$spm/spm_encode --model /lnet/express/work/people/jon/wmt21/euro_low_res_multiling/data/add_resources/any-any.model < ../../data/add_resources/ca-en/all_text.ca-en.ca > corp/all_text.ca-en.ca.sp
$spm/spm_encode --model /lnet/express/work/people/jon/wmt21/euro_low_res_multiling/data/add_resources/any-any.model < ../../data/add_resources/ca-en/all_text.ca-en.en > corp/all_text.ca-en.en.sp
$spm/spm_encode --model /lnet/express/work/people/jon/wmt21/euro_low_res_multiling/data/add_resources/any-any.model <  corp/GlobalVoices.dev.ca-en.ca.snt > corp/GlobalVoices.dev.ca-en.ca.sp
$spm/spm_encode --model /lnet/express/work/people/jon/wmt21/euro_low_res_multiling/data/add_resources/any-any.model <  corp/GlobalVoices.dev.ca-en.en.snt > corp/GlobalVoices.dev.ca-en.en.sp


