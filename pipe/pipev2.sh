#!/usr/bin/env bash
#
# This pipe is an example to show how easy is to create pipes for Bitbucket Pipelines.
#

#source "$(dirname "$0")/common.sh"
source folder_changes.sh
source terrakube_client.sh

ORGANIZATION="simple"
ENDPOINT=""
PAT=""
REPO="/c/git/terraform-sample-repository"
#REPO=$BITBUCKET_CLONE_DIR

# SEARCH ALL FOLDERS WITH CHANGE
FOLDERS=$(get_folders "main" "$REPO" | sed 's+/++g')

echo "List folder with changes: $FOLDERS"

# LOOP IN EVERY FOLDER WITH CHANGES
for WORKSPACE in $FOLDERS; do
  echo $WORKSPACE
  # VALIDATE IF FOLDER WITH CHANGE HAS A terrakube.json FILE
  echo "Searching $REPO/$WORKSPACE/terrakube.json"
  TERRAKUBE_FILE="$REPO/$WORKSPACE/terrakube.json"
  if [ -f "$TERRAKUBE_FILE" ]; then
    echo "File exists."

    # READ TERRAFORM VERSION DATA FROM terrakube.json
    TERRAFORM_VERSION=$(cat $TERRAKUBE_FILE | jq -r ".terraform" )

    echo "Terraform version: $TERRAFORM_VERSION"

    # GET ORGANIZATION PARAMETER FROM ENVIRONMENT VARIABLES
    ORGANIZATION_ID=$(search_organization_id "$PAT" "$ENDPOINT" "$ORGANIZATION")
    echo "Organization Id: $ORGANIZATION_ID"

    # SEARCH IF WORKSPACE EXIST
    WORKSPACE_ID=$(search_workspace_id "$PAT" "$ENDPOINT" "$ORGANIZATION_ID" "$WORKSPACE_ID")
    echo "Workspace Id: $WORKSPACE_ID"

    if [[ ! -v "$WORKSPACE_ID" ]]; then 
      echo "Creating workspace: $WORKSPACE"; 
    fi
    # CREATE WORKSPACE ID

    # SEARCH IF TEMPLATE EXIST
 
    # CREATE JOB

    # WAIT FOR JOB TO BE IN STATUS COMPLETED / FAILED

    # GET THE OUPUTS FROM THE STEP LOGS

    # SEND LOGS TO THE CONTAINER OUTPUT
  else 
    echo "$TERRAKUBE_FILE does not exist."
  fi


done
