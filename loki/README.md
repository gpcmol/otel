## Logging
### Loki
https://grafana.com/docs/loki/latest

### Helm
helm repo add grafana https://grafana.github.io/helm-charts
helm repo update

helm --namespace loki install --values values.yaml loki grafana/loki --create-namespace
or
helm --namespace loki upgrade --values values.yaml loki grafana/loki

### push logs
to loki:
http://loki-gateway.loki.svc.cluster.local/loki/api/v1/push
```
curl -H "Content-Type: application/json" -XPOST "http://loki-gateway.loki.svc.cluster.local/loki/api/v1/push" --data-raw "{\"streams\": [{\"stream\": {\"job\": \"test\"}, \"values\": [[\"$(date +%s)000000000\", \"fizzbuzz2\"]]}]}"
```

### verify logs
```
curl "http://loki-gateway.loki.svc.cluster.local/loki/api/v1/query_range" --data-urlencode 'query={job="test"}'
```

### data source url (set in Grafana)
http://loki-gateway.loki.svc.cluster.local/
