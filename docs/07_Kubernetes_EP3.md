# EP3 - Despliegue y orquestacion Kubernetes

## 1. Entorno

- GitHub Codespaces.
- Docker.
- Minikube.
- Kubernetes.
- kubectl.

## 2. Recursos implementados

- Namespace: postulaciones.
- Deployment: postulaciones-svc.
- Service: ClusterIP.
- Replicas: 1.
- Puerto: 8080.

## 3. Archivos de configuracion

- k8s/namespace.yml
- k8s/deployment.yml
- k8s/service.yml
- scripts/deploy_k8s.sh

## 4. Disponibilidad

Se configuraron las siguientes comprobaciones:

- Startup probe.
- Liveness probe.
- Readiness probe.

Se establecieron solicitudes y limites de CPU y memoria.

## 5. Despliegue

Iniciar el cluster:

    minikube start --driver=docker --cpus=2 --memory=3072

Ejecutar el despliegue:

    bash scripts/deploy_k8s.sh

Verificar recursos:

    kubectl get all -n postulaciones

## 6. Resultados obtenidos

- Nodo Kubernetes en estado Ready.
- Microservicio desplegado correctamente.
- Endpoint de salud con respuesta HTTP 200.
- Recuperacion automatica tras eliminar un pod.
- Duracion registrada del despliegue: 52 segundos.

## 7. Integracion con GitHub Actions

Se implemento el workflow security-kubernetes.yml.

El trabajo de despliegue depende de la aprobacion
del trabajo de auditoria de seguridad.

El despliegue automatico fue aprobado mediante GitHub Actions
despues de corregir las vulnerabilidades criticas.

## 8. Evidencias

- [Nodos](evidencias/kubernetes-nodos.txt)
- [Recursos](evidencias/kubernetes-recursos.txt)
- [Deployment](evidencias/kubernetes-deployment.txt)
- [Logs](evidencias/kubernetes-logs.txt)

## 9. Limitaciones

El cluster fue validado en Minikube dentro de Codespaces.
Corresponde a un entorno de pruebas alojado en la nube,
no a un servicio Kubernetes administrado y persistente.

## 10. Justificacion tecnica

Pendiente de completar por el estudiante.

## 11. Validacion del despliegue automatico

GitHub Actions ejecuto correctamente el despliegue
despues de aprobar las auditorias de seguridad.

Resultados:

- Nodo Minikube en estado Ready.
- Kubernetes v1.37.0.
- Pod en estado Running.
- Una replica disponible de una solicitada.
- Cero reinicios del pod observado.
- Servicio ClusterIP en el puerto 8080.
- Verificacion de disponibilidad aprobada.
- Duracion del trabajo de despliegue: 2 minutos y 39 segundos.

Evidencias:

- [Recursos Kubernetes](evidencias/kubernetes-automatico-recursos.txt)
- [Nodos Kubernetes](evidencias/kubernetes-automatico-nodos.txt)
- [Logs del microservicio](evidencias/kubernetes-automatico-logs.txt)

El cluster se ejecuta temporalmente en GitHub Actions.
No corresponde a un entorno productivo permanente.


## 12. Arquitectura final desplegada

| Componente | Funcion |
|---|---|
| postulaciones-svc | Microservicio Spring Boot |
| Prometheus | Recopilacion de metricas |
| Grafana | Visualizacion y consultas |
| Node Exporter | Exposicion de metricas CI/CD |
| Loki | Almacenamiento de logs |
| Alloy | Recopilacion de logs |
| Tempo | Almacenamiento y consulta de trazas |

## 13. Despliegue de imagen auditada

El pipeline construye y audita la imagen del microservicio.

Tras aprobar las auditorias, la imagen se exporta
como artefacto y se genera una suma SHA-256.

El trabajo de despliegue descarga el artefacto,
comprueba su integridad y carga la imagen en Docker.

Minikube utiliza la imagen auditada sin reconstruirla.

## 14. Automatizacion de observabilidad

Scripts implementados:

- scripts/deploy_k8s.sh
- scripts/deploy_monitoring_k8s.sh
- scripts/sync_ci_metrics_k8s.sh
- scripts/verify_monitoring_k8s.sh
- scripts/verify_logs_k8s.sh
- scripts/verify_traces_k8s.sh

El pipeline verifica disponibilidad, metricas,
centralizacion de logs y trazabilidad.

## 15. Validacion final

Ejecucion GitHub Actions: 45518995718.

- Siete pods en estado Running.
- Siete deployments disponibles.
- Cero reinicios observados.
- Despliegue del microservicio: 45 segundos.
- Trabajo completo de despliegue: 4 minutos y 29 segundos.
- Verificaciones automaticas aprobadas.

Evidencias:

- [Recursos](evidencias/final/kubernetes/recursos.txt)
- [Nodos](evidencias/final/kubernetes/nodos.txt)
- [Logs](evidencias/final/kubernetes/logs.txt)
- [Pipeline](evidencias/final/pipeline-aprobado.txt)

El entorno corresponde a un cluster temporal de pruebas
en GitHub Actions. No constituye un despliegue productivo
persistente ni garantiza alta disponibilidad.
