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
TEMPLATE="Terraform-Plan/Apply"
# REPO="https://github.com/AzBuilder/terraform-sample-repository.git"

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

    # SEARCH IF TEMPLATE EXIST
    TEMPLATE_ID=$(search_template_id "$PAT" "$ENDPOINT" "$ORGANIZATION_ID" "$TEMPLATE")
    echo "Template Id: $TEMPLATE_ID"

    # SEARCH IF WORKSPACE EXIST
    WORKSPACE_ID=$(search_workspace_id "$PAT" "$ENDPOINT" "$ORGANIZATION_ID" "$WORKSPACE")
    echo "Workspace Id: $WORKSPACE_ID"

    if [[ -z "$WORKSPACE_ID" ]]; then 
      echo "Creating workspace: $WORKSPACE"; 
      # CREATE WORKSPACE ID
      WORKSPACE_ID=$(create_workspace "$PAT" "$ENDPOINT" "$ORGANIZATION_ID" "$WORKSPACE" "https://github.com/AzBuilder/terraform-sample-repository.git" "$TERRAFORM_VERSION" "$SSH_ID")

      echo "New workspace id: $WORKSPACE_ID"
    fi
 
    # CREATE JOB
    JOB_ID=$(create_job "$PAT" "$ENDPOINT" "$ORGANIZATION_ID" "$TEMPLATE_ID" "$WORKSPACE_ID")
    echo "Job id: $JOB_ID"

    # WAIT FOR JOB TO BE IN STATUS COMPLETED / FAILED
    STATUS="RUNNING"
    while [[ "$STATUS" != @(failed|completed|rejected|cancelled) ]];
    do
      STATUS=$(search_job_status "$PAT" "$ENDPOINT" "$ORGANIZATION_ID" "$JOB_ID")
      sleep 5
    done

    echo "Job is completed with status: $STATUS"
    # GET THE OUPUTS FROM THE STEP LOGS
    echo "Logs:"
    search_job_output "$PAT" "$ENDPOINT" "$ORGANIZATION_ID" "$JOB_ID"

  else 
    echo "$TERRAKUBE_FILE does not exist."
  fi


done
