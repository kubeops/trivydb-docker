#!/bin/sh

# set -x
set -eou pipefail

FILESERVER_ADDR=${FILESERVER_ADDR:-https://scanner}
TOKEN=$(cat /var/run/secrets/kubernetes.io/serviceaccount/token)

mkdir -p trivy/db
cd trivy/db
curl -fSsLO -k \
    -H "Authorization: Bearer ${TOKEN}" \
    ${FILESERVER_ADDR}/files/trivy/db.tar.gz
tar xvf db.tar.gz
rm db.tar.gz

cd ../..

mkdir -p trivy/java-db
cd trivy/java-db
curl -fSsLO -k \
    -H "Authorization: Bearer ${TOKEN}" \
    ${FILESERVER_ADDR}/files/trivy/javadb.tar.gz
tar xvf javadb.tar.gz
rm javadb.tar.gz

/root/.cache/tv version
/bin/oras version
