#!/usr/bin/env bash

function get_folders(){
    BRANCH=$1
    DIR=$2
    CURRENT=$(pwd)
    cd $DIR
    FOLDERS=""
    for FOLDER in */ ; do
        CHANGED=$(get_diff $BRANCH $FOLDER)

        if [[ -z "${CHANGED}" ]]; then
            FOLDERS+=$FOLDER 
        fi;

    done
    cd $CURRENT

    echo $FOLDERS
}


function get_diff(){
    BRANCH=$1
    FOLDER=$2
    CHANGED=$(git diff --quiet HEAD $BRANCH -- $FOLDER || echo "true" )

    if [[ "$CHANGED" == "true" ]]; then
        echo $DIR
    else
        echo ""
    fi    
}