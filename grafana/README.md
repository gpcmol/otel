## Grafana
### Grafana
https://grafana.com/docs/grafana/latest/

### k8s
helm repo add grafana https://grafana.github.io/helm-charts
helm repo update

helm --namespace grafana install --values values.yaml grafana grafana/grafana --create-namespace
kubectl get secret --namespace grafana grafana -o jsonpath="{.data.admin-password}" | base64 --decode ; echo

./portforward.sh grafana 3000

browse to localhost:3000, login with admin and password from above

Setup datasources:
loki datasource: http://loki-gateway.loki.svc.cluster.local
tick skip TLS certificate validation

prometheus (mimir) datasource: http://mimir-nginx.mimir.svc.cluster.local/prometheus
tick skip TLS certificate validation

tempo datasource: http://tempo-gateway.tempo.svc.cluster.local
tick skip TLS certificate validation
Additional settings > Service graph > select prometheus

---
Query in tempo (TraceQL): 
{} | count_over_time() by (resource.service.name)
