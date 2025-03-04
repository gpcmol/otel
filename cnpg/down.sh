#!/bin/bash

namespace=cnpg

kubens $namespace

kubectl delete -f cluster.yaml
