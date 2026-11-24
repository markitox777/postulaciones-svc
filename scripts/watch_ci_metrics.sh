
#!/usr/bin/env bash

set -euo pipefail

cd "$(dirname "$0")/.."

BRANCH="${1:-feature/ep3-observabilidad}"
INTERVAL=60

echo "Iniciando sincronizacion automatica CI/CD"
echo "Rama: $BRANCH"
echo "Intervalo: $INTERVAL segundos"

while true; do
    echo ""
    echo "======================================"
    echo "Fecha: $(date)"
    echo "======================================"

    if ./scripts/sync_ci_metrics.sh "$BRANCH"; then
        echo "Sincronizacion exitosa."
    else
        echo "ERROR: No se pudieron actualizar las metricas."
        echo "Se conservaran las metricas anteriores."
    fi

    echo "Proxima sincronizacion en $INTERVAL segundos..."
    sleep "$INTERVAL"
done
