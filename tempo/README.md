## Tracing
### Tempo
https://grafana.com/oss/tempo/

### Install
helm repo add grafana https://grafana.github.io/helm-charts
helm repo update

helm --namespace tempo install --values values.yaml tempo grafana/tempo-distributed --create-namespace
helm --namespace tempo upgrade --values values.yaml tempo grafana/tempo-distributed
