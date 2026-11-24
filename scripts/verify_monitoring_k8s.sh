#!/usr/bin/env bash

set -euo pipefail

cd "$(dirname "$0")/.."

mkdir -p evidencias

kubectl port-forward -n postulaciones \
  svc/prometheus 19090:9090 \
  > /tmp/prometheus-verification.log 2>&1 &

PROM_PID=$!

kubectl port-forward -n postulaciones \
  svc/grafana 13000:3000 \
  > /tmp/grafana-verification.log 2>&1 &

GRAFANA_PID=$!

trap 'kill "$PROM_PID" "$GRAFANA_PID" 2>/dev/null || true' EXIT

python3 - <<'PY'
import json
import time
from pathlib import Path
from urllib.request import urlopen
from urllib.parse import urlencode

output = Path("evidencias")

def query(expression):
    url = "http://localhost:19090/api/v1/query?"
    url += urlencode({"query": expression})

    with urlopen(url, timeout=5) as response:
        data = json.load(response)

    if data["status"] != "success":
        raise RuntimeError("Consulta Prometheus fallida")

    return data

for attempt in range(30):
    try:
        up = query("up")
        targets = {
            item["metric"]["job"]: float(item["value"][1])
            for item in up["data"]["result"]
        }

        expected = {
            "prometheus",
            "postulaciones-svc",
            "ci-cd-metrics"
        }

        assert all(targets.get(job) == 1 for job in expected)

        coverage = query(
            'ci_test_coverage_percent{type="line"}'
        )

        assert float(
            coverage["data"]["result"][0]["value"][1]
        ) == 100

        duration = query("ci_deployment_duration_seconds")

        assert float(
            duration["data"]["result"][0]["value"][1]
        ) > 0

        errors = query("node_textfile_scrape_error")

        assert float(
            errors["data"]["result"][0]["value"][1]
        ) == 0

        with urlopen(
            "http://localhost:13000/api/health",
            timeout=5
        ) as response:
            grafana = json.load(response)

        assert grafana["database"] == "ok"

        results = {
            "prometheus-up.json": up,
            "cobertura.json": coverage,
            "duracion-despliegue.json": duration,
            "exportador-errores.json": errors,
            "grafana-health.json": grafana
        }

        for filename, data in results.items():
            (output / filename).write_text(
                json.dumps(data, indent=2) + "\n"
            )

        print("Prometheus: 3 targets disponibles")
        print("Cobertura de lineas: 100%")
        print("Exportador: sin errores")
        print("Grafana: operativo")
        print("MONITOREO VERIFICADO CORRECTAMENTE")
        break

    except Exception as error:
        print(f"Intento {attempt + 1}/30: {error}")
        time.sleep(5)

else:
    raise SystemExit("ERROR: Monitoreo no disponible")
PY
