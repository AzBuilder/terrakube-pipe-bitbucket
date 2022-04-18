#!/usr/bin/env bash
#
# This pipe is an example to show how easy is to create pipes for Bitbucket Pipelines.
#

source "$(dirname "$0")/common.sh"

generate_job_data()
{
  cat <<EOF
{
  "data": {
    "type": "job",
    "attributes": {
      "templateReference": "$TERRAKUBE_TEMPLATE_ID"
    },
    "relationships":{
        "workspace":{
            "data":{
                "type": "workspace",
                "id": "$TERRAKUBE_WORKSPACE_ID"
            }
        }
    }
  }
}
EOF
}

info "Loading default variables..."

# Required parameters
LOGIN_ENDPOINT=${LOGIN_ENDPOINT:="https://login.microsoftonline.com"}
TERRAKUBE_TENANT_ID=${TERRAKUBE_TENANT_ID:?'TERRAKUBE_TENANT_ID variable missing.'}
TERRAKUBE_APPLICATION_ID=${TERRAKUBE_APPLICATION_ID:?'TERRAKUBE_APPLICATION_ID variable missing.'}
TERRAKUBE_APPLICATION_SECRET=${TERRAKUBE_APPLICATION_SECRET:?'TERRAKUBE_APPLICATION_SECRET variable missing.'}
TERRAKUBE_APPLICATION_SCOPE=${TERRAKUBE_APPLICATION_SCOPE:="api://Terrakube/.default"}
TERRAKUBE_ORGANIZATION=${TERRAKUBE_ORGANIZATION:?'TERRAKUBE_ORGANIZATION variable missing.'}
TERRAKUBE_WORKSPACE=${TERRAKUBE_WORKSPACE:?'TERRAKUBE_WORKSPACE variable missing.'}
TERRAKUBE_TEMPLATE=${TERRAKUBE_TEMPLATE:?'TERRAKUBE_TEMPLATE variable missing.'}
TERRAKUBE_ENDPOINT=${TERRAKUBE_ENDPOINT:?'TERRAKUBE_ENDPOINT variable missing.'}

# Default parameters
DEBUG=${DEBUG:="false"}

info "Showing variables..."
echo "Running the Terrakube pipe using the following variables:"
echo "Microsoft Endpoint: ${LOGIN_ENDPOINT}"
echo "Terrakube Tenant Id: ${TERRAKUBE_TENANT_ID}"
echo "Terrakube Application Id: ${TERRAKUBE_APPLICATION_ID}"
echo "Terrakube Application Scope: ${TERRAKUBE_APPLICATION_SCOPE}"
echo "Terrakube Organization: ${TERRAKUBE_ORGANIZATION}"
echo "Terrakube Workspace: ${TERRAKUBE_WORKSPACE}"
echo "Terrakube Template: ${TERRAKUBE_TEMPLATE}"
echo "Terrakube Endpoint: ${TERRAKUBE_ENDPOINT}"

info "Get Terrakube Access Token:"
TERRAKUBE_TOKEN=$(curl -d "tenantId=${TERRAKUBE_TENANT_ID}&grant_type=client_credentials&client_id=${TERRAKUBE_APPLICATION_ID}&scope=${TERRAKUBE_APPLICATION_SCOPE}&client_secret=${TERRAKUBE_APPLICATION_SECRET}" -H "Content-Type: application/x-www-form-urlencoded" -X POST "https://login.microsoftonline.com/${TERRAKUBE_TENANT_ID}/oauth2/v2.0/token" | jq -r '.access_token')

info "Searching Terrakube Organization:"
TERRAKUBE_ORGANIZATION_ID=$(curl -g -H "Authorization: Bearer $TERRAKUBE_TOKEN" -X GET "${TERRAKUBE_ENDPOINT}/api/v1/organization?filter[organization]=name==${TERRAKUBE_ORGANIZATION}" | jq -r '.data[0].id')

echo "Organization Id: $TERRAKUBE_ORGANIZATION_ID"

info "Searching Terrakube Workspace:"

TERRAKUBE_WORKSPACE_ID=$(curl -g -H "Authorization: Bearer $TERRAKUBE_TOKEN" -X GET "${TERRAKUBE_ENDPOINT}/api/v1/organization/$TERRAKUBE_ORGANIZATION_ID/workspace?filter[workspace]=name==${TERRAKUBE_WORKSPACE}" | jq -r '.data[0].id')

echo $TERRAKUBE_WORKSPACE_ID

TERRAKUBE_TEMPLATE_ID=$(curl -g -H "Authorization: Bearer $TERRAKUBE_TOKEN" -X GET "${TERRAKUBE_ENDPOINT}/api/v1/organization/$TERRAKUBE_ORGANIZATION_ID/template?filter[template]=name==${TERRAKUBE_TEMPLATE}" | jq -r '.data[0].id')

echo "Template Id: $TERRAKUBE_TEMPLATE_ID"

info "Creating Terrakube Job:"

TERRAKUBE_JOB_ID=$(curl -g -H "Authorization: Bearer $TERRAKUBE_TOKEN" -H "Content-Type: application/vnd.api+json" -X POST "${TERRAKUBE_ENDPOINT}/api/v1/organization/$TERRAKUBE_ORGANIZATION_ID/job" --data "$(generate_job_data)" | jq -r '.data.id' )

info "Terrakube Job Created..."

echo "Job Id: $TERRAKUBE_JOB_ID"

run echo $TERRAKUBE_JOB_ID

if [[ "${status}" == "0" ]]; then
  success "Success!"
else
  fail "Error!"
fi
