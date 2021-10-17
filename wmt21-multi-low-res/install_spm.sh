#!/bin/bash

cd $1
git clone https://github.com/google/sentencepiece.git 
cd sentencepiece
mkdir -p build
cd build
cmake ..
make -j $(nproc)
sudo make install
sudo ldconfig -v
