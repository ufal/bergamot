#!/bin/bash

# Clean unnecessary .zip files from dataset folders.
root_folder=../data

cd $root_folder
find . -name '*.zip' -print0 | xargs -0 rm -rf 

