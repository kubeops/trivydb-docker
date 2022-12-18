#!/bin/sh

# set -x
set -eou pipefail

FILESERVER_ADDR=${FILESERVER_ADDR:-https://scanner}

# https://aquasecurity.github.io/trivy/v0.23.0/advanced/air-gap/
# busybox is missing ca-certificates
oras pull ghcr.io/aquasecurity/trivy-db:latest --insecure

# oras pulls in tar format. File will be named `db.tar.gz`
export TOKEN=$(cat /var/run/secrets/kubernetes.io/serviceaccount/token)
curl -fSsL -X POST -F 'file=@db.tar.gz' \
    -H "Authorization: Bearer ${TOKEN}" \
    --cacert /var/serving-cert/ca.crt \
    ${FILESERVER_ADDR}/files/trivy/
