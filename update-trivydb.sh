#!/bin/sh

# set -x
set -eou pipefail

FILESERVER_ADDR=${FILESERVER_ADDR:-https://scanner}
REGISTRY=${REGISTRY:-ghcr.io}

# https://aquasecurity.github.io/trivy/v0.38/docs/advanced/air-gap/
# busybox is missing ca-certificates
oras pull ${REGISTRY}/aquasecurity/trivy-db:2 --insecure
tar xvf db.tar.gz

# oras pulls in tar format. File will be named `db.tar.gz`
export TOKEN=$(cat /var/run/secrets/kubernetes.io/serviceaccount/token)
curl -fSsL -X POST -F 'file=@db.tar.gz' \
    -H "Authorization: Bearer ${TOKEN}" \
    --cacert /var/serving-cert/ca.crt \
    ${FILESERVER_ADDR}/files/trivy/
curl -fSsL -X POST -F 'file=@metadata.json' \
    -H "Authorization: Bearer ${TOKEN}" \
    --cacert /var/serving-cert/ca.crt \
    ${FILESERVER_ADDR}/files/trivy/

oras pull ${REGISTRY}/aquasecurity/trivy-java-db:1 --insecure
curl -fSsL -X POST -F 'file=@javadb.tar.gz' \
    -H "Authorization: Bearer ${TOKEN}" \
    --cacert /var/serving-cert/ca.crt \
    ${FILESERVER_ADDR}/files/trivy/
