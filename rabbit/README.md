https://www.rabbitmq.com/kubernetes/operator/install-operator
https://knowledge.broadcom.com/external/article/293208/how-to-enable-plugins-on-rabbitmq-in-kub.html

helm repo add bitnami https://charts.bitnami.com/bitnami
helm repo update
helm install rabbit bitnami/rabbitmq-cluster-operator --namespace rabbitmq --create-namespace

kubectl apply -f deployment.yaml
kubectl delete -f deployment.yaml

---
Check if jms is enabled:
* bash into rabbitmq pod
* rabbitmq-plugins list
* [E*] rabbitmq_jms_topic_exchange
