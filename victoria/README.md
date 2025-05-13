## Victoria
https://github.com/VictoriaMetrics/helm-charts/blob/master/charts/victoria-metrics-distributed/values.yaml

### Install
helm repo add vm https://victoriametrics.github.io/helm-charts/
helm repo update

helm --namespace victoria install --values values.yaml vmc vm/victoria-metrics-cluster --create-namespace

### Exemplars url
This is the remote write endpoint to store the exemplars from Tempo.
This is used for showing the service graph in Grafana and eventually for RED dashboarding.
http://vmc-victoria-metrics-cluster-vminsert.victoria.svc.cluster.local:8480/insert/0/prometheus/api/v1/write
