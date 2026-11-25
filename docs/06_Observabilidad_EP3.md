# EP3 - Monitoreo y observabilidad

## 1. Objetivo

Monitorear la disponibilidad, rendimiento y comportamiento
del microservicio postulaciones-svc.

## 2. Herramientas implementadas

- Spring Boot Actuator.
- Micrometer.
- Prometheus.
- Grafana.
- Node Exporter.
- JaCoCo.
- GitHub Actions.
- Grafana Loki.
- Grafana Alloy.
- OpenTelemetry.
- Grafana Tempo.

## 3. Arquitectura de monitoreo

Actuator expone las metricas de la aplicacion.
Prometheus recopila las metricas cada 15 segundos.
Grafana permite visualizar los indicadores.
Node Exporter expone las metricas importadas desde CI/CD.

## 4. Dashboard

Se implementaron 14 paneles que permiten visualizar:

- Disponibilidad del microservicio.
- Consumo de CPU.
- Memoria JVM.
- Tiempo activo.
- Solicitudes HTTP.
- Errores HTTP 5xx.
- Latencia HTTP.
- Eventos de registro.
- Cobertura de pruebas.
- Duracion del despliegue de prueba.
- Resultado del ultimo despliegue exitoso importado.
- Antiguedad de las metricas.

## 5. Integracion CI/CD

El pipeline genera metricas mediante JaCoCo y publica
los resultados como artefactos de GitHub Actions.

Scripts implementados:

- scripts/generate_ci_metrics.py
- scripts/sync_ci_metrics.sh
- scripts/watch_ci_metrics.sh

La sincronizacion automatica consulta las ejecuciones
exitosas cada 60 segundos mientras el script esta activo.

## 6. Resultados registrados

- Estado de salud: UP.
- Cobertura JaCoCo registrada: 100%.
- Duracion de despliegue de prueba registrada: 58 segundos.
- Dashboard de 14 paneles funcionales.

## 7. Evidencias

- [Estado de salud](evidencias/actuator-health.json)
- [Metricas Actuator](evidencias/actuator-metrics.json)
- [Disponibilidad Prometheus](evidencias/prometheus-disponibilidad.json)
- [Metricas CI/CD](evidencias/metricas-ci-cd.txt)

## 8. Limitaciones

El monitoreo fue validado mediante Docker Compose y Kubernetes.
La sincronizacion externa requiere un entorno activo y acceso a GitHub.
Los logs centralizados y las trazas fueron verificados en Kubernetes.
El almacenamiento del cluster es temporal y no productivo.

## 9. Justificacion tecnica y toma de decisiones

Pendiente de completar por el estudiante.


## 10. Centralizacion de logs

Grafana Alloy recopila los registros del microservicio
desde Kubernetes y los envia a Grafana Loki.

Los registros pueden consultarse mediante Grafana Explore
y filtrarse por aplicacion y nivel de registro.

Evidencia:

- [Logs centralizados](evidencias/final/kubernetes/loki-logs.json)

## 11. Trazabilidad

OpenTelemetry instrumenta el microservicio y exporta
las trazas mediante OTLP hacia Grafana Tempo 3.1.1.

La verificacion automatizada recupero 20 trazas
en la ejecucion final del Pull Request.

Evidencias:

- [Trazas recuperadas](evidencias/final/kubernetes/tempo-trazas.json)
- [Detalle de una traza](evidencias/final/kubernetes/tempo-detalle-traza.json)

## 12. Resultados finales de observabilidad

| Indicador | Resultado |
|---|---|
| Cobertura de lineas | 100% |
| Duracion del despliegue del microservicio | 45 segundos |
| Pods disponibles | 7 de 7 |
| Reinicios observados | 0 |
| Trazas recuperadas | 20 |
| Centralizacion de logs | Aprobada |
| Verificacion de monitoreo | Aprobada |

Ejecucion de referencia: 45518995718.

- [Cobertura](evidencias/final/kubernetes/cobertura.json)
- [Duracion](evidencias/final/kubernetes/duracion-despliegue.json)
- [Prometheus](evidencias/final/kubernetes/prometheus-up.json)
- [Grafana](evidencias/final/kubernetes/grafana-health.json)
- [Pipeline aprobado](evidencias/final/pipeline-aprobado.txt)
