#!/bin/sh

# set -x
set -eou pipefail

FILESERVER_ADDR=${FILESERVER_ADDR:-https://scanner}

mkdir -p trivy/db
cd trivy/db

export TOKEN=$(cat /var/run/secrets/kubernetes.io/serviceaccount/token)
curl -fSsLO -k \
    -H "Authorization: Bearer ${TOKEN}" \
    ${FILESERVER_ADDR}/files/trivy/db.tar.gz

tar xvf db.tar.gz
rm db.tar.gz

/root/.cache/tv version
/bin/oras version
