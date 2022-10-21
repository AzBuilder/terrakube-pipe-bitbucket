#!/usr/bin/env bash

function search_organization_id(){
    PAT=$1
    ENDPOINT=$2
    ORGANIZATION=$3

    RESPONSE=$(curl -s -g -H "Authorization: Bearer $PAT" -X GET "${ENDPOINT}/api/v1/organization?filter[organization]=name==${ORGANIZATION}" | jq -r '.data[0].id' )
    if [ 0 -eq $? ]; then
        ORGANIZATION_ID=$RESPONSE
    else
        ORGANIZATION_ID=""
    fi; 

    echo $ORGANIZATION_ID
}


function search_workspace_id(){
    PAT=$1
    ENDPOINT=$2
    ORGANIZATION_ID=$3
    WORKSPACE=$4

    TERRAKUBE_WORKSPACE_ID=$(curl -s -g -H "Authorization: Bearer $PAT" -X GET "${ENDPOINT}/api/v1/organization/$ORGANIZATION_ID/workspace?filter[workspace]=name==${WORKSPACE}" | jq -r '.data[0].id')
    
    if [ 0 -eq $? ]; then
        WORKSPACE_ID=$RESPONSE
    else
        WORKSPACE_ID=""
    fi; 

    echo $WORKSPACE_ID
}