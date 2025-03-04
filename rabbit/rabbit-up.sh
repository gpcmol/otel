#!/bin/bash

helm repo add bitnami https://charts.bitnami.com/bitnami
helm repo update
helm install rabbit bitnami/rabbitmq-cluster-operator --namespace rabbitmq --create-namespace

kubectl apply -f deployment.yaml
