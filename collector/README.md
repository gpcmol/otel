## OpenTelemetry Collector
https://opentelemetry.io/docs/collector/

### Install
helm repo add open-telemetry https://open-telemetry.github.io/opentelemetry-helm-charts
helm repo update

helm --namespace telemetry install --values values.yaml opentelemetry-collector open-telemetry/opentelemetry-collector --create-namespace
helm --namespace telemetry upgrade --values values.yaml opentelemetry-collector open-telemetry/opentelemetry-collector
or
helm --namespace telemetry install opentelemetry-collector open-telemetry/opentelemetry-collector --set image.repository="otel/opentelemetry-collector-contrib" --set mode=deployment --create-namespace

### Configmap
Update the collector configmap data if you don't use the values.yaml

data:
  relay: |
    receivers:
      otlp:
        protocols:
          grpc:
            endpoint: "${env:MY_POD_IP}:4317"
          http:
            endpoint: "${env:MY_POD_IP}:4318"
            include_metadata: true
      prometheus:
        config:
          scrape_configs:
          - job_name: opentelemetry-collector
            scrape_interval: 10s
            static_configs:
            - targets:
              - ${env:MY_POD_IP}:8888
    exporters:
      debug:
        verbosity: detailed
      otlphttp/1:
        endpoint: "http://loki-gateway.loki.svc.cluster.local/otlp"
      otlphttp/2:
        endpoint: "http://tempo-gateway.tempo.svc.cluster.local/otlp"
      otlphttp/3:
        endpoint: "http://mimir-gateway.mimir.svc.cluster.local/otlp"
    processors:
      batch:
        send_batch_size: 1000
        timeout: 10s
      memory_limiter:
        check_interval: 1s
        limit_percentage: 80
        spike_limit_percentage: 20
    service:
      extensions: [health_check]
      pipelines:
        logs/1:
          receivers: [otlp]
          processors: [memory_limiter, batch]
          exporters: [debug, otlphttp/1]
        traces/1:
          receivers: [otlp]
          processors: [memory_limiter, batch]
          exporters: [debug, otlphttp/2]
        metrics/1:
          receivers: [otlp]
          processors: [memory_limiter, batch]
          exporters: [debug, otlphttp/3]
      telemetry:
        metrics:
          readers:
            - pull:
                exporter:
                  prometheus:
                    host: "${env:MY_POD_IP}"
                    port: 8888
    extensions:
      health_check:
        endpoint: "${env:MY_POD_IP}:13133"
