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
