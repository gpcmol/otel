## OpenTelemetry Operator
https://github.com/open-telemetry/opentelemetry-operator

### Install
helm --namespace telemetry install opentelemetry-operator open-telemetry/opentelemetry-operator --create-namespace \
--set "manager.collectorImage.repository=otel/opentelemetry-collector-contrib" \
--set admissionWebhooks.certManager.enabled=false \
--set admissionWebhooks.autoGenerateCert.enabled=true
