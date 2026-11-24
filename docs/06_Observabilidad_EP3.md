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

El monitoreo fue validado mediante Docker Compose.
No se ha validado el monitoreo integrado del cluster Kubernetes.
La sincronizacion requiere un entorno activo y acceso a GitHub.
Los eventos de registro son metricas agregadas, no logs centralizados.

## 9. Justificacion tecnica y toma de decisiones

Pendiente de completar por el estudiante.
