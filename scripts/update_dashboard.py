
import json
from pathlib import Path

ruta = Path(
    "monitoring/grafana/dashboards/postulaciones-dashboard.json"
)

dashboard = json.loads(ruta.read_text(encoding="utf-8"))

datasource = {
    "type": "prometheus",
    "uid": "prometheus"
}


def crear_panel(
    id_panel, titulo, consulta, x, y,
    w=6, h=6, unidad="none",
    tipo="stat", minimo=None, maximo=None
):
    defaults = {
        "unit": unidad,
        "decimals": 0,
        "color": {
            "mode": "fixed",
            "fixedColor": "green"
        }
    }

    if minimo is not None:
        defaults["min"] = minimo

    if maximo is not None:
        defaults["max"] = maximo

    return {
        "id": id_panel,
        "title": titulo,
        "type": tipo,
        "datasource": datasource,
        "gridPos": {
            "x": x,
            "y": y,
            "w": w,
            "h": h
        },
        "pluginVersion": "12.3.0",
        "fieldConfig": {
            "defaults": defaults,
            "overrides": []
        },
        "targets": [
            {
                "refId": "A",
                "datasource": datasource,
                "editorMode": "code",
                "expr": consulta,
                "instant": True,
                "range": False,
                "legendFormat": "{{type}}"
                if tipo == "bargauge" else "__auto"
            }
        ],
        "options": {
            "reduceOptions": {
                "values": False,
                "calcs": ["lastNotNull"],
                "fields": ""
            },
            "orientation": "auto",
            "showPercentChange": False,
            "colorMode": "value",
            "graphMode": "none",
            "textMode": "auto",
            "justifyMode": "auto"
        }
    }


# Sustituir el panel de memoria que daba error.
cobertura_categorias = crear_panel(
    6,
    "Cobertura JaCoCo por categoria",
    'ci_test_coverage_percent{job="ci-cd-metrics"}',
    12, 5,
    w=12,
    h=8,
    unidad="percent",
    tipo="bargauge",
    minimo=0,
    maximo=100
)

cobertura_categorias["options"] = {
    "orientation": "horizontal",
    "displayMode": "gradient",
    "showUnfilled": True,
    "reduceOptions": {
        "values": False,
        "calcs": ["lastNotNull"],
        "fields": ""
    }
}

# Cobertura de lineas.
cobertura_lineas = crear_panel(
    11,
    "Cobertura de pruebas - Lineas",
    'ci_test_coverage_percent{job="ci-cd-metrics",type="line"}',
    0, 29,
    unidad="percent",
    minimo=0,
    maximo=100
)

# Duracion del despliegue.
duracion = crear_panel(
    12,
    "Duracion del despliegue de prueba",
    'ci_deployment_duration_seconds{job="ci-cd-metrics"}',
    6, 29,
    unidad="s"
)

duracion["fieldConfig"]["defaults"]["color"] = {
    "mode": "fixed",
    "fixedColor": "blue"
}

# Resultado del ultimo despliegue exitoso importado.
estado = crear_panel(
    13,
    "Ultimo despliegue exitoso importado",
    'ci_deployment_success{job="ci-cd-metrics"}',
    12, 29
)

estado["fieldConfig"]["defaults"]["mappings"] = [
    {
        "type": "value",
        "options": {
            "0": {
                "text": "FALLIDO",
                "color": "red",
                "index": 0
            },
            "1": {
                "text": "EXITOSO",
                "color": "green",
                "index": 1
            }
        }
    }
]

# Antiguedad de las metricas.
antiguedad = crear_panel(
    14,
    "Antiguedad de las metricas CI/CD",
    'time() - ci_metrics_generated_timestamp_seconds{job="ci-cd-metrics"}',
    18, 29,
    unidad="s"
)

antiguedad["fieldConfig"]["defaults"]["color"] = {
    "mode": "fixed",
    "fixedColor": "orange"
}

# Conservar los paneles existentes que funcionan.
dashboard["panels"] = [
    panel for panel in dashboard["panels"]
    if panel["id"] not in [6, 11, 12, 13, 14]
]

# Incorporar los nuevos paneles.
dashboard["panels"].extend([
    cobertura_categorias,
    cobertura_lineas,
    duracion,
    estado,
    antiguedad
])

dashboard["panels"].sort(
    key=lambda panel: panel["id"]
)

dashboard["version"] = dashboard.get("version", 0) + 1

ruta.write_text(
    json.dumps(dashboard, indent=2, ensure_ascii=False) + "\n",
    encoding="utf-8"
)

print("Dashboard actualizado correctamente.")
print("Cantidad de paneles:", len(dashboard["panels"]))

for panel in dashboard["panels"]:
    print(f"ID: {panel['id']} | {panel['title']}")
