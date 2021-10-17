cd /lnet/express/work/people/jon/wmt21/euro_low_res_multiling/data/wiki
#wget https://ftp.acc.umu.se/mirror/wikimedia.org/dumps/itwiki/20210620/itwiki-20210620-pages-articles.xml.bz2
#wget https://ftp.acc.umu.se/mirror/wikimedia.org/dumps/rowiki/20210620/rowiki-20210620-pages-articles.xml.bz2
#bzip2 -d itwiki-20210620-pages-articles.xml.bz2
#bzip2 -d rowiki-20210620-pages-articles.xml.bz2

python get_text.py  itwiki-20210620-pages-articles.xml  > itwiki.paragraphs
python get_text.py  rowiki-20210620-pages-articles.xml  > rowiki.paragraphs

cat itwiki.paragraphs | grep -v '=' | grep -v '|'   | grep -v '*' | /lnet/express/work/people/jon/moses-scripts/scripts/ems/support/split-sentences.perl -k -i -n -l it  > itwiki.snt
cat rowiki.paragraphs | grep -v '=' | grep -v '|'   | grep -v '*' | /lnet/express/work/people/jon/moses-scripts/scripts/ems/support/split-sentences.perl -k -i -n -l ro  > rowiki.snt

python remove_short.py < itwiki.snt > itwiki.noshort.snt
python remove_short.py < rowiki.snt > rowiki.noshort.snt


#bash /lnet/express/work/people/jon/wmt21/euro_low_res_multiling/train/ca-ocroit/trans_bt.sh 

tgt_lang=it
moses=/lnet/express/work/people/jon/moses-scripts/scripts/
$moses/training/clean-corpus-n.perl -ratio 2.5 "$tgt_lang"wiki noshort.snt bt_to_ca "$tgt_lang"wiki.bt_to_ca.cln 1 150
$spm/spm_encode --model ../lang_pairs/ca-$tgt_lang/ca-$tgt_lang.model < "$tgt_lang"wiki.bt_to_ca.cln.noshort.snt > "$tgt_lang"wiki.noshort.$tgt_lang.sp
$spm/spm_encode --model ../lang_pairs/ca-$tgt_lang/ca-$tgt_lang.model < "$tgt_lang"wiki.bt_to_ca.cln.bt_to_ca > "$tgt_lang"wiki.noshort.ca.sp
cat ../lang_pairs/ca-$tgt_lang/all_text.ca-$tgt_lang.cln.ca.sp "$tgt_lang"wiki.noshort.ca.sp > ../lang_pairs/ca-$tgt_lang/all_text+wikibt.ca-$tgt_lang.cln.ca.sp
cat ../lang_pairs/ca-$tgt_lang/all_text.ca-$tgt_lang.cln.$tgt_lang.sp "$tgt_lang"wiki.noshort.$tgt_lang.sp > ../lang_pairs/ca-$tgt_lang/all_text+wikibt.ca-$tgt_lang.cln.$tgt_lang.sp

