#!/usr/bin/env bash

set -euo pipefail

cd "$(dirname "$0")/.."

NS=postulaciones

echo "=== PREPARANDO NAMESPACE ==="

kubectl apply -f k8s/namespace.yml

echo "=== VERIFICANDO METRICAS CI/CD ==="

if [ ! -s monitoring/metrics/ci_metrics.prom ]; then
    echo "ERROR: No existen metricas CI/CD."
    exit 1
fi

echo "=== CREANDO CONFIGMAPS ==="

kubectl create configmap ci-metrics-data \
  -n "$NS" \
  --from-file=ci_metrics.prom=monitoring/metrics/ci_metrics.prom \
  --dry-run=client -o yaml | kubectl apply -f -

kubectl create configmap grafana-datasource \
  -n "$NS" \
  --from-file=monitoring/grafana/provisioning/datasources/prometheus.yml \
  --dry-run=client -o yaml | kubectl apply -f -

kubectl create configmap grafana-provider \
  -n "$NS" \
  --from-file=monitoring/grafana/provisioning/dashboards/dashboards.yml \
  --dry-run=client -o yaml | kubectl apply -f -

kubectl create configmap grafana-dashboard \
  -n "$NS" \
  --from-file=monitoring/grafana/dashboards/postulaciones-dashboard.json \
  --dry-run=client -o yaml | kubectl apply -f -

echo "=== CONFIGURANDO CREDENCIALES ==="

if ! kubectl get secret grafana-admin -n "$NS" >/dev/null 2>&1; then
    PASSWORD=$(openssl rand -hex 16)

    kubectl create secret generic grafana-admin \
      -n "$NS" \
      --from-literal=username=admin \
      --from-literal=password="$PASSWORD"

    unset PASSWORD
fi

echo "=== DESPLEGANDO MONITOREO ==="

kubectl apply -f k8s/monitoring/

for deployment in ci-metrics-exporter prometheus grafana
do
    kubectl rollout status deployment/"$deployment" \
      -n "$NS" --timeout=180s
done

echo "=== RECURSOS DISPONIBLES ==="

kubectl get pods,svc -n "$NS"

echo "=== MONITOREO DESPLEGADO CORRECTAMENTE ==="
