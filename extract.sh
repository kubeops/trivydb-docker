#!/bin/sh

set -x

ENV SCANNER_NAMESPACE=kubeops
ENV SCANNER_POD_ADDR=scanner-0:8443

mkdir -p trivy/db
cd trivy/db

kubectl curl -k https://${SCANNER_POD_ADDR}/files/trivy/db.tar.gz -n ${SCANNER_NAMESPACE} >db.tar.gz
tar xvf db.tar.gz
rm db.tar.gz

/root/.cache/tv version
/bin/oras version
