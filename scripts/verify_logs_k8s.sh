#!/usr/bin/env bash

set -euo pipefail

cd "$(dirname "$0")/.."

mkdir -p evidencias

kubectl port-forward -n postulaciones \
  svc/loki 13100:3100 \
  > /tmp/loki-verification.log 2>&1 &

LOKI_PID=$!

trap 'kill "$LOKI_PID" 2>/dev/null || true' EXIT

python3 - <<'PY'
import json
import time
from pathlib import Path
from urllib.request import urlopen
from urllib.parse import urlencode

base = "http://localhost:13100"

for attempt in range(30):
    try:
        with urlopen(base + "/ready", timeout=5) as response:
            assert response.status == 200

        params = urlencode({
            "query": '{app="postulaciones-svc"}',
            "limit": 20,
            "start": str(time.time_ns() - 3600 * 10**9)
        })

        with urlopen(
            base + "/loki/api/v1/query_range?" + params,
            timeout=10
        ) as response:
            data = json.load(response)

        assert data["status"] == "success"

        streams = data["data"]["result"]
        count = sum(len(s["values"]) for s in streams)

        assert count > 0, "Todavia no se reciben logs"

        Path("evidencias/loki-logs.json").write_text(
            json.dumps(data, indent=2) + "\n"
        )

        print("Loki: operativo")
        print("Streams encontrados:", len(streams))
        print("Registros encontrados:", count)
        print("CENTRALIZACION DE LOGS VERIFICADA")
        break

    except Exception as error:
        print(f"Intento {attempt + 1}/30: {error}")
        time.sleep(5)
else:
    raise SystemExit("ERROR: Loki no recibe logs")
PY
