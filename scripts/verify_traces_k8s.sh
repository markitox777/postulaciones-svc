#!/usr/bin/env bash
set -euo pipefail

cd "$(dirname "$0")/.."
mkdir -p evidencias

kubectl port-forward -n postulaciones \
  svc/tempo 13200:3200 \
  > /tmp/tempo-verification.log 2>&1 &
TEMPO_PID=$!

kubectl port-forward -n postulaciones \
  svc/postulaciones-svc 18080:8080 \
  > /tmp/app-tracing.log 2>&1 &
APP_PID=$!

trap 'kill "$TEMPO_PID" "$APP_PID" 2>/dev/null || true' EXIT

python3 - <<'PY'
import json
import time
from pathlib import Path
from urllib.request import urlopen
from urllib.parse import urlencode

tempo = "http://localhost:13200"
app = "http://localhost:18080"

for attempt in range(30):
    try:
        with urlopen(tempo + "/ready", timeout=5) as response:
            assert response.status == 200

        for i in range(5):
            with urlopen(app + "/v3/api-docs", timeout=10) as response:
                assert response.status == 200

        time.sleep(5)

        params = urlencode({
            "q": '{ resource.service.name = "postulaciones-svc" }',
            "limit": 20
        })

        with urlopen(
            tempo + "/api/search?" + params,
            timeout=15
        ) as response:
            data = json.load(response)

        traces = data.get("traces", [])
        assert traces, "Todavia no se reciben trazas"

        trace_id = traces[0]["traceID"]

        with urlopen(
            tempo + "/api/traces/" + trace_id,
            timeout=15
        ) as response:
            trace = json.load(response)

        Path("evidencias/tempo-trazas.json").write_text(
            json.dumps(data, indent=2) + "\n"
        )

        Path("evidencias/tempo-detalle-traza.json").write_text(
            json.dumps(trace, indent=2) + "\n"
        )

        print("Tempo: operativo")
        print("Trazas encontradas:", len(traces))
        print("Trace ID:", trace_id)
        print("TRAZABILIDAD VERIFICADA CORRECTAMENTE")
        break

    except Exception as error:
        print(f"Intento {attempt + 1}/30: {error}")
        time.sleep(5)
else:
    raise SystemExit("ERROR: No se encontraron trazas")
PY
