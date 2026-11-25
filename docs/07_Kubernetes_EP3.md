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

1. ¿Por qué utilizar Kubernetes y Minikube?

R: Porque los kubernetes nos permiten administrar y orquestar contenedores, controlar los recursos asignados, comprobar la disponibilidad de los servicios y recuperar automáticamente los contenedores que presentan fallos.
Minikube nos permite ejecutar un clúster de Kubernetes en un entorno de pruebas sin contratar un servicio administrado como AWS EKS, Azure AKS o Google GKE. 
En el proyecto se utilizaron GitHub Codespaces y GitHub Actions para ejecutar este entorno de producción simulada.
2. ¿Cómo se comprobó la recuperación automática?
R: Durante las pruebas eliminamos manualmente un pod del microservicio de postulaciones. Kubernetes detectó que no se cumplía la cantidad de réplicas definida en el Deployment y creó automáticamente un nuevo pod.
El nuevo pod quedó operativo en aproximadamente 26 segundos. Posteriormente, se comprobó la disponibilidad del microservicio mediante Spring Boot Actuator.
Esta prueba nos demuestra la capacidad de recuperación automática, aunque no garantiza disponibilidad continua, porque el microservicio tiene una sola réplica.
3. ¿Qué ventajas tiene automatizar el despliegue mediante GitHub Actions?
R: GitHub Actions nos permite ejecutar automáticamente las pruebas, auditorías de seguridad y despliegues, reduciendo las intervenciones manuales y facilitando la reproducibilidad del proceso.
En nuestro proyecto, el pipeline realiza las siguientes operaciones:
- Ejecuta las pruebas automatizadas y verifica la cobertura.
- Analiza las imágenes mediante Trivy.
- Comprueba la integridad de la imagen auditada mediante SHA-256.
- Despliega el microservicio y las herramientas de observabilidad en Kubernetes.
- Verifica la disponibilidad, las métricas, los logs y las trazas.
- Genera evidencias de los resultados obtenidos.
Si la auditoría detecta vulnerabilidades críticas, el despliegue se bloquea automáticamente.
4. ¿Qué limitaciones tiene utilizar un entorno temporal?
R: Minikube dentro de GitHub Actions nos permitio simular un entorno de producción, pero presenta limitaciones frente a un clúster permanente en la nube.
Los recursos de CPU, memoria y almacenamiento son limitados. Además, el entorno se elimina cuando termina la ejecución del pipeline, por lo que no existe monitoreo continuo después de ese momento.
El proyecto tampoco cuenta con almacenamiento persistente ni múltiples réplicas del microservicio para garantizar alta disponibilidad.

Como mejoras futuras, consideramos servicios administrados de Kubernetes, almacenamiento persistente, escalamiento automático y múltiples réplicas.

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
