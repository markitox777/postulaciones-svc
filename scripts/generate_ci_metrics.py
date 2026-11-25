
import xml.etree.ElementTree as ET
from pathlib import Path
import time

# Rutas de los archivos
report_path = Path("target/site/jacoco/jacoco.xml")
output_path = Path("monitoring/metrics/ci_metrics.prom")

# Verificar que exista el informe
if not report_path.is_file():
    raise SystemExit("ERROR: No se encontro el informe JaCoCo")

# Leer informe XML
root = ET.parse(report_path).getroot()

metrics = [
    "# HELP ci_test_coverage_percent Cobertura de pruebas JaCoCo",
    "# TYPE ci_test_coverage_percent gauge"
]

# Calcular cobertura por categoria
for counter in root.findall("counter"):
    category = counter.attrib["type"].lower()
    covered = int(counter.attrib["covered"])
    missed = int(counter.attrib["missed"])
    total = covered + missed

    percentage = covered / total * 100 if total else 0

    metrics.append(
        f'ci_test_coverage_percent{{type="{category}"}} {percentage:.2f}'
    )

    print(f"{category.upper()}: {percentage:.2f}%")

# Registrar fecha de generacion
metrics.extend([
    "# HELP ci_metrics_generated_timestamp_seconds Fecha de generacion",
    "# TYPE ci_metrics_generated_timestamp_seconds gauge",
    f"ci_metrics_generated_timestamp_seconds {int(time.time())}"
])

# Guardar metricas
output_path.parent.mkdir(parents=True, exist_ok=True)

output_path.write_text(
    "\n".join(metrics) + "\n",
    encoding="utf-8"
)

print("\nMetricas generadas correctamente")
print(f"Archivo: {output_path}")
