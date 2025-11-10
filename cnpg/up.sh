#!/bin/bash

namespace=cnpg
kubectl get namespace $namespace -o yaml >/dev/null 2>&1 || kubectl create namespace $namespace

kubens $namespace

kubectl apply --server-side -f https://raw.githubusercontent.com/cloudnative-pg/cloudnative-pg/release-1.27/releases/cnpg-1.27.0.yaml

kubectl apply -f cluster.yaml

kubectl cnpg status cluster-example
