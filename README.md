## OpenTelemetry stack
This is an open telemetry stack to play with on you local box. <br/>
Note that none of the parts are setup in a secure way. This is only for fiddling with the open telemetry stack. <br/>
Take care of security in case of deploying it to production.

### Order of installation
- kind
- loki
- mimir
- tempo
- grafana
- collector
- telemetry-operator
- instrumentation

### Requirements
- kind (https://kind.sigs.k8s.io/)
- helm (https://helm.sh/docs/intro/install/)
- kubectl (https://kubernetes.io/docs/reference/kubectl/)
- kubens, kubectx (https://github.com/ahmetb/kubectx)
- docker (https://docs.docker.com/)

### Setup
Use up.sh to deploy the kind cluster with the open telemetry stack <br/>
Use down.sh to delete the kind cluster

### Note
The default name 'kind' is used for the kind cluster

### Annotations
These are annotations to add to deployment.yaml
```yaml
spec:
  template:
    metadata:
      annotations:
        instrumentation.opentelemetry.io/inject-java: "true"
```

### commands
kubectl port-forward service/rabbitmq 5672:5672 -n rabbitmq
kubectl get secret rabbitmq-default-user -n rabbitmq -o jsonpath='{.data.connection_string}' | base64 --decode

kubectl port-forward service/grafana 80:3000 -n grafana
kubectl get secret grafana -n grafana -o jsonpath='{.data.admin-password}' | base64 --decode

kubectl port-forward service/car-app-service 8080:8080 -n default
