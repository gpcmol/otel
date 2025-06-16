helm repo add open-telemetry https://open-telemetry.github.io/opentelemetry-helm-charts
helm repo update

kubectl create namespace demo
kubens demo

helm install my-otel-demo open-telemetry/opentelemetry-demo -f values.yaml

kubectl port-forward svc/frontend-proxy 8080:8080

Web store	http://localhost:8080
Grafana	http://localhost:8080/grafana
Feature Flags UI	http://localhost:8080/feature
Load Generator UI	http://localhost:8080/loadgen
Jaeger UI	http://localhost:8080/jaeger/ui
