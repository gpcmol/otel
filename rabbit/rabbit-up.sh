#!/bin/bash

kubectl get ns rabbitmq >/dev/null 2>&1 || kubectl create ns rabbitmq

kubens rabbitmq

kubectl apply -f https://github.com/rabbitmq/cluster-operator/releases/latest/download/cluster-operator.yml

kubectl apply -f deployment.yaml
