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

#### Setup datasources:
### Loki
- loki datasource: http://loki-gateway.loki.svc.cluster.local
- tick skip TLS certificate validation
- Derived fields > Internal link > Tempo
- Name: trace_id, Type: Label, Label: trace_id
- Query: ${__value.raw}, URL label: Trace: ${__value.raw}

### Prometheus
- prometheus (mimir) datasource: http://mimir-nginx.mimir.svc.cluster.local/prometheus
- tick skip TLS certificate validation

### Tempo
- tempo datasource: http://tempo-gateway.tempo.svc.cluster.local
- tick skip TLS certificate validation
- Additional settings > Service graph > select prometheus
- Trace to Logs > Data source > Loki
- Tags: service.name as service_name
- Use custom query: enabled
- Query: {${__tags}} | trace_id = "${__trace.traceId}"

---
Query in tempo (TraceQL): 
{} | count_over_time() by (resource.service.name)
