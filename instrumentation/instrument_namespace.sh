#!/bin/bash

set -e

if [ "$#" -ne 1 ]; then
  echo "Usage: instrument_namespace.sh <namespace>"
  exit 1
fi

kubens "$1"
kubectl apply -f instrumentation.yaml
