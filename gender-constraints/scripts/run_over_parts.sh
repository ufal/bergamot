#!/bin/bash


for i in {12..13};
do
	sh run_fast_align.sh ../data/gender/wmt15/fr-en.cln.align_part$i ../data/gender/wmt15/fr-en.cln.aligned_part$i
done
