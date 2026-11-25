#!/usr/bin/env bash

set -euo pipefail

cd "$(dirname "$0")/.."

BRANCH="${1:-feature/ep3-observabilidad}"

echo "=== DESCARGANDO METRICAS ==="

./scripts/sync_ci_metrics.sh "$BRANCH"

echo "=== ACTUALIZANDO KUBERNETES ==="

kubectl create configmap ci-metrics-data \
  -n postulaciones \
  --from-file=ci_metrics.prom=monitoring/metrics/ci_metrics.prom \
  --dry-run=client -o yaml | kubectl apply -f -

echo "=== METRICAS ACTUALIZADAS ==="
