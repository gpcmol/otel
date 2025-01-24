#!/bin/bash

SERVICE_NAME="$1"
PORT="$2"
POD_NAME=$(kubectl get pods -o=name | grep $SERVICE_NAME | head -n 1)
echo $POD_NAME
kubectl port-forward --address 0.0.0.0 $POD_NAME $PORT:$PORT
