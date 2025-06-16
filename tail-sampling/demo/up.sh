#!/bin/bash
set -o errexit

helm install my-otel-demo open-telemetry/opentelemetry-demo -f values.yaml
