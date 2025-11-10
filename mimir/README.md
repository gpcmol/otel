## Mimir
https://github.com/grafana/mimir/blob/main/operations/helm/charts/mimir-distributed/values.yaml

### Install
helm repo add grafana https://grafana.github.io/helm-charts
helm repo update

helm --namespace mimir install --values values.yaml mimir grafana/mimir-distributed --create-namespace
or
helm --namespace mimir upgrade --values values.yaml mimir grafana/mimir-distributed

### Exemplars url
This is the remote write endpoint to store the exemplars from Tempo.
This is used for showing the service graph in Grafana and eventually for RED dashboarding.
http://mimir-gateway.mimir.svc.cluster.local/api/v1/push
