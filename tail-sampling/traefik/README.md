https://github.com/traefik/traefik-helm-chart

# Install traefik
helm repo add traefik https://traefik.github.io/helm-charts
helm repo update

# Create self signed certificate
openssl req -x509 -nodes -days 365 -newkey rsa:2048 \
-keyout tls.key -out tls.crt \
-subj "/CN=example.com/O=example.com"

kubectl create namespace traefik

kubens traefik

kubectl create secret tls traefik-tls-secret \
--cert=tls.crt \
--key=tls.key \
-n traefik

# update values
helm upgrade traefik traefik/traefik -f values.yaml
