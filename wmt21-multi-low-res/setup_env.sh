#!/bin/bash

# Setup python environment for the experiments.

root_folder=`pwd`

env_folder=$root_folder/python_envs

if [[ ! -d $env_folder ]]; then
    mkdir $env_folder
fi

cd $env_folder

if [[ ! -d wmt21 ]]; then
    python3 -m venv wmt21

    . wmt21/bin/activate

    pip install -r ../requirements.txt
fi
