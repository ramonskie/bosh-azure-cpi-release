#!/usr/bin/env bash

set -e

: ${AZURE_ENVIRONMENT:?}
: ${AZURE_CLIENT_ID:?}
: ${AZURE_CLIENT_SECRET:?}
: ${AZURE_TENANT_ID:?}
: ${AZURE_APPLICATION_SECURITY_GROUP_NAME:?}

: ${METADATA_FILE:=environment/metadata}

metadata=$(cat ${METADATA_FILE})

az cloud set --name ${AZURE_ENVIRONMENT}
az login --service-principal -u ${AZURE_CLIENT_ID} -p ${AZURE_CLIENT_SECRET} --tenant ${AZURE_TENANT_ID}

default_resource_group_name=$(echo ${metadata} | jq -e --raw-output ".default_resource_group_name")
az network asg delete --resource-group ${default_resource_group_name} --name ${AZURE_APPLICATION_SECURITY_GROUP_NAME}
