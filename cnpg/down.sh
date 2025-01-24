#!/bin/bash

namespace=cnpg
kubectl get namespace $namespace -o yaml >/dev/null 2>&1 || kubectl create namespace $namespace

kubens $namespace

kubectl delete -f cluster.yaml
