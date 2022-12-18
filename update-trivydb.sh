#!/bin/sh

set -x

SCANNER_NAMESPACE=kubeops
SCANNER_POD_ADDR=scanner-0:8443

# https://aquasecurity.github.io/trivy/v0.23.0/advanced/air-gap/
# busybox is missing ca-certificates
oras pull ghcr.io/aquasecurity/trivy-db:latest --insecure

# oras pulls in tar format. File will be named `db.tar.gz`

kubectl curl -k -X POST -F file=@db.tar.gz https://${SCANNER_POD_ADDR}/files/trivy/ -n ${SCANNER_NAMESPACE}
