#!/bin/bash

set -o errexit

clusternames=("bach" "handel" "vivaldi")
#clusternames=("bach")

SCRIPT="./cluster-up.sh"

for clustername in "${clusternames[@]}"; do
  echo "Running $SCRIPT for clustername: $clustername"

  $SCRIPT "$clustername"

  if [ $? -ne 0 ]; then
    echo "Error: $SCRIPT failed for clustername $clustername"
    exit 1
  fi
done

echo "All clusternames processed successfully!"
