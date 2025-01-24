
### Notes!
Mimir helm values has no Minio deployed
So we create minio buckets in loki minio and configure in mimir values.yaml

./portforward.sh loki-minio-0 9000
./portforward.sh loki-minio-0 9001
./create_buckets.sh

These are the minio bucket configuration:
```
admin_client:
  storage:
  type: s3
  s3:
    endpoint: loki-minio-svc.loki.svc.cluster.local:9000
    bucket_name: enterprise-metrics-admin
    access_key_id: enterprise-logs
    secret_access_key: supersecret
    insecure: true

alertmanager_storage:
  backend: s3
  s3:
    endpoint: loki-minio-svc.loki.svc.cluster.local:9000
    bucket_name: mimir-ruler
    access_key_id: enterprise-logs
    secret_access_key: supersecret
    insecure: true

blocks_storage:
  backend: s3
  s3:
    endpoint: loki-minio-svc.loki.svc.cluster.local:9000
    bucket_name: mimir-tsdb
    access_key_id: enterprise-logs
    secret_access_key: supersecret
    insecure: true

ruler_storage:
  backend: s3
  s3:
    endpoint: loki-minio-svc.loki.svc.cluster.local:9000
    bucket_name: mimir-ruler
    access_key_id: enterprise-logs
    secret_access_key: supersecret
    insecure: true
```
