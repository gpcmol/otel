## OTLP payloads

### Perform load tests
#### Logging
See log-to-otlp-converter project in k6/logging

#### Tracing
See log-to-otlp-converter project in k6/logging

### Perform otel payload against the collector OTLP endpoints
It can take a while before you can find the data in Grafana.
bash into tempo minio pod and perform:

#### Loki
```
curl -X POST -H 'Content-Type: application/json' \
  http://opentelemetry-collector.telemetry.svc.cluster.local:4318/v1/logs \
  -d '{
    "resourceLogs": [{
      "resource": {
        "attributes": [{
          "key": "service.name",
          "value": {"stringValue": "my-service"}
        }]
      },
      "scopeLogs": [{
        "scope": {
          "name": "my.library",
          "version": "1.0.0",
          "attributes": [{
            "key": "my.scope.attribute",
            "value": {"stringValue": "some scope attribute"}
          }]
        },
        "logRecords": [{
          "timeUnixNano": "'$(date +%s%N)'",
          "observedTimeUnixNano": "'$(( $(date +%s%N) + 1000000 ))'",
          "severityNumber": 13,
          "severityText": "Information",
          "traceId": "5B8EFFF798038103D269B633813FC60C",
          "spanId": "EEE19B7EC3C1B174",
          "body": {
            "stringValue": "Example log record sent at '"$(date -u +%Y-%m-%dT%H:%M:%SZ)"'"
          },
          "attributes": [
            {"key": "string.attribute", "value": {"stringValue": "some string"}},
            {"key": "boolean.attribute", "value": {"boolValue": true}},
            {"key": "int.attribute", "value": {"intValue": "10"}},
            {"key": "double.attribute", "value": {"doubleValue": 637.704}},
            {"key": "array.attribute", "value": {"arrayValue": {"values": [
              {"stringValue": "many"},
              {"stringValue": "values"}
            ]}}},
            {"key": "map.attribute", "value": {"kvlistValue": {"values": [
              {"key": "some.map.key", "value": {"stringValue": "some value"}}
            ]}}}
          ]
        }]
      }]
    }]
  }'
```

#### Tempo
```
curl -X POST -H 'Content-Type: application/json' \
  http://opentelemetry-collector.telemetry.svc.cluster.local:4318/v1/traces \
  -d '{
    "resourceSpans": [{
      "resource": { "attributes": [{ "key": "service.name", "value": {"stringValue": "my-service"} }] },
      "scopeSpans": [{
        "scope": { "name": "my.library", "version": "1.0.0" },
        "spans": [{
          "traceId": "5B8EFFF798038103D269B633813FC700",
          "spanId": "EEE19B7EC3C1B100",
          "name": "I am a span!",
          "startTimeUnixNano": "'$(date +%s%N)'",
          "endTimeUnixNano": "'$(( $(date +%s%N) + 500000000 ))'",
          "kind": 2,
          "attributes": [{
            "key": "my.span.attr",
            "value": {"stringValue": "some value sent at '"$(date -u +%Y-%m-%dT%H:%M:%SZ)"'"}
          }]
        }]
      }]
    }]
  }'
```

#### Mimir
```
curl -X POST -H 'Content-Type: application/json' \
  http://opentelemetry-collector.telemetry.svc.cluster.local:4318/v1/metrics \
  -d '{
    "resourceMetrics": [{
      "resource": {
        "attributes": [{
          "key": "service.name",
          "value": {"stringValue": "my-service"}
        }]
      },
      "scopeMetrics": [{
        "scope": {
          "name": "my.library",
          "version": "1.0.0",
          "attributes": [{
            "key": "my.scope.attribute",
            "value": {"stringValue": "some scope attribute"}
          }]
        },
        "metrics": [
          {
            "name": "my.counter",
            "unit": "1",
            "description": "I am a Counter",
            "sum": {
              "aggregationTemporality": 1,
              "isMonotonic": true,
              "dataPoints": [{
                "asDouble": 5,
                "startTimeUnixNano": "'$(date +%s%N)'",
                "timeUnixNano": "'$(( $(date +%s%N) + 100000000 ))'",
                "attributes": [{
                  "key": "my.counter.attr",
                  "value": {"stringValue": "some value sent at '"$(date -u +%Y-%m-%dT%H:%M:%SZ)"'"}
                }]
              }]
            }
          },
          {
            "name": "my.gauge",
            "unit": "1",
            "description": "I am a Gauge",
            "gauge": {
              "dataPoints": [{
                "asDouble": 10,
                "timeUnixNano": "'$(date +%s%N)'",
                "attributes": [{
                  "key": "my.gauge.attr",
                  "value": {"stringValue": "some value"}
                }]
              }]
            }
          },
          {
            "name": "my.histogram",
            "unit": "1",
            "description": "I am a Histogram",
            "histogram": {
              "aggregationTemporality": 1,
              "dataPoints": [{
                "startTimeUnixNano": "'$(date +%s%N)'",
                "timeUnixNano": "'$(( $(date +%s%N) + 100000000 ))'",
                "count": 2,
                "sum": 2,
                "bucketCounts": [1, 1],
                "explicitBounds": [1],
                "min": 0,
                "max": 2,
                "attributes": [{
                  "key": "my.histogram.attr",
                  "value": {"stringValue": "some value"}
                }]
              }]
            }
          },
          {
            "name": "my.exponential.histogram",
            "unit": "1",
            "description": "I am an Exponential Histogram",
            "exponentialHistogram": {
              "aggregationTemporality": 1,
              "dataPoints": [{
                "startTimeUnixNano": "'$(date +%s%N)'",
                "timeUnixNano": "'$(( $(date +%s%N) + 100000000 ))'",
                "count": 3,
                "sum": 10,
                "scale": 0,
                "zeroCount": 1,
                "positive": {"offset": 1, "bucketCounts": [0, 2]},
                "min": 0,
                "max": 5,
                "zeroThreshold": 0,
                "attributes": [{
                  "key": "my.exponential.histogram.attr",
                  "value": {"stringValue": "some value"}
                }]
              }]
            }
          }
        ]
      }]
    }]
  }'
```
