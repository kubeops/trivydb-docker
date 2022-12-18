#!/bin/sh

set -x

# https://docs.nats.io/nats-concepts/jetstream/key-value-store/kv_walkthrough

find .
cat report.json

nats -s nats:4222 kv add scanner-reports || true
cat report.json | nats -s nats:4222 kv put scanner-reports xyz

#cat report.json | nats -s nats://this-is-nats.appscode.ninja:4222 kv put scanner-reports xyz
