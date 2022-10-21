#!/usr/bin/env bash

function get_folders(){
    BRANCH=$1
    DIR=$2
    CURRENT=$(pwd)
    cd $DIR
    FOLDERS=""
    for FOLDER in */ ; do
        CHANGED=$(get_diff_branch $BRANCH $FOLDER)

        if [[ ! -z "$CHANGED" ]]; then 
            FOLDERS+=" $FOLDER"
        fi;

    done
    cd $CURRENT

    echo $FOLDERS
}


function get_diff_branch(){
    BRANCH=$1
    FOLDER=$2
    echo $(git diff --quiet HEAD $BRANCH -- $FOLDER || echo "$FOLDER" )  
}

function get_diff_commit(){
    FOLDER=$1
    echo $(git diff --quiet HEAD "$(git describe --tags --abbrev=0 HEAD)" -- foo || echo changed )  
}