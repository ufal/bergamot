#!/bin/bash

base_dir=$1
path=$2
src=$3
tgt=$4

#moses=/lnet/express/work/people/jon/moses-scripts/scripts/
moses=$base_dir/clean-corpus-n.perl

$moses -ratio 2.5 $path/$src-$tgt $src $tgt $path/$src-$tgt.cln 1 150

