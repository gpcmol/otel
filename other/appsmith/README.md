
helm repo add appsmith https://helm.appsmith.com

helm repo update

helm show values appsmith/appsmith  > values.yaml

kubectl apply -f k3s-pvs-change.yaml

change global.storageClass to standard

helm install appsmith appsmith/appsmith -n appsmith --create-namespace -f values.yaml
