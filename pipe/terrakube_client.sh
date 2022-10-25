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

    RESPONSE=$(curl -s -g -H "Authorization: Bearer $PAT" -X GET "${ENDPOINT}/api/v1/organization/${ORGANIZATION_ID}/workspace?filter[workspace]=name==${WORKSPACE}" | jq -r '.data[0].id')
    
    if [ 0 -eq $? ]; then
        WORKSPACE_ID=$RESPONSE
    else
        WORKSPACE_ID=""
    fi; 

    echo $WORKSPACE_ID
}

function search_template_id(){
    PAT=$1
    ENDPOINT=$2
    ORGANIZATION_ID=$3
    TEMPLATE=$4

    RESPONSE=$(curl -s -g -H "Authorization: Bearer $PAT" -X GET "${ENDPOINT}/api/v1/organization/${ORGANIZATION_ID}/template?filter[template]=name==${TEMPLATE}" | jq -r '.data[0].id')
    
    if [ 0 -eq $? ]; then
        TEMPLATE_ID=$RESPONSE
    else
        TEMPLATE_ID=""
    fi; 

    echo $TEMPLATE_ID
}

function create_workspace(){
    PAT=$1
    ENDPOINT=$2
    ORGANIZATION_ID=$3
    WORKSPACE=$4
    REPOSITORY=$5
    TERRAFORM_VERSION=$6
    SSH_ID=$7
    
    if [[ -v "$SSH_ID" ]]; then
        SSH_DATA=",\"relationships\": {\"ssh\": {\"data\": {\"type\": \"ssh\",\"id\": \"${SSH_ID}\"}}}"
    fi

    WORKSPACE_BODY="{\"data\": {\"type\": \"workspace\",\"attributes\": {\"name\": \"$WORKSPACE\",\"source\": \"$REPOSITORY\",\"branch\": \"main\",\"folder\": \"/$WORKSPACE\",\"terraformVersion\": \"$TERRAFORM_VERSION\"}}$SSH_DATA}}"

    RESPONSE=$(curl -s -g -H "Authorization: Bearer $PAT" -H "Content-Type: application/vnd.api+json" -X POST "${ENDPOINT}/api/v1/organization/${ORGANIZATION_ID}/workspace" -d "${WORKSPACE_BODY}" | jq -r '.data.id')
    
    if [ 0 -eq $? ]; then
        WORKSPACE_ID=$RESPONSE
    else
        WORKSPACE_ID=""
    fi; 

    echo $WORKSPACE_ID
}

function create_job(){
    PAT=$1
    ENDPOINT=$2
    ORGANIZATION_ID=$3
    TEMPLATE_ID=$4
    WORKSPACE_ID=$5

    JOB_BODY="{\"data\": {\"type\": \"job\",\"attributes\": {\"templateReference\": \"$TEMPLATE_ID\" },\"relationships\": {\"workspace\": {\"data\": {\"type\": \"workspace\",\"id\": \"$WORKSPACE_ID\"}}}}}"

    RESPONSE=$(curl -s -g -H "Authorization: Bearer $PAT" -H "Content-Type: application/vnd.api+json" -X POST "${ENDPOINT}/api/v1/organization/${ORGANIZATION_ID}/job" -d "${JOB_BODY}" | jq -r '.data.id')
    
    if [ 0 -eq $? ]; then
        JOB_ID=$RESPONSE
    else
        JOB_ID=""
    fi; 

    echo $JOB_ID
}