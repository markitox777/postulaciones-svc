
#!/usr/bin/env bash

set -euo pipefail

cd "$(dirname "$0")/.."

REPO="markitox777/postulaciones-svc"
BRANCH="${1:-feature/ep3-observabilidad}"
WORKFLOW="hola-mundo.yml"
METRICS_DIR="monitoring/metrics"

echo "Buscando ultima ejecucion exitosa..."

RUN_ID=$(gh run list \
    --repo "$REPO" \
    --workflow "$WORKFLOW" \
    --branch "$BRANCH" \
    --event push \
    --status success \
    --limit 1 \
    --json databaseId \
    --jq '.[0].databaseId // empty')

if [ -z "$RUN_ID" ]; then
    echo "ERROR: No se encontraron ejecuciones exitosas."
    exit 1
fi

echo "Ejecucion encontrada: $RUN_ID"

TEMP_DIR=$(mktemp -d)
trap 'rm -rf "$TEMP_DIR"' EXIT

echo "Descargando metricas CI/CD..."

gh run download "$RUN_ID" \
    --repo "$REPO" \
    --name metricas-ci-cd \
    --dir "$TEMP_DIR"

METRICS_FILE="$TEMP_DIR/ci_metrics.prom"

if [ ! -s "$METRICS_FILE" ]; then
    echo "ERROR: Archivo de metricas no encontrado o vacio."
    exit 1
fi

grep -q '^ci_test_coverage_percent{' "$METRICS_FILE"
grep -q '^ci_deployment_duration_seconds ' "$METRICS_FILE"
grep -q '^ci_deployment_success ' "$METRICS_FILE"

mkdir -p "$METRICS_DIR"

cp "$METRICS_FILE" "$METRICS_DIR/ci_metrics.tmp"
mv "$METRICS_DIR/ci_metrics.tmp" "$METRICS_DIR/ci_metrics.prom"

echo "Metricas actualizadas correctamente."
echo "Ejecucion: $RUN_ID"
echo ""
cat "$METRICS_DIR/ci_metrics.prom"
