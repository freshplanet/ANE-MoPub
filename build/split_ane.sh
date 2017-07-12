#!/bin/bash

function split_ane() {

    split_path="../bin/$1-split"
    ane_file="$1.ane"

    rm -r $split_path
    mkdir $split_path
    cd $split_path

    split -b 40m ../$ane_file
}

split_ane $1