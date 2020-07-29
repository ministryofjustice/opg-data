#!/usr/bin/env bash
set -e
PACT_BROKER_ADMIN="admin"
PACT_BASE_URL="https://pact-broker.api.opg.service.justice.gov.uk"
PROVIDER="template"
CONSUMER="template2"

WORKSPACE=${WORKSPACE:-$CIRCLE_BRANCH}
WORKSPACE=${WORKSPACE//[^[:alnum:]]/}
WORKSPACE=${WORKSPACE,,}
WORKSPACE=${WORKSPACE:0:14}
PROVIDER_VER="v1"
GIT_COMMIT=${CIRCLE_SHA1:0:7}

echo "export GIT_COMMIT_PROVIDER=${GIT_COMMIT}"
echo "export TF_WORKSPACE=${WORKSPACE}"
echo "export API_VERSION=${PROVIDER_VER}"
echo "export PACT_PROVIDER=${PROVIDER}"
echo "export PACT_CONSUMER=${CONSUMER}"
echo "export PACT_BROKER_BASE_URL=${PACT_BASE_URL}"
echo "export PACT_BROKER_HTTP_AUTH_USER=${PACT_BROKER_ADMIN}"