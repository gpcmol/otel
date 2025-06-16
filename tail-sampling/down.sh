#!/bin/bash

if [ -z "$1" ]; then
    echo "cluster name is required"
    exit 1
fi

CLUSTERNAME="$1"

kind delete cluster --name "$CLUSTERNAME"
